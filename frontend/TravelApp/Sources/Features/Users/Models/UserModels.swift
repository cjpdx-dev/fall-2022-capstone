//
//  NewUser.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/22/23.
//

import Foundation

struct CreateUserModel: Codable {
    var userEmail:              String
    var displayName:            String
    var birthDate:              String
    var userPassword:           String
}

struct UserModel: Codable {
    var id:                     String
    var token:                  String
    
    var userEmail:              String

    var profileIsPublic:        Bool
    var displayName:            String
    var userBio:                String?
    var profileImageURL:        String?

    var locationIsPublic:       Bool
    var homeState:              String?
    var homeCity:               String?
    
    var experiencesArePublic:   Bool
    var experienceIDs:          [String]
    
    var tripsArePublic:         Bool
    var tripIDs:                [String]
}
