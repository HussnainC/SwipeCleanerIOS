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
    @EnvironmentObject private  var appState: AppState
    @State var showSwipe: Bool = false
    
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
                if appState.isLoading {
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.caption)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(appState.files, id: \.id) { file in
                                Button(action: {
                                    if let index = appState.files.firstIndex(where: { $0.id == file.id }) {
                                        appState.selectedPosition = index
                                        showSwipe = true
                                    }
                                }) {
                                    MediaItemView(file: file, appState: appState)
                                        .padding(.horizontal, 16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                //                ScrollView{
                //                    LazyVStack(spacing: 15) {
                //                        ForEach(appState.files, id: \.id) { file in
                //                            Button(action:{
                //                                if let index = appState.files.firstIndex(where: { $0.id == file.id }) {
                //                                           appState.selectedPosition = index
                //                                           showSwipe = true
                //                                       }
                //
                //                            },label: {
                //                                MediaItemView(file: file,appState: appState)
                //                                    .padding(.horizontal, 16)
                //                            }).buttonStyle(PlainButtonStyle())
                //                        }
                //                    }
                //                    .padding(.vertical, 10)
                //                }
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
        }.navigationDestination(isPresented: $showSwipe) {
            SwipeView()
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

private struct MediaItemView: View {
    let file: FileModel
    let appState: AppState
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
                        appState.loadThumbnail(file:file,size:60,onComplete: {img in
                            self.uiImage = img
                        })
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
    
    
    
}

#Preview {
    MediaView(selectedTab: 1).environmentObject(AppState())
}
