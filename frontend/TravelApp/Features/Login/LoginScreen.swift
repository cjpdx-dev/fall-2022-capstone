//
//  LoginScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack {
            VStack(spacing: 50) {
                Text("Travel App")
                    .font(.largeTitle)
                    .bold()
                Image(systemName: "map.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
            }
            .padding(.top)
            
            
            Spacer()
            VStack {
                AppleLoginButton()
                GoogleLoginButton()
                EmailLoginButton()
            }
            .padding(.bottom)
            
        }
        .padding()
    }
}

#Preview {
    LoginScreen()
}
