//
//  TripsAPI.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/12/23.
//

//import Foundation
//
//class TripsAPI {
//    private let baseURL = "http://127.0.0.1:8080/trips"
//    
//    // JSON Decoder and Encoder for handling Date
//        private let decoder: JSONDecoder = {
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            return decoder
//        }()
//
//        private let encoder: JSONEncoder = {
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .iso8601
//            return encoder
//        }()
//
//    
//    // GET Trips
//    func getTrips(completion: @escaping ([Trip]) -> Void) {
//        let url = URL(string: "\(baseURL)/")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Network error: \(error)")
//                return
//            }
//            if let data = data, let trips = try? self.decoder.decode([Trip].self, from: data) {
//                DispatchQueue.main.async {
//                    completion(trips)
//                }
//            }
//        }.resume()
//    }
//}
