//
//  SwipeApp.swift
//  Swipe
//
//  Created by Hussnain on 27/03/2025.
//

import SwiftUI

@main
struct SwipeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

}
class AppState: ObservableObject {
    @AppStorage(AppConstants.FIRST_RUN_KEY) var isFirstRun: Bool = true
    @AppStorage(AppConstants.LANG_CODE_KEY) var selectedLanguage: String = "en"
}
