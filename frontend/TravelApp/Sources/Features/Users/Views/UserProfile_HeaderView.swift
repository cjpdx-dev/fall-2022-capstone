//
//  PrivateUserHeader.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct UserProfile_HeaderView: View {

    var userData: UserModel
    
    var body: some View {
        HStack {
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.gray)
            
            VStack(alignment: .leading) {
                Text(userData.displayName)
                    .font(.title)
                Text(userData.userBio ?? "")
                    .font(.subheadline)
                
                if userData.homeCity != "" {
                    Text(userData.homeCity ?? "")
                        .font(.subheadline)
                }
                if userData.homeCity != "" {
                    Text(userData.homeState ?? "")
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

