//
//  ExperienceAPI.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/10/23.
//

import Foundation
import SwiftUI

class ExperienceAPI {
    
    public let boundary: String = "Boundary-\(UUID().uuidString)"
    private let createUrl: URL = URL(string: "http://127.0.0.1:5000/experiences/create")!
    private var deleteUrl: URL = URL(string: "http://127.0.0.1:5000/experiences/")!
    
    public func generateRequest(httpBody: Data) -> URLRequest {
        var request = URLRequest(url: self.createUrl)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    public func multipartFormDataBody(_ objName: String, _ obj: NewExperience, _ image: UIImage) -> Data {
            
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
    
    func deleteExperience(id: String) {
        guard let url = URL(string: "\(self.deleteUrl)\(id)") else {fatalError("Missing URL")}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
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
