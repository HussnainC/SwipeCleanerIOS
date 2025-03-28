//
//  TopBarView.swift
//  InsectIdentifier
//
//  Created by Hussnain on 12/03/2025.
//

import SwiftUICore
import SwiftUI


struct TopBarView: View {
    var title: String
    var onBack: (() -> Void)?

    var body: some View {
        ZStack {
            HStack{
                Spacer()
                Button(action: {
                    onBack?()
                }) {
                    Image("ic_back")
                        
                        .font(.title2)
                    
                       

                }
            }
            HStack{
                Spacer()
                Text(title)
                    .font(.system(size: 20, weight: .medium)).foregroundColor(.black)
                Spacer()
            }

        }
    }
}

#Preview {
    TopBarView(title: "cl")
}

