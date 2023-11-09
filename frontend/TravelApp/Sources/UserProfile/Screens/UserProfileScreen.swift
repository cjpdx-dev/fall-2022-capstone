//
//  PrivateProfileView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import SwiftUI

struct UserProfileScreen: View {
    
    @State private var privateProfile: UserProfileModel? = nil
    
    @State private var updatedEmail:    String = ""
    @State private var updatedLocation: String = ""
    @State private var updatedBio:      String = ""
    
    init(dummyProfile: UserProfileModel? = nil) {
        if let profileData = dummyProfile {
            _privateProfile = State<UserProfileModel?>(wrappedValue: profileData)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            UserProfile_HeaderView(profile: privateProfile, updatedBio: $updatedBio)
            
            UserProfile_InfoFieldView(
                title: "Email Address",
                placeholder: "Email Address",
                userValue: privateProfile?.userEmail,
                updatedValue: $updatedEmail
            )
            .padding(.horizontal)
            
            UserProfile_InfoFieldView(
                title: "Location",
                placeholder: "Location",
                userValue: privateProfile?.location,
                updatedValue: $updatedLocation
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}


struct PrivateProfileView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileScreen(dummyProfile: .dummy)
        }
        .previewDisplayName("User Profile Preview")
    }
}
