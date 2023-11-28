//
//  PrivateProfileView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import SwiftUI

struct UserProfileScreen: View {
    
    @EnvironmentObject var userViewModel:  UserViewModel
    @State private var profileIsPublic:    Bool = false
    @State private var locationIsPublic:   Bool = false
    @Environment(\.dismiss) var dismiss
    
    private var userData: UserModel? {
        userViewModel.getSessionData()?.userData
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            if let userData = userData {
                
                UserProfile_HeaderView(userData: userData)
                
                UserProfile_InfoFieldView(
                    title: "Email Address",
                    placeholder: "Email Address",
                    value: userData.userEmail
                )
                .padding(.horizontal)
                
                HStack {
                    Text("Profile Is Public")
                    Spacer()
                    Toggle("", isOn: $profileIsPublic).toggleStyle(SwitchToggleStyle())
                }
                .padding()
                .onAppear {
                    self.profileIsPublic = userData.profileIsPublic
                }
                
                UserProfile_InfoFieldView(
                    title: "Display Name",
                    placeholder: "Display Name",
                    value: userData.displayName
                )
                .padding(.horizontal)
                
                UserProfile_InfoFieldView(
                    title: "Birth Date",
                    placeholder: "Birth Date",
                    value: userData.birthDate
                )
                .padding(.horizontal)
                
                HStack {
                    Text("Location Is Public")
                    Spacer()
                    Toggle("", isOn: $locationIsPublic).toggleStyle(SwitchToggleStyle())
                }
                .padding()
                .onAppear {
                    self.locationIsPublic = userData.locationIsPublic
                }
                
                if let userCity = userData.homeCity {
                    UserProfile_InfoFieldView(
                        title: "Home City",
                        placeholder: "Home City",
                        value: userCity
                    )
                    .padding(.horizontal)
                }
                
                if let userState = userData.homeState {
                    UserProfile_InfoFieldView(
                        title: "Home State",
                        placeholder: "Home State",
                        value: userState
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                Button {
                    userViewModel.clearSession()
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Sign Out?")
                            .fontWeight(.bold)
                    }
                }
                Divider()
            }
            Spacer()
        }
    }
}



#Preview {
    UserProfileScreen()
}
