//
//  LoginScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct AuthScreen: View {
    var body: some View {
        
        VStack {
            VStack(spacing: 50) {
                Text("CrowdTrekk")
                    .font(.largeTitle)
                    .bold()
                Image("travel-icon")
                    .resizable()
                    .frame(width: 250, height: 250)
            }
            .padding(.top)
            
            Spacer()
            VStack {
                EmailLoginButton()
            }
            .padding(.bottom)
            
        }
        .padding()
    }
}

#Preview {
    AuthScreen()
}
