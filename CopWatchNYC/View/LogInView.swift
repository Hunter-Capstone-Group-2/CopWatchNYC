//
//  Loginview.swift
//  copwatch
//
//  Created by Ramy on 2/23/23.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import Firebase

struct LogInview: View {
    @Binding var currentShowingView: String
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack{
                Color("Color").edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Text("CopWatchNYC")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "mail")
                        TextField("Email", text: $email)
                            .foregroundColor(.white)
                            .colorScheme(.dark)
                            
                        
                        Spacer()
                        
                        if(email.count != 0) {
                            
                            Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(email.isValidEmail() ? .green : .red)
                            
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    }
                    
                    .padding()
                    
                    
                    HStack {
                        Image(systemName: "lock")
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                            .colorScheme(.dark)
                        
                        Spacer()
                        
                        if(password.count != 0) {
                            Image(systemName: password.isValidPassword(password) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(password.isValidPassword(password) ? .green : .red)
                        }
                        
                        
                    }
                    .foregroundColor(.white)
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    }
                    
                    .padding()
                    
                    Button(action: {
                        withAnimation {
                            self.currentShowingView = "signup"
                        }
                        
                        
                    }) {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.5))
                        
                    }
                    
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            // if user is authorized change view to mapview
                            if let authResult = authResult {
                                let user = authResult.user
                                print(user.uid)
                                
                                if user.isEmailVerified {
                                    path.append("NavBarView")
                                } else {
                                    print("user not email verified")
                                }

                            }
                            
                        }
                        
                    }, label: {
                        Text("Sign in")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color.black )
                            )
                            .padding(.horizontal )
                        
                    })
                    
                    Button(action: {
                        
                        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                        
                        // Create Google Sign In configuration object.
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config
                        
                        // Start the sign in flow!
                        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                            guard error == nil else {
                                // ...
                                return
                            }
                            
                            guard let user = result?.user,
                                  let idToken = user.idToken?.tokenString
                            else {
                                // ...
                                return
                            }
                            
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                           accessToken: user.accessToken.tokenString)
                            
                            Auth.auth().signIn(with: credential) { result, error in
                                guard error == nil else {
                                    return
                                }
                                
                                print("Signed In")
                            }
                        }
                        
                    }) {
                        HStack {
                            Image("Google Logo")
                                .resizable()
                                .frame(width: 35.0, height: 35.0)
                            Text(" Continue with Google")
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.black )
                    )
                    .padding(.horizontal )
                    
                    // sets path to mapview upon clicking
                    .navigationDestination(for: String.self) { view in
                        if view == "NavBarView" {
                            NavBarView()
                        }
                    }
                    
                    
                }
                
            }
        }
        
        .onAppear {
            // if logged in when app runs, navigate to map and skip login
            if Auth.auth().currentUser != nil {
                path.append("NavBarView")
            }
        }
    }
    
}
