//
//  Constants.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/13/23.
//

import Foundation

enum Constants {
    //static let baseURL = "http://127.0.0.1:8080/"
    static let baseURL = "http://copwatch.fly.dev/"
    static let testUserIDHosted = "cBGhOblkR5WkkoUj0zDDKQ=="
}

enum Endpoints {
    static let pin = "pin"
    static let user = "user"
}

enum HttpMethod: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}
enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}



