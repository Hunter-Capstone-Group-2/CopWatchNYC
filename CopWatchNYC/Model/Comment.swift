//
//  Comment.swift
//  CopWatchNYC
//
//  Created by Ramy on 5/11/23.
//

import Foundation

    struct Comment: Codable {
        var id: String
        var pinID: UUID
        var comment: String
        var created: String
        var userID: String
    }
