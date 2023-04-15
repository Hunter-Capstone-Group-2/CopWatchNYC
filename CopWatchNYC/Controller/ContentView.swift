import SwiftUI

// The ContentView is the root view of the application.
struct ContentView: View {
    // Declare a LocationManager object to manage user location updates.
    @StateObject private var locationManager = LocationManager()
    // Declare a state variable to store reported locations as an array of IdentifiablePin objects.
    @State private var reportedLocations: [IdentifiablePin] = []

    // The body of the ContentView is a NavBarView.
    var body: some View {
        // Pass the reportedLocations binding to the NavBarView and set the environmentObject to the locationManager.
        //NavBarView(reportedLocations: $reportedLocations)
        //    .environmentObject(locationManager)
        AuthView().environmentObject(locationManager)
    }
}

// PreviewProvider is used to generate a preview of the ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
