//
//  LoginScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/26/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject      var userViewModel:  UserViewModel
    
    @State private var email:       String = ""
    @State private var password:    String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "map.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
            }
            .padding(.vertical)
            
            // form fields
            VStack(spacing: 24) {
    
                LoginInputView(text: $email, title: "Email Address", placeholder: "example@gmail.com")
                    .textInputAutocapitalization(.none)
                
                LoginInputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                
                // sign in button
                Button {
                    handleUserLogin()
                } label: {
                    HStack {
                        Text("Log In")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 48)
                }
                .background(Color(.blue))
                .cornerRadius(12)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Spacer()
            
            NavigationLink {
                SignUpScreen()
                    .navigationBarBackButtonHidden()
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have an account?")
                    Text("Sign Up")
                        .fontWeight(.bold)
                }
            }
        }
        .alert("Login Failed", isPresented: $userViewModel.loginErrorShown) {
            Button("OK", role: .cancel) {userViewModel.loginErrorShown = false}
        } message: {
            Text(userViewModel.loginErrorMessage ?? "An unknown error occurred.")
        }
        .onChange(of: userViewModel.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                dismiss()
            }
        }
    }
    
    func handleUserLogin() {
        DispatchQueue.main.async {
            userViewModel.loginUser(userEmail:     email,
                                    userPassword:  password)
        }
    }
}

#Preview {
    LoginScreen()
}
