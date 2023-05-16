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
import Combine

struct LogInView: View {
    @Binding var currentShowingView: String
    @Binding var reportedLocations: [IdentifiablePin]
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage = ""
    @State private var path = NavigationPath()
    @State private var isPasswordVisible = false
    @Binding var isLoggedIn: Bool
    @State private var currentViewShowing: String = "login"
    @State private var showSignUpView = false
    @State private var isSignedUp = false
    @State private var isShowingPasswordResetAlert = false
 
      

    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack{
                Color("Color").edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Spacer(minLength: 0)
                        Image("Main Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom, -50)
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, -30)
                        .padding(.bottom, -50)
                        .multilineTextAlignment(.center)
                    
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
                        
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .foregroundColor(.white)
                                .colorScheme(.dark)
                        } else {
                            SecureField("Password", text: $password)
                                .foregroundColor(.white)
                                .colorScheme(.dark)
                        }
                        
                        Spacer()
                        
                        if(password.count != 0) {
                            Image(systemName: password.isValidPassword(password) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(password.isValidPassword(password) ? .green : .red)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .frame(width: 5, height: 10)
                                .scaleEffect(1)
                                .padding(9)
                            
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
                    
                    Button("Forgot Password?") {
                        if email.isEmpty {
                            isShowingPasswordResetAlert = true
                            
                        } else {
                            Auth.auth().sendPasswordReset(withEmail: email) { error in
                                if let error = error {
                                    // Handle error
                                    print("Error sending password reset email: \(error.localizedDescription)")
                                } else {
                                    // Password reset email sent successfully
                                    let alert = UIAlertController(title: "Email Sent", message: "Password Reset Email Sent.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    .alert(isPresented: $isShowingPasswordResetAlert) {
                        if email.isEmpty {
                            return Alert(
                                title: Text("Email Required"),
                                message: Text("Please enter your email address to reset your password."),
                                dismissButton: .default(Text("OK"))
                            )
                        } else {
                            return Alert(
                                title: Text("Email Sent"),
                                message: Text("Password Reset Email Sent."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 5)
                    .padding(.horizontal, -72)
                    
                    
                    HStack {
                        
                        Button(action: {
                            withAnimation {
                                showSignUpView = true
                            }
                            
                            
                        }) {
                            Text("Don't have an account?")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 55)
                            
                        }
                        .padding(5)
                        
                  
                        
                    }
                    
                    
                    
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print(error.localizedDescription)
                                
                                if (error.localizedDescription == "The password is invalid or the user does not have a password.") {
                                    errorMessage = "The email or password is invalid!"
                                } else if (error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                    errorMessage = "The account does not exist!"
                                } else if (error.localizedDescription == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.") {
                                    errorMessage = "Account locked because of too many attempts. Please try again later."
                                } else {
                                    return
                                }
                                
                            }
                            // if user is authorized change view to mapview
                            if let authResult = authResult {
                                let user = authResult.user
                                isLoggedIn = true
                                
                                
                                
                                if user.isEmailVerified {
                                    errorMessage = ""
                                    isLoggedIn = true
                               
                                } else {
                                    errorMessage = "The email is not verified"
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
                                isLoggedIn = true
                         
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
                        if view == "Home" {
                            Home(reportedLocations: $reportedLocations)
                        }
                    }
                }
                .padding(.bottom, 200)
                .sheet(isPresented: $showSignUpView) {
                    SignUpView(currentShowingView: $currentViewShowing, reportedLocations: $reportedLocations, isSignedUp: $isSignedUp)
                        .onReceive(Just(isSignedUp)) { newValue in
                            if newValue {
                                print("User signed in!")
                                showSignUpView = false
                            }
                            else {
                                showSignUpView = true
                            }
                        }
                }
        }
        }
    }
}


