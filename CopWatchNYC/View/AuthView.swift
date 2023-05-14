//
//  Authview.swift
//  copwatch
//
//  Created by Ramy on 2/23/23.
//

import SwiftUI


struct AuthView: View {
    @State private var currentViewShowing: String = "login" // logging or signing up
    @State private var reportedLocations: [IdentifiablePin] = []
    //@Binding var reportedLocations: [IdentifiablePin]
    @State private var isLoggedIn = false
    
    var body: some View {
        
        if (currentViewShowing == "login") {
        
            LogInView(currentShowingView: $currentViewShowing, reportedLocations: $reportedLocations, isLoggedIn: $isLoggedIn)
                .preferredColorScheme(.light)
        }
        else {
            SignUpView(currentShowingView: $currentViewShowing, reportedLocations: $reportedLocations)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
         
        }
        
        
    }
}


