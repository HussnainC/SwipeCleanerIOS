//
//  SwipeApp.swift
//  Swipe
//
//  Created by Hussnain on 27/03/2025.
//

import SwiftUI
import Photos

@main
struct SwipeApp: App {
    @StateObject var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
    
    
}
extension Int64 {
    func formattedDateString(format: String = "dd MMM, yyyy") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
class AppState: ObservableObject {
    @AppStorage(AppConstants.FIRST_RUN_KEY) var isFirstRun: Bool = true
    @AppStorage(AppConstants.LANG_CODE_KEY) var selectedLanguage: String = "en"
    
    @Published var files: [FileModel] = []
    @Published var selectedPosition = 0
    @Published var isLoading: Bool = false

     private var currentMediaType: Int? = nil

    //1 for image, 2 for video
    func loadMediaFiles(mediaType:Int){
        guard currentMediaType != mediaType else { return }
             currentMediaType = mediaType
             isLoading = true
             print("Loading media files...")
        DispatchQueue.global(qos: .background).async {
            var mediaTypePredicate: NSPredicate
            
            if mediaType == 1 {
                mediaTypePredicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            } else {
                mediaTypePredicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = mediaTypePredicate
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let assets = PHAsset.fetchAssets(with: fetchOptions)
            var fileModels: [FileModel] = []
            
            assets.enumerateObjects { (asset, _, _) in
                let fileType = (asset.mediaType == .image) ? 1 : 2
                let id = asset.localIdentifier
                let title = "File \(id.prefix(8))"
                let mimeType = (fileType == 1) ? "image/jpeg" : "video/mp4"
                let dateTime = asset.creationDate?.timeIntervalSince1970 ?? 0
                
                let fileModel = FileModel(id: id, fileType: fileType, title: title, mimeType: mimeType, dateTime: Int64(dateTime))
                
                fileModels.append(fileModel)
            }
            
            DispatchQueue.main.async {
                           self.files = fileModels
                           self.isLoading = false
                       }
        }
    }
    
    func deleteItem() {
        guard selectedPosition < files.count else { return }
        let fileToDelete = files[selectedPosition]
        let assetId = fileToDelete.id
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets)
        }) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    print("File deleted from photo library")
                    self?.files.remove(at: self!.selectedPosition)
                    if self?.selectedPosition ?? 0 >= self?.files.count ?? 0 {
                        self?.selectedPosition = max(0, (self?.files.count ?? 1) - 1)
                    }
                } else {
                    print("Error deleting asset: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    
    func keepItem() {
        selectedPosition += 1
        if selectedPosition >= files.count {
            selectedPosition = files.count - 1
        }
    }
    
    func loadThumbnail(file:FileModel,size:Int,onComplete:@escaping (UIImage?)->Void) {
        let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [file.id], options: nil)
        guard let asset = assetResult.firstObject else { return }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        if file.fileType == 1 {
            manager.requestImage(for: asset, targetSize: CGSize(width: size, height: size), contentMode: .aspectFill, options: options) { image, _ in
                onComplete(image)
            }
        } else {
            let videoOptions = PHVideoRequestOptions()
            videoOptions.deliveryMode = .fastFormat
            manager.requestAVAsset(forVideo: asset, options: videoOptions) { (avAsset, _, _) in
                guard let urlAsset = avAsset as? AVURLAsset else { return }
                self.extractVideoThumbnail(url: urlAsset.url,onComplete: onComplete)
            }
        }
    }
    
    private func extractVideoThumbnail(url: URL,onComplete:@escaping (UIImage?)->Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 1, preferredTimescale: 600)
            do {
                let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: imageRef)
                DispatchQueue.main.async {
                    onComplete(image)
                }
            } catch {
                print("Failed to generate thumbnail: \(error)")
            }
        }
    }
}
