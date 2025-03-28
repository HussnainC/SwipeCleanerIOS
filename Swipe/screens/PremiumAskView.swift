//
//  PremiumAsk.swift
//  Swipe
//
//  Created by Hussnain on 28/03/2025.
//
import Foundation
import SwiftUI
struct PremiumAskView : View{
    @State private var withAds:Bool=false
    var body: some View{
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack(alignment:.center, spacing:20){
                VStack(spacing: 5) {
                    Text("Thank You for Installing")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Text("Swipe")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 40)
                Image("premium_ask").resizable().padding(30).scaledToFill().frame(maxWidth: .infinity, maxHeight:225)
                Text( "This app is supported by personalized advertising. The paid version allows you to opt-out of ads and provides access to all Features.").foregroundColor(.gray).font(.system(size: 14, design: .default)).multilineTextAlignment(.center).padding(.top,10)
                VStack(spacing: 15) {
                    Button(action: {
                        withAds=true
                    }){
                        Text("Continue with Ads").padding().foregroundColor(.white).font(.system(size:18,weight:.medium)).frame(maxWidth: .infinity)
                    }.background(Color("primary")).cornerRadius(15).padding(.horizontal,15)
                    
                    Button(action: {
                        
                    }){
                        Text("Premium Upgrade").padding().foregroundColor(.white).font(.system(size:18,weight:.medium)).frame(maxWidth: .infinity)
                    }.background(Color("primary")).cornerRadius(15).padding(.horizontal,15)
                }
                Spacer()
            }.padding()
        }.navigationBarBackButtonHidden().navigationDestination(isPresented: $withAds) {
            HomeView()
        }
      
    }
}

#Preview {
    PremiumAskView()
}
