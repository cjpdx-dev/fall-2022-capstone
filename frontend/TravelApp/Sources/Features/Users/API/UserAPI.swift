//
//  API.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import Foundation




class UserAPI {
    
    struct ErrorResponse: Codable {
        let message: String
    }
    
    let baseURL = "http://127.0.0.1:5000"
    
    func createUser(user: CreateUserModel, completion: @escaping (UserModel?) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            // print(data)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                let loginResponse = try? JSONDecoder().decode(UserModel.self, from: data)
                print("UsersAPI.swift: Create Accout Successful")
                completion(loginResponse)
            } else {
                completion(nil)
                print("UsersAPI.swift: Create Account Failed")
                return
            }
        }.resume()
    }
    
    func loginUser(userEmail: String, userPassword: String, completion: @escaping (UserModel?) -> Void) {
        
        print(userEmail)
        print(userPassword)
        
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(nil)
            return
        }

        let loginDetails = [
            "userEmail": userEmail,
            "userPassword": userPassword
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginDetails, options: []) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(nil)
                return
            }
        
            switch httpResponse.statusCode {
            case 200:
                do {
                    let loginResponse = try JSONDecoder().decode(UserModel.self, from: data)
                    completion(loginResponse)
                } catch {
                    print("Decoding error (200): \(error.localizedDescription)")
                    completion(nil)
                }
                
            default:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    print("Server Error: \(errorResponse.message)")
                } catch {
                    print("Decoding error (non 200): \(error.localizedDescription)")
                }
                completion(nil)
            }
        }.resume()
    }
    // Additional methods for auth user and fetch user
}
