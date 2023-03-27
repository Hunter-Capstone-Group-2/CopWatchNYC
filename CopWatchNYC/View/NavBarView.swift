//  NavBarView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 3/5/23.
//

import SwiftUI

struct NavBarView: View {

    // Set the color of the unselected tabBar items
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView {
                    // Add a Map view to the tabBar items
                    MapView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    // Add a Report view to the tabBar items
                    ReportView()
                        .tabItem{
                            Label("Report",
                                  systemImage: "plus.circle.fill")
                        }
                    
                    // Add an Account view to the tabBar items
                    AccountView()
                        .tabItem {
                            Label("Account", systemImage: "person")
                        }
                }
                // Set the color of the selected tabBar item
                .tint(Color.yellow)
            }
        }
        // Hide the back button in the navigation bar
        .navigationBarBackButtonHidden(true)
    }
}
        
struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}
