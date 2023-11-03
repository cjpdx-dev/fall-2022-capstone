//
//  GoogleLoginButton.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct GoogleLoginButton: View {
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Image("google-logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                Text("Sign In With Google")
                    
            }
            .frame(width: UIScreen.main.bounds.width - 50, height:45)
            .foregroundColor(.black)
            .background(Color(.white))
            .cornerRadius(12)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
        .padding(.bottom)
    }
}

#Preview {
    GoogleLoginButton()
}
