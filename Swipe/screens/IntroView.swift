//
//  IntroView.swift
//  Swipe
//
//  Created by Hussnain on 27/03/2025.
//
import SwiftUI
import PhotosUI

struct IntroModel: Identifiable {
    let id = UUID()
    let title: String
    let des: String
    let img: String
    var video:Bool = false
    var basImage: String = ""

}

struct IntroView : View{
    @EnvironmentObject private var appState: AppState
    let intros: [IntroModel] = [
        IntroModel(title: "Clean Photos", des: "Swipe left to delete unwanted photos instantly", img: "intro_1",basImage: "swipe_left_hand"),
        IntroModel(title: "Keep Photos", des: "Swipe right to save and secure your favorite photos.", img: "intro_2",basImage: "swipe_right_hand"),
        IntroModel(title: "Video cleaner", des: "Manage videos with ease—swipe left to delete or right to save", img: "intro_3",video: true)
    ]
    @State private var pageCurrentIndex: Int? = 0
    
    @State private var shouldMoveNext: Bool = false
    var body: some View{
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button(action:{
                        appState.isFirstRun = false
                        shouldMoveNext.toggle()
                    }){
                        Text("Skip").font(.body).foregroundColor(.black)
                    }
                }.padding(.horizontal).padding(.top)
              
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<intros.count, id: \.self) { i in
                            VStack(spacing:10) {
                                
                                ZStack{
                                    Image(intros[i].img)
                                        .resizable()
                                        .shadow(radius: 5)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                                        .frame(height: 240)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .clipped()
                                    if(intros[i].video){
                                        Image("play_img").resizable().frame(maxWidth:57, maxHeight:68)
                                    }
                                }
                                if(i==intros.count-1){
                                    HStack(alignment: .center){
                                        Spacer()
                                        Image("img_delete").resizable()
                                            .scaledToFill()
                                            .frame(maxWidth:53, maxHeight:53)
                                        Spacer()
                                        Image("img_keep").resizable()
                                            .scaledToFill()
                                            .frame(maxWidth:53, maxHeight:53)
                                        Spacer()
                                    }
                                    Text( "Video cleaner").foregroundColor(.black).font(.system(size: 20, weight: .medium, design: .default))
                                }else{
                                    Image(intros[i].basImage).resizable()
                                        .frame(maxWidth:104, maxHeight:104)
                                        .scaleEffect(x: i==0 ? 1 : -1, y: 1)
                                    
                                    Text( i==0 ? "Clean Photos" : "Keep Photos").foregroundColor(.black).font(.system(size: 20, weight: .medium, design: .default))
                                }
    
                                Text( intros[i].des).foregroundColor(.gray).font(.system(size: 14, design: .default)).multilineTextAlignment(.center)
                              
                            }.id(i).padding(.horizontal,15)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        }
                    }.scrollTargetLayout().frame(width: .infinity, height: .infinity)
                   
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.never)
                .scrollPosition(id: $pageCurrentIndex)
                .padding(.top, 10)
              
                if(pageCurrentIndex==intros.count-1){
                    Button(action: {
                        appState.isFirstRun = false
                        shouldMoveNext.toggle()
                    }){
                        Text("Get Started").padding().foregroundColor(.white).font(.system(size:18,weight:.medium)).frame(maxWidth: .infinity)
                    }.background(Color("primary")).cornerRadius(15).padding(.horizontal,15)
                }else{
                    pagingControl.padding(.top,20)
                }
               
                Spacer()
                
            }.navigationBarBackButtonHidden().navigationDestination(isPresented: $shouldMoveNext) {
                PremiumAskView()
            }
        }
      
    }
   
    var pagingControl: some View {
        HStack {
            ForEach(0..<intros.count,id:\.self) { index in
                Button {
                    withAnimation {
                        pageCurrentIndex = index
                    }
                } label: {
                    Image(systemName: pageCurrentIndex == index ? "circle.fill" : "circle")
                        .foregroundStyle(Color("primary"))
                }
            }
        }
    }
}


#Preview {
    IntroView().environmentObject(AppState())
}
