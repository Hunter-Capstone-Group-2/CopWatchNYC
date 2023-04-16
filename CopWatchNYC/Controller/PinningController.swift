//
//  PinningController.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/16/23.
//

import SwiftUI

class PinningController: ObservableObject {
    @Published var pins = [Pin]()
    
    func fetchPins() async throws {
        let urlString = Constants.baseURL + Endpoints.pin
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let pinResponse: [Pin] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.pins = pinResponse
        }
        
    }
    
}
