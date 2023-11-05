//
//  API.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/25/23.
//

import Foundation



/* @escaping indicates the closure can escape the function i.e. the closure might be called after the function returns. Since the closure
   might outlive the fuction call's scope, we need to mark it as escaping.
 */
class API {
    

    let CONSTS = APIConsts()
    
    func createUser(with createdUser: CreatedUserModel,
                        completion: @escaping (Result<CreatedUserModel, APIError>) -> Void) {

        guard let url = URL(string: "\(CONSTS.GCLOUD_ROOT_URL)/user") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(createdUser)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.encodingFailed))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(description: error.localizedDescription)))
                return
            }
            
            do {
                let createdUserResponse = try JSONDecoder().decode()
            }
        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(.requestFailed(description: error.localizedDescription)))
//                return
//            }
//            
//            do {
//                let userProfile = try JSONDecoder().decode(UserProfileModel.self, from: data!)
//                completion(.success(userProfile))
//            } catch {
//                completion(.failure(.decodingFailed))
//            }
//            
//        }
//        .resume()
//        
        
    }
    
    func fetchUserProfile(completion: @escaping (UserProfileModel?) -> Void) {
        // CHANGE TO USE OUR ACTUAL PROJECT URL
        
        let url = URL(string: API_CONSTANTS.ROOT_URL)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let userProfile = try? JSONDecoder().decode(UserProfileModel.self, from: data)
            completion(userProfile)
            
        }.resume()
    }
    
}
