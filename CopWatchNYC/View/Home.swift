//
//  Home.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/11/23.
//

import SwiftUI

struct Home: View {
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State var selectedTab: String = "home"
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            TabView(selection: $selectedTab) {
                
                MapView()
                    .tag("home")
                
                Accountview()
                    .tag("user")
                
                ReportView()
                    .tag("report")
                
                
            }
            
            //Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
            
        }
        .background(Color("Color 2"))
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}




