//
//  API.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import Foundation



class UserAPI {
    
    let baseURL = "http://127.0.0.1:5000"
    
    struct LoginResponse: Codable {
        let user: UserModel
        let token: String
    }
    
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
            print(data)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                let loginResponse = try? JSONDecoder().decode(UserModel.self, from: data)
                print("UsersAPI.swift: Create Accout Successful")
                print("Login Response: \(loginResponse)")
                completion(loginResponse)
            } else {
                completion(nil)
                print("UsersAPI.swift: Create Account Failed")
                return
            }
        }.resume()
    }
    
    
    
    func loginUser(userEmail: String, userPassword: String, completion: @escaping (UserModel?) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(nil)
            return
        }

        let loginDetails = [
            "email": userEmail,
            "password": userPassword
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginDetails, options: []) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let loginResponse = try? JSONDecoder().decode(UserModel.self, from: data)
                completion(loginResponse)
            } else {
                completion(nil)
            }
        }.resume()
    }
    // Additional methods for auth user and fetch user
}
