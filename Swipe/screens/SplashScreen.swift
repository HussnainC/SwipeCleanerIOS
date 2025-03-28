//
//  SplashScreen.swift
//  Swipe
//
//  Created by Hussnain on 27/03/2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var moveToNext:Bool = false
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ZStack {
            Color("bgColor").ignoresSafeArea()
            
            VStack {
                Spacer( )
                
                // Welcome Text
                VStack(spacing: 5) {
                    Text("Welcome To")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Text("Swipe") // Replace with your localized string
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 40)
                
                // App Icon
                Image("app_ic") // Replace with your image asset name
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .padding(.bottom, 30)
                
                // Progress Indicator
                VStack(spacing: 10) {
                    ProgressView()
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("primary")))
                        .frame(width: 180, height: 10)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(5)
                }
                .padding(.bottom, 40)
                
                
                // Description Text
                Text("Just getting started? Lets take a tour of this app’s capabilities!")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                // Ads Disclaimer
                Text("This action may contain ads")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }.onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    moveToNext=true
                }
            })
        }.navigationDestination(isPresented:$moveToNext) {
            if(appState.isFirstRun){
                LanguageView()
            }else
            {
                HomeView()
            }
            
        }
    }
}

#Preview {
    SplashScreen().environmentObject(AppState())
}

