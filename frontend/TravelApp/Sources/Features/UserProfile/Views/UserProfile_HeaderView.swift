//
//  PrivateUserHeader.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct UserProfile_HeaderView: View {

    var profile: UserProfileModel?
        @Binding var updatedBio: String
        
        var body: some View {
            HStack {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.gray)
                
                VStack(alignment: .leading) {
                    if let profileData = profile {
                        Text(profileData.displayName)
                            .font(.title)
                        TextField(profileData.bio, text: $updatedBio)
                            .foregroundColor(.gray)
                    } else {
                        Text("Display Name")
                            .font(.title)
                        Text("User Bio")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .padding(.horizontal)
        }
}

