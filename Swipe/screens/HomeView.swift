//
//  LanguageView.swift
//  Swipe
//
//  Created by Hussnain on 27/03/2025.
//

import SwiftUI

struct ButtonModel: Identifiable {
    let id = UUID()
    let title: String
    let img: String
    let destId:Int
    
}
struct HomeView: View {
    let buttons: [ButtonModel] = [
        ButtonModel(title: "Photos", img: "b_image", destId: 1),
        ButtonModel(title: "Videos", img: "b_video", destId: 2)
    ]
    @State private var selectedDes :Int? = nil
    var body: some View {
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack{
                HStack{
                    VStack(alignment: .leading,spacing: 5){
                        Text("Swiper").font(.system(size: 24,weight: .semibold)).foregroundColor(.black)
                        Text("keep your gallery organized").font(.system(size: 14)).foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        selectedDes=0
                    } label: {
                        Image("ic_diamond").resizable().frame(width: 30, height: 30)
                    }
                    
                }
                ScrollView(.vertical){
                    VStack(spacing: 50){
                        ForEach(buttons){b in
                            
                            Button(action: {
                                selectedDes = b.destId
                            }){
                                VStack(spacing:10){
                                    Image(b.img).resizable()
                                       
                                        .aspectRatio(contentMode: .fill)
                                       
                                        .frame(maxHeight:182)
                                        .shadow(radius:5)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                       
                                        .clipped()
                                    Text(b.title).font(.system(size: 16,weight:.medium)).foregroundColor(.black)
                                    
                                        
                                }
                            }
                        }
                    }
                } .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.never).padding(.top,20)
            }.padding()
        }.navigationBarBackButtonHidden().navigationDestination(item: $selectedDes) { destId in
            if destId == 1{
                //PhotoView
            } else if destId == 2{
                //VideoView
            } else if destId == 0{
                //PremiumView
            }
        }
    }
}

#Preview{
    HomeView()
}


