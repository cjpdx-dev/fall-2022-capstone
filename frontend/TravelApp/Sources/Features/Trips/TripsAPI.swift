//
//  TripsAPI.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/12/23.
//

import Foundation

class TripsAPI {

//    private let baseURL = "https://fall-2023-capstone.wl.r.appspot.com/trips"
    private let baseURL = "http://127.0.0.1:5000/trips"
    
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
    
    enum NetworkError: Error {
        case custom(String)
    }

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
    func createTrip(trip: Trip, token: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = URL(string:"\(baseURL)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try encoder.encode(trip)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.custom("Network error: \(error.localizedDescription)")))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.custom("Invalid response")))
                    return
                }
                if httpResponse.statusCode == 201 {
                    completion(.success(()))
                } else if let data = data,
                          let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                          let message = errorResponse["message"] {
                    completion(.failure(.custom(message)))
                } else {
                    completion(.failure(.custom("Failed to create the trip")))
                }
            }.resume()
        } catch {
            print("Error encoding trip data: \(error)")
            completion(.failure(.custom("Error encoding trip data: \(error.localizedDescription)")))
        }
    }
    
    // PATCH Trip
    func updateTrip(trip: Trip, token: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = URL(string: "\(baseURL)/\(trip.id ?? "")")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try encoder.encode(trip)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.custom("Network error: \(error.localizedDescription)")))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.custom("Invalid response")))
                    return
                }
                if httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else if let data = data,
                            let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                            let message = errorResponse["message"] {
                    completion(.failure(.custom(message)))
                } else {
                    completion(.failure(.custom("Failed to update the trip")))
                }
            }.resume()
        } catch {
            print("Error encoding trip data: \(error)")
            completion(.failure(.custom("Error encoding trip data: \(error.localizedDescription)")))
        }
    }
    
    // DELETE Trip
    func deleteTrip(tripId: String, token: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/\(tripId)")!
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
//        let url = URL(string: "https://fall-2023-capstone.wl.r.appspot.com/experiences/\(experienceId)")!
        let url = URL(string: "http://127.0.0.1:5000/experiences/\(experienceId)")!
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
            print(String(data: data, encoding: .utf8) ?? "No data")   //DEBUG PRINT STATEMENT
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
    
    // GET Experiences for a user
    func getExperiences(completion: @escaping ([Experience]) -> Void) {
//        let url = URL(string: "https://fall-2023-capstone.wl.r.appspot.com/experiences/")!
        let url = URL(string: "http://127.0.0.1:5000/experiences/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            if let data = data, let experiences = try? self.decoder.decode([Experience].self, from: data) {
                DispatchQueue.main.async {
                    completion(experiences)
                }
            }
        }.resume()
    }
}
