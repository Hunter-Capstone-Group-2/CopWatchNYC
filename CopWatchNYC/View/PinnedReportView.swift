//
//  PinnedReportView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 4/1/23.
//

import SwiftUI


struct PinnedReportView: View {
    let pin: IdentifiablePin
    @State private var comment: String = ""
    @State private var views: Int = 100
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pin.firstCarouselOption)
                .font(.custom("HelveticaNeue-Bold", size: 26))
                .foregroundColor(.white)

            Text(pin.secondCarouselOption)
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.white)
      
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
            //scrollview made for comment section
            ScrollView {
                        CommentView()
                    }
    
            Divider()
                .foregroundColor(.white)
            
        }
        .padding()
        .background(Color("Color"))
    }
}

struct CommentView: View {
    @State private var commentText = ""
    let commentController = CommentController()
    let pinID = UUID(uuidString: "A8B12EE7-E637-4562-AFDA-A1FBC08CCA7D") ?? UUID()
    let userID = "SQWYDxE9TVeB7s67bx52Kg=="

        
    
    var body: some View {
        VStack {
            TextField("Enter your comment", text: $commentText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                commentController.postComment(commentText: commentText, userID: userID, pinID: pinID) { success in
                    if success {
                        print("Comment posted successfully!")
                        // Perform any necessary actions after successful comment posting
                    } else {
                        print("Failed to post comment.")
                        // Handle error or display an error message
                    }
                }
            }) {
                Text("Post Comment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
}
