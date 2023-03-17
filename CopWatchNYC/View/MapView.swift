import SwiftUI
import MapKit

struct Mapview: View {
    // Define a state variable to hold the coordinate region for the Map view
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        // Use a ZStack to layer a Map view and a semi-transparent Color view
        ZStack {
            Map(coordinateRegion: $region) // Display a Map view using the region state variable
            
//                Color(.systemBackground)
//                    .opacity(0.3) // Add a semi-transparent background color to the map
            }
        .colorScheme(.dark) // Set the color scheme to dark
        .edgesIgnoringSafeArea(.all) // Make the map extend to the edges of the screen
        
        // Use the onAppear modifier to customize the appearance of the map
        .onAppear {
            // Set the point-of-interest filter to exclude all points of interest
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
            // Hide points of interest on the map
            MKMapView.appearance().showsPointsOfInterest = false
        }
    }
}

struct MaptView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
