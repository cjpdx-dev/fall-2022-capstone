//
//  ExperienceAPI.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/10/23.
//

import Foundation
import SwiftUI

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class ExperienceAPI {
    
    public let boundary: String = "Boundary-\(UUID().uuidString)"
     let developmentUrl: URL = URL(string: "http://127.0.0.1:5000/experiences/")!
//     var productionUrl: URL = URL(string: "https://fall-2023-capstone.wl.r.appspot.com/experiences/")!
    
    public func generateCreateRequest(httpBody: Data, httpMethod: HTTPMethod, token: String) -> URLRequest {
        var request = URLRequest(url: self.developmentUrl)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func generateUpdateRequest(httpBody: Data, httpMethod: HTTPMethod, id: String, token: String) -> URLRequest {
        let urlString = "https://fall-2023-capstone.wl.r.appspot.com/experiences/\(id)"
        let updateUrl = URL(string: urlString)
        var request = URLRequest(url: updateUrl!)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    public func multipartFormDataBodyNewExperience(_ objName: String, _ obj: NewExperience, _ image: UIImage) -> Data {
            
        let lineBreak = "\r\n"
        var body = Data()
        let encoder = JSONEncoder()
        guard let bodyData = try? encoder.encode(obj) else {
            print("Error")
            return Data()
        }
        
        // Append the NewExperience object to the form
        body.append("--\(self.boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(objName)\"\(lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(bodyData)
        body.append("\(lineBreak)")
        
        
        // Append the image data to the form
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append("--\(self.boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(uuid).jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(image.jpegData(compressionQuality: 0.99)!)
            body.append(lineBreak)
        }
        
        
        body.append("--\(self.boundary)--") // End multipart form and return
        return body
    }
    
    public func multipartFormDataBodyUpdateExperience(_ objName: String, _ obj: Experience, _ image: UIImage?) -> Data {
            
        let lineBreak = "\r\n"
        var body = Data()
        let encoder = JSONEncoder()
        guard let bodyData = try? encoder.encode(obj) else {
            print("Error")
            return Data()
        }
        
        // Append the NewExperience object to the form
        body.append("--\(self.boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(objName)\"\(lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(bodyData)
        body.append("\(lineBreak)")
        
        if image != nil {
            // Append the image data to the form
            if let uuid = UUID().uuidString.components(separatedBy: "-").first {
                body.append("--\(self.boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(uuid).jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                body.append(image!.jpegData(compressionQuality: 0.99)!)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(self.boundary)--") // End multipart form and return
        return body
    }
    
    func deleteExperience(id: String, token: String) {
        guard let url = URL(string: "\(self.developmentUrl)\(id)") else {fatalError("Missing URL")}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 204 {
                print("Experience deleted successfully")
            }
            else {
                print("Couldn't delete Experience")
            }
        }
        dataTask.resume()
    } 
}
