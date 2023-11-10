//
//  Data+Extensions.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/9/23.
//

import Foundation

public extension Data {

    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}
