//
//  AddPinController.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/16/23.
//

import Foundation

final class AddPinController: ObservableObject {
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var userID: String = "YMDZkCD2R/KXj+BFX0+b9g==" // ""
    @Published var report: String = ""
    @Published var report_detail: String = ""
    @Published var report_location: String = ""
    @Published var pins = [Pin]()
    
    //testUserID = "YMDZkCD2R/KXj+BFX0+b9g=="
    var confirmed: Bool = true
    
    init() { }
    
    init(currentPin: Pin) {
        self.longitude = currentPin.longitude
        self.latitude = currentPin.latitude
        self.confirmed = currentPin.confirmed
        self.userID = currentPin.userID
        self.report = currentPin.report
        self.report_detail = currentPin.report_detail
        self.report_location = currentPin.report_location
    }
    
    func addPin() async throws {
        let urlString = Constants.baseURL + Endpoints.pin
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let pin = Pin(userID: userID, confirmed: confirmed, longitude: longitude, latitude: latitude, report: report, report_detail: report_detail, report_location: report_location)
        
        try await HttpClient.shared.sendData(to: url,
                                             object: pin,
                                             httpMethod: HttpMethod.POST.rawValue)
    }
    
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
    
    
