//
//  CreatedUserModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/2/23.
//

import Foundation
import SwiftUI

// Defines a struct that represents a server response detailing all records of a User

struct GetUserByID_ClientRequest: Codable {
    var id:                      Int
    // var sessionId:               String
}

struct GetUserByID_ServerResponse: Codable {
    
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
    
    var experiences:             [Int]
    var trips:                   [Int]

}

