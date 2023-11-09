//
//  TripModel.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import Foundation
import SwiftUI

struct DatedExperience: Hashable, Codable {
    var experience: String
    var date: Date
}

struct Trip: Hashable, Codable, Identifiable {
    
    var id: Int
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date
    var experiences: [DatedExperience]
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}
