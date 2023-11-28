//
//  APIError.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/1/23.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(description: String)
    case noData
    case decodingFailed
    case encodingFailed
    case serverError(statusCode: Int)
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let description):
            return "The request failed: \(description)"
        case .noData:
            return "No data received from the server."
        case .decodingFailed:
            return "Failed to decode the data."
        case .encodingFailed:
            return "Failed to encode the data."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
