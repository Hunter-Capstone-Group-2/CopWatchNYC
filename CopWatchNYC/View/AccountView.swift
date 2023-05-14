//
//  AccountView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 2/24/23.
//

import SwiftUI

struct AccountView: View {
    @State private var postsCount: Int = 0
    @State private var likesCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack { // main logo set on top of screen
                Image("Main Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .padding(.top, 50)
                
                //add the auth for the username
                Text("Username/Email")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.white)
                
                VStack(alignment: .center) { // text asking for amount of posts
                    Text("How many Posts do you have?")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(postsCount)") // text for the amount of posts
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .center) { // text of question asking amount of likes
                    Text("How many Likes do you have?")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(likesCount)") // text showing amount of likes
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                VStack {
                    Button(action: {
                        // add the auth for login
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("Color"))
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                    }
                    
                    Button(action: {
                        // add the auth for sign up
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("Color"))
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                    }
                }
            }
            .padding()
            .background( // setting background color with gradient
                LinearGradient(
                    gradient: Gradient(colors: [.black, Color("Color 1")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}
// Live preview for AccountView screen
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
