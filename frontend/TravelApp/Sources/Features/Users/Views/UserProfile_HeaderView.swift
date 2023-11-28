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

