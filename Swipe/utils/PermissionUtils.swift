//
//  PermissionUtils.swift
//  Swipe
//
//  Created by Hussnain on 28/03/2025.
//

import Photos


class PermissionUtils{
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            print("Access granted ✅")
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    print("Access granted ✅")
                    completion(true)
                } else {
                    print("Access denied ❌")
                    completion(false)
                }
            }
        case .denied, .restricted, .limited:
            print("Access denied ❌")
            completion(false)
        @unknown default:
            print("Unknown status")
        }
    }
}
