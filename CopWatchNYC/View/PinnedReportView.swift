//
//  PinnedReportView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 4/1/23.
//

import SwiftUI

struct PinnedReportView: View {
    @State private var comment: String = ""
    @State private var likes: Int = 100
    @State private var dislikes: Int = 0
    
    var reportTitle: String
    var location: String
    var time: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(reportTitle)
                .font(.title)
            
            Text(description)
                .font(.subheadline)
            
            HStack(alignment: .center) {
                Image(systemName: "location.fill")
                
                Text("Location: \(location)")
                    .font(.caption)
            }
            
            HStack(alignment: .center) {
                Image(systemName: "clock.fill")
                
                Text("Time: \(time)")
                    .font(.caption)
            }
            
            HStack(alignment: .center) {
                Image(systemName: "eye.fill")
                
                Text("Views: \(likes)")
                    .font(.caption)
            }
            
            Divider()
            
            Text("Comments")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<10) { _ in
                        CommentView()
                    }
                }
            }
            
            Divider()
            
            HStack {
                TextField("Add a comment...", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)
                
                Button(action: {}) {
                    Text("Post")
                        .padding(.horizontal, 16)
                }
                .disabled(comment.isEmpty)
                .padding(.trailing, 8)
            }
            .padding(.bottom, 16)
        }
        .padding()
    }
}

struct CommentView: View {
    @State private var likes: Int = 0
    @State private var dislikes: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Username")
                .font(.headline)
            
            Text("This is a comment.")
                .font(.body)
            
            HStack {
                Button(action: {
                    likes += 1
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                    
                    Text("\(likes)")
                }
                
                Button(action: {
                    dislikes += 1
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                    
                    Text("\(dislikes)")
                }
            }
            .font(.caption)
        }
    }
}

struct PinnedReportView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedReportView(reportTitle: "Cop Presence Nearby",
                         location: "695 Park Ave, New York, NY 10065",
                         time: "6:30 PM",
                         description: "Police officers running in the Subway Station")
    }
}
