//
//  UserController.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 5/9/23.
//

import Foundation

final class UserController: ObservableObject {
    @Published var user_name: String = ""
    @Published var userID: String = ""
    @Published var users = [User]()
    
    var longitude: Double = -73.985130
    var latitude: Double = 40.758896
    
    init() {}
    
    init(currentUser: User) {
        self.longitude = currentUser.longitude
        self.latitude = currentUser.latitude
        self.user_name = currentUser.user_name
        self.userID = currentUser.userID
    }
    
    func fetchUsers() async throws {
        let urlString = Constants.baseURL + Endpoints.user
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let userResponse: [User] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.users = userResponse
        }
        
    }
    
    func addUser() async throws {
        let urlString = Constants.baseURL + Endpoints.user
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let user = User(user_name: user_name, userID: userID, longitude: longitude, latitude: latitude)
        
        try await HttpClient.shared.sendData(to: url,
                                             object: user,
                                             httpMethod: HttpMethod.POST.rawValue)
    }
    
    
}
