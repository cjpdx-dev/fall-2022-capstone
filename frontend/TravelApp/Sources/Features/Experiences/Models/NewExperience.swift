//
//  NewExperience.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/9/23.
//

import Foundation

struct NewExperience: Codable {
    // DONT FORGET TO ADD RATING, KEYWORDS, AND USERID
    var title: String
    var description: String
    var state: String
    var city: String
    var rating: Int
    var keywords: [String]
    var date: Date
    
}
