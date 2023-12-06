//
//  TripModel.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import Foundation
import SwiftUI

struct Trip: Hashable, Codable, Identifiable {
    
    var id: String?
    var name: String
    var description: String
    var startDate: String
    var endDate: String
    var user: String?
    var experiences: [String]
    
    var formattedDateRange: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let startDateDate = inputFormatter.date(from: startDate) ?? Date()
        let endDateDate = inputFormatter.date(from: endDate) ?? Date()
        return "\(outputFormatter.string(from: startDateDate)) - \(outputFormatter.string(from: endDateDate))"
    }
}
