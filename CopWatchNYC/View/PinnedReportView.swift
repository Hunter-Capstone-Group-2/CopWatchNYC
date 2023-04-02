//
//  PinnedReportView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 4/1/23.
//

import SwiftUI

struct PinnedReportView: View {
    @State private var comment: String = ""
    @State private var views: Int = 100
    
    var reportTitle: String
    var location: String
    var time: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(reportTitle)
                .font(.custom("HelveticaNeue-Bold", size: 26))
                   .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.white)
            
            HStack(alignment: .center) {
                Image(systemName: "location.fill")
                    .foregroundColor(.white)
                
                Text("Location: \(location)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            HStack(alignment: .center) {
                Image(systemName: "clock.fill")
                    .foregroundColor(.white)
                
                Text("Time: \(time)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            HStack(alignment: .center) {
                Image(systemName: "eye.fill")
                    .foregroundColor(.white)
                
                Text("Views: \(views)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Divider()
                .foregroundColor(.white)
            
            Text("Comments")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<10) { _ in
                        CommentView()
                    }
                }
            }
            
            Divider()
                .foregroundColor(.white)
            
            HStack {
                TextField("Add a comment...", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)
                
                Button(action: {}) {
                    Text("Post")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                }
                .disabled(comment.isEmpty)
                .background(comment.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(5)
                .padding(.trailing, 8)
            }
            .padding(.bottom, 16)
        }
        .padding()
        .background(Color("Color"))
    }
}

struct CommentView: View {
    @State private var likes: Int = 0
    @State private var dislikes: Int = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("This is a comment for testing purposes.")
                    .font(.body)
                    .foregroundColor(.white)
                
                HStack {
                    Button(action: {
                        likes += 1
                    }) {
                        Image(systemName: "hand.thumbsup.fill")
                        
                        Text("\(likes)")
                    }
                    .foregroundColor(.blue)
                    
                    Button(action: {
                        dislikes += 1
                    }) {
                        Image(systemName: "hand.thumbsdown.fill")
                        
                        Text("\(dislikes)")
                    }
                    .foregroundColor(.blue)
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}

struct PinnedReportView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedReportView(reportTitle: "Cop in Subway Station",
                         location: "695 Park Ave, New York, NY 10065",
                         time: "6:30 PM",
                         description: "There are three police officers standing by the turnstiles")
    }
}
