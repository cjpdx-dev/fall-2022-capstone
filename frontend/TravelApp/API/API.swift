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
    func fetchUser(completion: @escaping (User?) -> Void) {
        
        let url = URL(string: "https://our-gcp-project-url.com/user")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let user = try? JSONDecoder().decode(User.self, from: data)
            completion(user)
            
        }.resume()
    }
    
}
