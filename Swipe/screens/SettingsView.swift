//
//  PremiumVIew.swift
//  Swipe
//
//  Created by Hussnain on 28/03/2025.
//

import SwiftUI

struct SettingsView:View {
    @Environment(\.presentationMode) var presentationMode
    private let settingButtons: [ButtonModel] = [
        ButtonModel(title: "About us", img: "ic_about", destId: 1),
        ButtonModel(title: "Privacy Policy", img: "ic_privacy", destId: 2),
        ButtonModel(title: "Change Language", img: "ic_language", destId: 3),
        ButtonModel(title: "Premium upgrade", img: "ic_premium", destId: 4),
        ButtonModel(title: "Share App", img: "ic_share", destId: 5),
    ]
    @State private var selectedIndex: Int? = nil
    @State private var shouldShareApp:Bool = false
    var body: some View {
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack{
                TopBarView(title: "Settings",onBack: {
                    presentationMode.wrappedValue.dismiss()
                }).padding(.horizontal)
                ScrollView{
                    LazyVStack{
                        ForEach(settingButtons,id: \.id) {b in
                            Button{
                                if b.destId==1 || b.destId==2 || b.destId==3 || b.destId==4{
                                    selectedIndex = b.destId
                                }else if b.destId==5{
                                    shouldShareApp = true
                                }
                            } label: {
                                HStack(spacing:20){
                                    Image(b.img)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text(b.title)
                                        .font(.system(size: 16 ,weight:.medium))
                                        .foregroundColor(.black)
                                }.frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                    .padding(.vertical, 18)
                                    .padding(.horizontal, 15)
                                    .background(Color("bgColor"))
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                            }.buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                        }
                    }
              
                }.padding(.top,30)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.never)
            }.padding(.vertical)
        }.navigationBarBackButtonHidden().sheet(isPresented: $shouldShareApp) {
            ShareSheet(items: ["Check out this amazing app! Download it here: https://example.com"])
        }.navigationDestination(item: $selectedIndex) { destination in
            if destination == 1 {
                //AboutUs
                AboutUsView()
            }else if destination == 2 {
                //PrivacyPolicy
                PrivacyView()
            }else if destination == 3 {
                //ChangeLanguage
                LanguageView()
            }else if destination == 4 {
                //PremiumUpgrade
                PremiumView()
            }
        }
        
    }
    
}
private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        uiViewController.excludedActivityTypes=[.saveToCameraRoll]
    }
}

#Preview {
    SettingsView()
}
