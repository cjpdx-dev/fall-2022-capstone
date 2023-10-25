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
            
        } label: {
            Text("Sign Up With Email")
                .frame(width: 300, height:45)
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
