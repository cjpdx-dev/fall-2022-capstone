//
//  PrivateProfileView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import SwiftUI

struct UserProfileScreen: View {
    @EnvironmentObject var userViewModel:   UserViewModel
    @State private  var userData =          SessionManager.shared.getSessionData()?.userData
    @State private  var profileIsPublic:    Bool = false
    @State private  var locationIsPublic:   Bool = false
    @Environment(\.dismiss) var dismiss
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
                
                UserProfile_InfoFieldView(
                    title: "Home City",
                    placeholder: "Home City",
                    value: userData.homeCity ?? ""
                )
                .padding(.horizontal)
                
                UserProfile_InfoFieldView(
                    title: "Home State",
                    placeholder: "Home State",
                    value: userData.homeCity ?? ""
                )
                .padding(.horizontal)
                
                Divider()
                
                Button {
                    handleLogOut()
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
    
    func handleLogOut() {
        DispatchQueue.main.async {
            SessionManager.shared.clearSession()
            dismiss()
        }
    }
}



#Preview {
    UserProfileScreen()
}
