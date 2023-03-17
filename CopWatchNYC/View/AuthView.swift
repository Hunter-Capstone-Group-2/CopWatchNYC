//
//  Authview.swift
//  copwatch
//
//  Created by Ramy on 2/23/23.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "login" //logging or signing up
    
    
    var body: some View {
        
        if (currentViewShowing == "login") {
            LogInview(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.light)
                
        } else {
            SignUpview(currentShowingView:  $currentViewShowing)
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
