//
//  PrivacyView.swift
//  Swipe
//
//  Created by Hussnain on 28/03/2025.
//
import SwiftUI

struct AboutUsView:View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color("bgColor").ignoresSafeArea()
            VStack{
                TopBarView(title: "About Us") {
                    presentationMode.wrappedValue.dismiss()
                }
                ScrollView{
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Privacy Policy for File Recovery App")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("1. Information We Collect")
                            .font(.system(size: 14, weight: .semibold))
                        Text("We collect limited personal information (e.g., name, email) for support and user engagement. Usage data (app statistics) is collected anonymously for app improvement.")
                            .font(.system(size: 14))
                        
                        Text("2. How We Use Your Information")
                            .font(.system(size: 14, weight: .semibold))
                        Text("We use personal data for customer support, updates, and app enhancements. Usage data helps us improve app performance.")
                            .font(.system(size: 14))
                        
                        Text("3. Data Sharing")
                            .font(.system(size: 14, weight: .semibold))
                        Text("We share personal info with trusted service providers under strict confidentiality. No data is sold or shared for marketing.")
                            .font(.system(size: 14))
                        
                        Text("4. Security")
                            .font(.system(size: 14, weight: .semibold))
                        Text("We employ reasonable security measures to protect your data.")
                            .font(.system(size: 14))
                        
                        Text("5. Your Choices")
                            .font(.system(size: 14, weight: .semibold))
                        Text("You can opt out of promotional emails.")
                            .font(.system(size: 14))
                        
                        Text("6. Updates")
                            .font(.system(size: 14, weight: .semibold))
                        Text("We may update this policy; significant changes will be communicated.")
                            .font(.system(size: 14))
                    }
                    .padding(.vertical)
                }
            }.padding()
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    AboutUsView()
}
