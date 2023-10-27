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
                Image(systemName: "apple.logo")
                Text("Sign In With Google")
                    
            }
            .frame(width: UIScreen.main.bounds.width - 50, height:45)
            .foregroundColor(.white)
            .background(Color(.gray))
            .cornerRadius(12)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
        .padding(.bottom)
    }
}

#Preview {
    GoogleLoginButton()
}
