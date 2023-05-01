//
//  AddPinController.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/16/23.
//

import Foundation

final class AddPinController: ObservableObject {
    @Published var latitude: Double = 40.758896
    @Published var longitude: Double = -73.985130
    
    var testUserID = "3H7sGKCeQLSxH50x0V2pcw=="
    var confirmed: Bool = true
    
    init() { }
    
    init(currentPin: Pin) {
        self.longitude = currentPin.longitude
        self.latitude = currentPin.latitude
        self.confirmed = currentPin.confirmed
        self.testUserID = currentPin.userID
    }
    
    func addPin() async throws {
        let urlString = Constants.baseURL + Endpoints.pin
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let pin = Pin(userID: testUserID, confirmed: confirmed, longitude: longitude, latitude: latitude)
        
        try await HttpClient.shared.sendData(to: url,
                                             object: pin,
                                             httpMethod: HttpMethod.POST.rawValue)
    }
    
}