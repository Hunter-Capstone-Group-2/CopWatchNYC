import SwiftUI

struct NavBarView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var reportedLocations: [IdentifiablePin]

    // Initialize the NavBarView with the binding for reportedLocations
    init(reportedLocations: Binding<[IdentifiablePin]>) {
        self._reportedLocations = reportedLocations
        // Set the color of the unselected tabBar items
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    var body: some View {
        // Use NavigationView to enable navigation between views
        NavigationView {
            // Use a ZStack to overlay views
            ZStack(alignment: .bottom) {
                // Use TabView to create a tab bar interface
                TabView {
                    // Display MapView as the first tab
                    MapView(reportedLocations: $reportedLocations)
                        .tabItem {
                            // Set the tab item's label and system image
                            Label("Home", systemImage: "house")
                        }
                    
                    // Display ReportView as the second tab
                    ReportView(reportedLocations: $reportedLocations)
                        .environmentObject(locationManager)
                        .tabItem {
                            // Set the tab item's label and system image
                            Label("Report", systemImage: "plus.circle.fill")
                        }
                    
                    // Display Accountview as the third tab
                    Accountview()
                        .tabItem {
                            // Set the tab item's label and system image
                            Label("Account", systemImage: "person")
                        }
                }
                // Uncomment the following line to set the color of the selected tabBar item
                //.tint(Color.blue)
            }
        }
        // Hide the navigation bar's back button
        .navigationBarBackButtonHidden(true)
    }
}

// Create a preview for the NavBarView
struct NavBar_Previews: PreviewProvider {
    @State static private var reportedLocations: [IdentifiablePin] = []
    
    static var previews: some View {
        // Instantiate the NavBarView with the preview data and environment object
        NavBarView(reportedLocations: $reportedLocations)
            .environmentObject(LocationManager())
    }
}
