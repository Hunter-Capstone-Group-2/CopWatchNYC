//
//  Pin.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/16/23.
//

import Foundation

struct Pin: Codable {
    var userID: String
    var confirmed: Bool
    var longitude: Double
    var latitude: Double
}
