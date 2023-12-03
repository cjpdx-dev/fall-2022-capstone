//
//  PrivateProfileView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import SwiftUI

struct UserProfileScreen: View {
    
    @EnvironmentObject 
    var userViewModel: UserViewModel
    
    @State private var profileIsPublic:         Bool = false
    @State private var locationIsPublic:        Bool = false
    @State private var experiencesArePublic:    Bool = false
    @State private var tripsArePublic:          Bool = false
    
    @State private var editableHomeState    = ""
    @State private var editableHomeCity     = ""
    @State private var editableBio          = ""
    @State private var editableDisplayName  = ""
    
    @State private var fieldsAreEditable = false
    
    
    @Environment(\.dismiss)
    var dismiss
    
    private var userData: UserModel? {
        userViewModel.getSessionData()?.userData
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            if let userData = userData {
                
                HStack {
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.gray)
                    
                    VStack(alignment: .leading) {
                        
                        Text(userData.displayName)

                        if let userBio = userData.userBio {
                        Text(userBio)
                            .font(.subheadline)
                        }
                        
                        if let userCity = userData.homeCity{
                            Text(userCity)
                                .font(.subheadline)
                        }
                        
                        if let userState = userData.homeState{
                            Text(userState)
                            .font(.subheadline)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action:  {
                        fieldsAreEditable = !fieldsAreEditable
                    }) {
                        if !fieldsAreEditable {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                        if fieldsAreEditable {
                            Image(systemName: "app.badge.checkmark")
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                UserProfile_InfoFieldView(title: "Display Name", placeholder: "Display Name", value: userData.displayName)
                .padding(.horizontal)
                .disabled(!fieldsAreEditable)

                HStack {
                    Text("Profile Is Public")
                    Spacer()
                    Toggle("", isOn: $profileIsPublic).toggleStyle(SwitchToggleStyle())
                }
                .onAppear {
                    profileIsPublic = userData.profileIsPublic
                }
                .padding(.horizontal)
                .disabled(!fieldsAreEditable)
                
                if let userBio = userData.userBio {
                    UserProfile_InfoFieldView(title: "Bio", placeholder: "Bio", value: userBio)
                    .padding(.horizontal)
                    .disabled(!fieldsAreEditable)
                    
                } else {
                    UserProfile_InfoFieldView(title: "Bio", placeholder: "Bio", value: editableBio)
                    .padding(.horizontal)
                    .disabled(!fieldsAreEditable)
                }
                
                HStack {
                    Text("Experiences Are Public")
                    Spacer()
                    Toggle("", isOn: $locationIsPublic).toggleStyle(SwitchToggleStyle())
                }
                .onAppear {
                    experiencesArePublic = userData.experiencesArePublic
                }
                .padding(.horizontal)
                .disabled(!fieldsAreEditable)
                
                HStack {
                    Text("Trips Are Public")
                    Spacer()
                    Toggle("", isOn: $locationIsPublic).toggleStyle(SwitchToggleStyle())
                }
                .onAppear {
                    tripsArePublic = userData.tripsArePublic
                }
                .padding(.horizontal)
                .disabled(!fieldsAreEditable)
                
                
                HStack {
                    Text("Location Is Public")
                    Spacer()
                    Toggle("", isOn: $locationIsPublic).toggleStyle(SwitchToggleStyle())
                }
                .onAppear {
                    locationIsPublic = userData.locationIsPublic
                }
                .padding(.horizontal)
                .disabled(!fieldsAreEditable)
                
                
                if let userCity = userData.homeCity {
                    UserProfile_InfoFieldView(title: "Home City", placeholder: "Home City", value: userCity)
                    .padding(.horizontal)
                    .disabled(!fieldsAreEditable)
                    
                } else {
                    UserProfile_InfoFieldView(title: "Home City", placeholder: "Home City", value: editableHomeCity)
                    .padding(.horizontal)
                    .disabled(!fieldsAreEditable)
                }
                
                
                if let userState = userData.homeState {
                    UserProfile_InfoFieldView(title: "Home State", placeholder: "Home State", value: userState)
                    .padding(.horizontal)
                    .disabled(!fieldsAreEditable)
                    
                } else {
                    UserProfile_InfoFieldView(title: "Home State", placeholder: "Home State", value: editableHomeState)
                    .padding(.horizontal)
                    .disabled(!fieldsAreEditable)
                }
                
                UserProfile_InfoFieldView(title: "Email Address", placeholder: "Email Address", value: userData.userEmail)
                .padding(.horizontal)
                .disabled(!fieldsAreEditable)
                
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
