//
//  AppleLoginButton.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct AppleLoginButton: View {
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "apple.logo")
                Text("Sign In With Apple")
                
            }
            .frame(width: 300, height:45)
            .foregroundColor(.white)
            .background(Color(.black))
            .cornerRadius(12)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
        .padding(.bottom)
    }
}

#Preview {
    AppleLoginButton()
}
