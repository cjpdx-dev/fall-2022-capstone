//
//  PutUserModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/2/23.
//

import Foundation

struct PatchUser_ClientRequest: Codable {
    var id:                      Int
    
    var profileIsPublic:         Bool?
    var nickname:                String?
    var bio:                     String?
    
    var homeLocationIsPublic:    Bool?
    var homeCity:                String?
    var homeState:               String?
}

struct PatchUser_ServerResponse: Codable {
    
    var id:                      Int
    
    var sessionId:               String
    var accountCreationDateTime: Date
    var lastSessionDateTime:     Date
    var birthYear:               Int
    
    var profileIsPublic:         Bool
    var nickname:                String
    var bio:                     String
    
    var homeLocationIsPublic:    Bool
    var homeCity:                String
    var homeState:               String

}
