//
//  UserProfileModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import Foundation

struct UserProfileModel: Codable {
    var displayName: String
    var userEmail: String
    var location: String
    var bio: String
    var experiences: [Int]
    var trips: [Int]
}

extension UserProfileModel {
    static var dummy: UserProfileModel {
        return UserProfileModel(
            displayName: "John Doe",
            userEmail: "johndoe@example.com",
            location: "Santa Fe, NM",
            bio: "A simple traveler...",
            experiences: [1, 2, 3, 4],
            trips: [1, 2, 3, 4]
        )
    }
}
