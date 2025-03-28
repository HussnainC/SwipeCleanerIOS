//
//  LanguageView.swift
//  Swipe
//
//  Created by Hussnain on 27/03/2025.
//

import SwiftUI


struct LanguageModel: Identifiable {
    let id = UUID()
    let title: String
    let code: String
    let flag: String
}

struct LanguageView: View {
    @StateObject private var appState = AppState()
    @Environment(\.presentationMode) var presentationMode
    @State private var currentLang : String = "en"

    @State private var navigateToIntro = false
    let languages: [LanguageModel] = [
        LanguageModel(title: "English", code: "en", flag: "flag_en"),
        LanguageModel(title: "Spanish", code: "es", flag: "flag_es"),
        LanguageModel(title: "Portuguese", code: "pt", flag: "flag_pt"),
        LanguageModel(title: "Hindi", code: "hi", flag: "flag_in"),
        LanguageModel(title: "Korean", code: "kr", flag: "flag_kr"),
        LanguageModel(title: "French", code: "fr", flag: "flag_fr")
    ]
    init(){
        currentLang = self.appState.selectedLanguage
    }

    var body: some View {
        ZStack{
            Color("bgColor").ignoresSafeArea()
       
            VStack {
                TopBarView(title: "Change Language",onBack: {
                    if(!appState.isFirstRun)
                    {
                        presentationMode.wrappedValue.dismiss()
                    }
                       
                }).padding()
                
                ScrollView {
                    LazyVStack {
                        ForEach(languages) { item in
                            Button(action: {
                                currentLang = item.code
                                if appState.isFirstRun {
                                    navigateToIntro = true
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                HStack {
                                    Image(item.flag)
                                        .resizable()
                                        .frame(width: 31, height: 31)
                                    
                                    Text(item.title)
                                        .font(.body)
                                        .padding(.leading, 5)
                                    
                                    Spacer()
                                    
                                    if item.code == currentLang {
                                        Image("lang_check")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                .padding(.vertical, 18)
                                .padding(.horizontal, 15)
                                .background(Color("bgColor"))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                        }
                    }.padding(.top,10)
                    
                }
                Spacer()
                Button(action:{
                    appState.selectedLanguage = currentLang
                    if(appState.isFirstRun){
                        presentationMode.wrappedValue.dismiss()
                    }else
                    {
                        navigateToIntro=true
                    }
                }){
                    Text("Done").padding(.vertical,12).padding(.horizontal,20).background(Color("primary")).cornerRadius(20).foregroundColor(.white)
                }.buttonStyle(DefaultButtonStyle())
            }
            
        }.navigationBarBackButtonHidden().navigationDestination(isPresented: $navigateToIntro) {
            IntroView()
        }
    }
}



#Preview{
    LanguageView()
}


