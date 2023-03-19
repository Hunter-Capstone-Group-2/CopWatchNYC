//
//  NavBarView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 3/5/23.
//

import SwiftUI

struct NavBarView: View {

    init() {
        // Set the colour of the unselected tabBar items
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView {
                    Mapview()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    ReportView()
                        .tabItem{
                            Label("Report",
                                  systemImage: "plus.circle.fill")
                        }
                    
                    
                    Accountview()
                        .tabItem {
                            Label("Account", systemImage: "person")
                        }
                }
                .tint(Color.blue) // The color of the tabBar item that is selected
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
        
struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}
