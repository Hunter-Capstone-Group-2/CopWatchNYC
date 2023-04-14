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
    
    
    var body: some View {
        
        if (currentViewShowing == "login") {
            LogInView(currentShowingView: $currentViewShowing, reportedLocations: $reportedLocations)
                .preferredColorScheme(.light)
        }
        else {
            SignUpView(currentShowingView: $currentViewShowing, reportedLocations: $reportedLocations)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }
        
        
    }
}

struct Authview_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
