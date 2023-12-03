//
//  ExperienceData.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import Foundation
import Observation

@Observable
class ExperienceData {
    var experiences: [Experience] = []

    
    func getExperiences(token: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/experiences") else {fatalError("Missing URL")}
//        let productionUrl: URL = URL(string: "https://fall-2023-capstone.wl.r.appspot.com/experiences/")!
        
        var urlRequest = URLRequest(url: url)
//        let urlRequest = URLRequest(url: productionUrl)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let decodedExperiences = try decoder.decode([Experience].self, from: data)
                        self.experiences = decodedExperiences
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
}

var experiences: [Experience] = load("experienceData.json")


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data


    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
