//
//  AuthController.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/4/23.
//

import Foundation

import AuthenticationServices

func authorizationController(controller: ASAuthorizationController, 
                             didCompleteWithAuthorization authorization: ASAuthorization)
{
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        
        if let identityTokenData = appleIDCredential.identityToken,
           let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
            
            sendIdentityTokenToServer(identityToken: identityTokenString)
        }
        
    }
    
}


func sendIdentityTokenToServer(identityToken: String) {
    
    let urlString = "httpsL//localhost:8080/auth/apple"
    guard let url = URL(string: urlString) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ["identityToken": identityToken]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
    } catch {
        print("Error: canot create JSON from token")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: could not send ident token to server")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("Error: Server returned invalid status code")
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], 
                
                let success = json["success"] as? Bool {
                    print("Server token verification \(success ? "succeeded" : "failed")")
            }
        } catch {
            print("Could not parse server response")
                      
            }
               
        }
        
    }
