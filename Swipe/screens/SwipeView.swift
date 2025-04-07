//
//  SwipeView.swift
//  Swipe
//
//  Created by Hussnain on 07/04/2025.
//

import SwiftUI

struct SwipeView : View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var appState: AppState
    
    @State private var offset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var uiImage: UIImage? = nil
    let swipeThreshold: CGFloat = 150
    var body: some View {
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack{
                TopBarView(title: "Swiper",onBack: {
                    presentationMode.wrappedValue.dismiss()
                    
                }).padding()
                
                if appState.selectedPosition < appState.files.count{
                    VStack{
                        let file = appState.files[appState.selectedPosition]
                        
                        ZStack {
                            
                            VStack {
                                // Image
                                ZStack{
                                    if let image = uiImage {
                                        Image(uiImage: image)
                                            .resizable()
                                        
                                    } else {
                                        ProgressView()
                                        
                                    }
                                }
                            }.onAppear{
                                appState.loadThumbnail(file:file,size:400,onComplete: {img in
                                    self.uiImage = img
                                })
                            }.onChange(of: file.id) { oldValue, newValue in
                                if oldValue != newValue{
                                    self.uiImage = nil
                                    appState.loadThumbnail(file:file,size:400,onComplete: {img in
                                        self.uiImage = img
                                    })
                                }
                                
                            }
                            // Labels
                            if offset > 50 {
                                Text("KEEP")
                                    .font(.headline)
                                    .bold()
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    .rotationEffect(.degrees(-15))
                                    .offset(x: -60, y: -150)
                            } else if offset < -50 {
                                Text("DELETE")
                                    .font(.headline)
                                    .bold()
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    .rotationEffect(.degrees(15))
                                    .offset(x: 60, y: -150)
                            }
                        }
                        .background(Color.white)
                        .shadow(radius: 5).clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        .padding()
                        .offset(x: offset)
                        .rotationEffect(.degrees(rotation))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation.width
                                    rotation = Double(offset / swipeThreshold * 15)
                                }
                                .onEnded { _ in
                                    if abs(offset) > swipeThreshold {
                                        if offset > 0 {
                                            appState.keepItem()
                                        } else {
                                            appState.deleteItem()
                                        }
                                    }
                                    withAnimation {
                                        offset = 0
                                        rotation = 0
                                    }
                                }
                        )
                        .animation(.easeInOut, value: offset)
                        
                        Spacer()
                        HStack {
                            Text(file.title).foregroundColor(.gray) .font(.caption)
                            Spacer()
                            Text(file.dateTime.formattedDateString()).foregroundColor(.gray) .font(.caption)
                        }
                        .padding(.horizontal)
                        
                        Text("\(appState.selectedPosition +  1)/\(appState.files.count)")
                            .padding(.top, 4)
                            .font(.caption).foregroundColor(.gray)
                    }
                }
                Spacer()
                HStack(alignment: .center){
                    Spacer()
                    TabButton(title: "Delete", icon: "ic_delete", isSelected: true, onTabClick: {
                        appState.deleteItem()
                    })
                    Spacer()
                    Spacer()
                    TabButton(title: "Keep", icon: "ic_keep", isSelected: true, onTabClick: {
                        appState.keepItem()
                    })
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .shadow(color: Color("primary").opacity(0.5), radius: 3, x: 0, y: -1)
            }
            
        }.navigationBarBackButtonHidden()
    }
    
    
}

#Preview {
    SwipeView().environmentObject(AppState())
}
