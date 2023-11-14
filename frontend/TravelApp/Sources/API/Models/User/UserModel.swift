//
//  UserModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/12/23.
//
//
//import Foundation
//
//struct UserModel: Codable, Identifiable {
//    
//    var id:                     String
//    
//    var auth:                   UserAuthModel
//    var profile:                UserProfileModel
//    var userLocation:           UserLocationModel
//    
//    var experiencesArePublic:   Bool
//    var experienceIDs:          [String]
//    
//    var tripsArePublic:         Bool
//    var tripIDs:                [String]
// 
//    enum CodingKeys: String, CodingKey {
//        case id
//        
//        case auth
//        case profile
//        case userLocation
//        
//        case experiencesArePublic
//        case tripsArePublic
//        
//        case experienceIDs
//        case tripIDs
//        
//    }
//    
//    init(from decoder: Decoder) throws {
//        
//        let container        = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id                   = try container.decode(String.self, forKey: .id)
//        
//        auth                 = try container.decode(UserAuthModel.self, forKey: .auth)
//        profile              = try container.decode(UserProfileModel.self, forKey: .profile)
//        userLocation         = try container.decode(UserLocationModel.self, forKey: .userLocation)
//        
//        experiencesArePublic = try container.decode(Bool.self, forKey: .experiencesArePublic)
//        experienceIDs        = try container.decode([String].self, forKey: .experienceIDs)
//        
//        tripsArePublic       = try container.decode(Bool.self, forKey: .tripsArePublic)
//        tripIDs              = try container.decode([String].self, forKey: .tripIDs)
//    }
//    
//}
