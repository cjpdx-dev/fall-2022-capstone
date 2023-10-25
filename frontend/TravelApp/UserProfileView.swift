//
//  UserProfileView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import SwiftUI

/*
 var displayName: String
 var userEmail: String
 var location: String
 var bio: String
 var experiences: [Int]
 var trips: [Int]
 */

struct UserProfileView: View {
    
    @State private var user: User? = nil
    
    @State private var updatedEmail: String = ""
    @State private var updatedLocation: String = ""
    @State private var updatedBio: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.gray)
                
                VStack(alignment: .leading) {
                    if let userData = user {
                        Text(userData.displayName)
                            .font(.title)
                        TextField(userData.bio, text: $updatedBio)
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
            
            VStack(alignment: .leading, spacing: 15) {
                if let userData = user {
                    Text("Email Address")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField(userData.userEmail, text: $updatedEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Location")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField(userData.location, text: $updatedLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                } else {
                    Text("Email Address")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("Email Address", text: $updatedEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Location")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("Location", text: $updatedLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            API().fetchUser { fetchedProfile in
                self.user = fetchedProfile
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
