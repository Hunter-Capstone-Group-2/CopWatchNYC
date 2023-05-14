//
//  AccountView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 2/24/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

struct AccountView: View {
    @State private var postsCount: Int = 0
    @State private var likesCount: Int = 0
    @State var userEmail: String = ""
    @State private var showAuthView = false
    @State private var userSignedIn = false
    @State private var currentViewShowing: String = "login"
    @State private var reportedLocations: [IdentifiablePin] = []
    @State private var isLoggedIn = false



    
    var body: some View {
        NavigationView {
            VStack {
                Image("Main Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .padding(.top, 50)
                
                    .onAppear {
                        // Update authentication status when the AccountView appears
                        if let user = Auth.auth().currentUser {
                            userEmail = user.email ?? "Not Signed In"
                        }
                    }
                Text("\(userEmail)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.white)
                
                
                VStack(alignment: .center) {
                    Text("How many Posts do you have?")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(postsCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .center) {
                    Text("How many Likes do you have?")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(likesCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                VStack {
                    Button(action: {
                        showAuthView = true
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
                        do {
                            try Auth.auth().signOut()
                            isLoggedIn = false
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }) {
                        Text("Sign out")
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
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.black, Color("Color 1")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            .navigationBarTitle("Account")
            .sheet(isPresented: $showAuthView) {
                LogInView(currentShowingView: $currentViewShowing, reportedLocations: $reportedLocations, isLoggedIn: $isLoggedIn)
                    .onReceive(Just(isLoggedIn)) { newValue in
                        if newValue {
                            print("User signed in!")
                            showAuthView = false
                        }
                        else {
                            showAuthView = true
                        }
                    }
            }
        }


            .onAppear {
                // Update authentication status when the AccountView appears
                if let user = Auth.auth().currentUser {
                    userEmail = user.email ?? "Not Signed In"
                } else {
                    userEmail = "Not Signed In"

                }
            }
        }
    }



// Live preview for AccountView screen
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
