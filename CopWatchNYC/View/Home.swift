//
//  Home.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/11/23.
//
import SwiftUI
struct Home: View {
    
    init(reportedLocations: Binding<[IdentifiablePin]>) {
        self._reportedLocations1 = reportedLocations
        // Set the color of the unselected tabBar items
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    @State var selectedTab: String = "home"
    @State private var reportedLocations: [IdentifiablePin] = []
    @Binding var reportedLocations1: [IdentifiablePin]
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            TabView(selection: $selectedTab) {
                
                MapView(reportedLocations: $reportedLocations)
                    .tag("home")
                
                Accountview()
                    .tag("user")
                
                ReportView(reportedLocations: $reportedLocations)
                    .tag("report")
                    //.environmentObject(locationManager)
                
                
            }
            
            //Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
            
        }
        .background(Color("Color 2"))
        
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home(reportedLocations1: $reportedLocations)
//    }
//}

