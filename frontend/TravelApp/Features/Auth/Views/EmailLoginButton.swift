//
//  EmailLoginButton.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct EmailLoginButton: View {
    var body: some View {
        Button {
            // Show LoginScreen
        } label: {
            Text("Sign Up With Email")
                .frame(width: UIScreen.main.bounds.width - 50, height:45)
                .foregroundColor(.white)
                .background(Color(.blue))
                .cornerRadius(12)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
        .padding(.bottom)
    }
}

#Preview {
    EmailLoginButton()
}
