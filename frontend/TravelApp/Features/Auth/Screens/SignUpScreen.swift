//
//  SignInScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/26/23.
//

import SwiftUI

struct SignUpScreen: View {
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 150, height: 150)
        }
        .padding(.vertical)
        
        VStack(spacing: 24) {
            InputView(text: $email, title: "Email Address", placeholder: "example@gmail.com")
                .textInputAutocapitalization(.none)
            
            InputView(text: $firstName, title: "Enter first name", placeholder: "John")
            
            InputView(text: $lastName, title: "Enter last name", placeholder: "Doe")
            
            InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
            
            InputView(text: $confirmPassword, title: "Password", placeholder: "Confirm your password", isSecureField: true)
            
            // sign in button
            Button {
                print("Create Account")
            } label: {
                HStack {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 50, height: 48)
            }
            .background(Color(.systemCyan))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        Spacer()
        
        Button {
            dismiss()
        } label: {
            HStack(spacing: 3) {
                Text("Already have an account?")
                Text("Log in")
                    .fontWeight(.bold)
            }
        }
        
    }
}

#Preview {
    SignUpScreen()
}
