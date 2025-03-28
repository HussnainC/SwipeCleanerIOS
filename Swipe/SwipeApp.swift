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
class AppState: ObservableObject {
    @AppStorage(AppConstants.FIRST_RUN_KEY) var isFirstRun: Bool = true
    @AppStorage(AppConstants.LANG_CODE_KEY) var selectedLanguage: String = "en"
    
    @Published var files: [FileModel] = []
    
    //1 for image, 2 for video
    func loadMediaFiles(mediaType:Int){
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
                   }
               }
    }
}
