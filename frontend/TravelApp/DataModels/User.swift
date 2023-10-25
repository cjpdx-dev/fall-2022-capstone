//
//  User.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import Foundation

struct User: Codable {
    var displayName: String
    var userEmail: String
    var location: String
    var bio: String
    var experiences: [Int]
    var trips: [Int]
}
