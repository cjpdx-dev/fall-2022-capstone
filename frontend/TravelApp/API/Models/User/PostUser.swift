//
//  User.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/2/23.
//

import Foundation

struct PostUser_ClientRequest: Codable {
    
    var birthYear:               Int
    
    var profileIsPublic:         Bool
    var nickname:                String
    var bio:                     String?
    
    var homeLocationIsPublic:    Bool
    var homeCity:                String?
    var homeState:               String?
    
}

struct PostUser_ServerResponse: Codable {
    
    var id:                      Int
    
    var accountCreationDateTime: Date
    var birthYear:               Int
    
    var profileIsPublic:         Bool
    var nickname:                String
    var bio:                     String?
    
    var homeLocationIsPublic:    Bool
    var homeCity:                String?
    var homeState:               String?
    
    var experiences:             [Int]
    var trips:                   [Int]
    
}
