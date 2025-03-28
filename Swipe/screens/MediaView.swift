//
//  PremiumVIew.swift
//  Swipe
//
//  Created by Hussnain on 28/03/2025.
//

import SwiftUI
import Photos

struct MediaView:View {
    @State var selectedTab: Int = 1
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack{
                VStack{
                    HStack{
                        VStack(alignment: .leading,spacing: 5){
                            Text("Swiper").font(.system(size: 24,weight: .semibold)).foregroundColor(.black)
                            Text("keep your gallery organized").font(.system(size: 14)).foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("ic_back").font(.title2)
                        }
                        
                    }
                }.padding(.top).padding(.horizontal)
                ScrollView{
                    LazyVStack(spacing: 15) {
                        ForEach(appState.files, id: \.id) { file in
                            MediaItemView(file: file)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 10)
                }
                HStack(alignment: .center){
                    Spacer()
                    TabButton(title: "Photos", icon: "ic_photos", isSelected: selectedTab==1, onTabClick: {
                        selectedTab = 1
                    })
                    Spacer()
                    Spacer()
                    TabButton(title: "Videos", icon: "ic_videos", isSelected: selectedTab==2, onTabClick: {
                        selectedTab = 2
                    })
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .shadow(color: Color("primary").opacity(0.5), radius: 3, x: 0, y: -1)
            }
        }.navigationBarBackButtonHidden().onAppear{
            appState.loadMediaFiles(mediaType: selectedTab)
        }.onChange(of: selectedTab) { oldValue, newValue in
            if oldValue != newValue {
                appState.loadMediaFiles(mediaType: newValue)
            }
        }
    }
    
    
    struct TabButton:View {
        let title: String
        let icon:String
        let isSelected:Bool
        let onTabClick: (() -> Void)
        var body: some View {
            Button {
                onTabClick()
            } label: {
                VStack(spacing:5){
                    Image(icon).resizable().scaledToFill().frame(width: 35, height: 26)
                    Text(title).font(.caption).foregroundColor(.black)
                }.opacity(isSelected ? 1 : 0.3)
            }
            
        }
    }
}

private struct MediaItemView: View {
    let file: FileModel
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            } else {
                ProgressView()
                    .frame(width: 60, height: 60)
                    .onAppear {
                        loadThumbnail()
                    }
            }
            VStack(alignment: .leading) {
                Text(file.title)
                    .font(.headline).foregroundColor(.black)
                Text(file.mimeType)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
    
    private func loadThumbnail() {
        let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [file.id], options: nil)
        guard let asset = assetResult.firstObject else { return }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        if file.fileType == 1 {
            manager.requestImage(for: asset, targetSize: CGSize(width: 60, height: 60), contentMode: .aspectFill, options: options) { image, _ in
                self.uiImage = image
            }
        } else {
            let videoOptions = PHVideoRequestOptions()
            videoOptions.deliveryMode = .fastFormat
            manager.requestAVAsset(forVideo: asset, options: videoOptions) { (avAsset, _, _) in
                guard let urlAsset = avAsset as? AVURLAsset else { return }
                self.extractVideoThumbnail(url: urlAsset.url)
            }
        }
    }
    
    private func extractVideoThumbnail(url: URL) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 1, preferredTimescale: 600)
            do {
                let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: imageRef)
                DispatchQueue.main.async {
                    self.uiImage = image
                }
            } catch {
                print("Failed to generate thumbnail: \(error)")
            }
        }
    }
    
}


#Preview {
    MediaView(selectedTab: 1).environmentObject(AppState())
}
