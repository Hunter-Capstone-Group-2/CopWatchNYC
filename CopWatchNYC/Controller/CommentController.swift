//
//  CommentController.swift
//  CopWatchNYC
//
//  Created by Ramy on 5/10/23.
//

import Foundation

final class  CommentController: ObservableObject{
    @Published var id: String = ""
    @Published var pinID: String = ""
    @Published var comment: String = ""
    @Published var created: String = ""
    @Published var userID: String = ""
    
    func fetchComments(completion: @escaping ([Comment]) -> Void) {
        let url = URL(string: "https://copwatch.fly.dev/comment")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching comments: \(error?.localizedDescription ?? "")")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let comments = try decoder.decode([Comment].self, from: data)
                completion(comments)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
    
    func postComment(commentText: String, userID: String, pinID: UUID, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://copwatch.fly.dev/comment")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let commentData: [String: Any] = [
            "comment": commentText,
            "userID": userID,
            "pinID": pinID.uuidString
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: commentData, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                    print("Error posting comment: \(error?.localizedDescription ?? "")")
                    completion(false)
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    print("Failed to post comment. Status code: \(httpResponse.statusCode)")
                    completion(false)
                }
            }.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(false)
        }
    }
}
