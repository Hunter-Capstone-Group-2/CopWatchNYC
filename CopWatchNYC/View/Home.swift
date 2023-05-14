//
//  Home.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 4/11/23.
//

import SwiftUI

struct Home: View {

    @State var selectedTab: String = "home"
    @Binding var reportedLocations: [IdentifiablePin]

    var body: some View {

        VStack(spacing: 0) {

            TabView(selection: $selectedTab) {

                MapView(reportedLocations: $reportedLocations)
                    .tag("home")

                AccountView()
                    .tag("user")

                CreateReportView(reportedLocations: $reportedLocations, selectedTab: $selectedTab)
                    .tag("report")

                
            }

            //Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)

        }
        .background(Color("Color 2"))

    }
}


//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//
//        Home()
//    }
//}



