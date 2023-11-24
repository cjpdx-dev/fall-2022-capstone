//
//  TripsAPI.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/12/23.
//

import Foundation

class TripsAPI {
    private let baseURL = "https://fall-2023-capstone.wl.r.appspot.com/trips"

    // JSON Decoder and Encoder for handling Date
        private let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()

        private let encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return encoder
        }()

    
    // GET Trips
    func getTrips(completion: @escaping ([Trip]) -> Void) {
        let url = URL(string: "\(baseURL)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            if let data = data, let trips = try? self.decoder.decode([Trip].self, from: data) {
                DispatchQueue.main.async {
                    completion(trips)
                }
            }
        }.resume()
    }
    
    // POST Trip
    func createTrip(trip: Trip, completion: @escaping (Bool) -> Void) {
        let url = URL(string:"\(baseURL)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let jsonData = try encoder.encode(trip)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error)")
                    completion(false)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    completion(true)
                } else {
                    completion(false)
                }
            }.resume()
        } catch {
            print("Error encoding trip data: \(error)")
            completion(false)
        }
    }
    
    // PATCH Trip
    func updateTrip(trip: Trip, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/\(trip.id ?? "")")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
            let jsonData = try encoder.encode(trip)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error)")
                    completion(false)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            }.resume()
        } catch {
            print("Error encoding trip data: \(error)")
            completion(false)
        }
    }
    
    // DELETE Trip
    func deleteTrip(tripId: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/\(tripId)")!
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(false)
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // GET Experience
    func getExperience(experienceId: String, completion: @escaping (Experience?) -> Void) {
        let url = URL(string: "https://fall-2023-capstone.wl.r.appspot.com/experiences/\(experienceId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            if let experience = try? self.decoder.decode(Experience.self, from: data) {
                DispatchQueue.main.async {
                    completion(experience)
                }
            } else {
                print("Error decoding experience")
                completion(nil)
            }
        }.resume()
    }
}
