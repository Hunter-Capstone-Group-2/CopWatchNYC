import SwiftUI
import MapKit
import CoreLocation

struct IdentifiablePin: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}

struct MapView: View {
    @Binding var reportedLocations: [IdentifiablePin]
    
    // Define a state variable to hold the coordinate region for the Map view
    @StateObject var locationManager = LocationManager()
    
    
    
    // Define a state variable to hold the view model for the Map view
    @StateObject private var viewModel = ContentViewModel()
    
    @State var selectedTab: String = "user"
    
    var body: some View {
        ZStack {
            // Display the Map with user location and reported locations
            Map(coordinateRegion: $viewModel.region, interactionModes: [.all], showsUserLocation: true, annotationItems: reportedLocations) { pin in
                // Add MapMarker for each reported location with a red tint
                MapMarker(coordinate: pin.location, tint: .red)
            }
            .ignoresSafeArea() // Make the Map ignore the safe area to occupy the full screen
            .accentColor(Color(.systemGreen)) // Set the accent color for the map (e.g., the user location dot)
            
            // Add a button to return the map to the user's current location
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.centerOnUser() // Center the map on the user's location when the button is tapped
                    }, label: {
                        Image(systemName: "location.fill") // Use a location icon for the button
                            .padding()
                            .foregroundColor(.white) // Set the color of the icon to white
                            .background(Color("Color 1")) // Set the background color of the button to Color 1
                            .clipShape(Circle()) // Clip the button background into a circle shape
                            .shadow(radius: 5) // Add a shadow to the button
                    })
                    .padding(.top, 40)
                    .padding(.trailing)
                }
                Spacer()
            }
            .padding(.top)
            .padding(.trailing)
            .alignmentGuide(.trailing) { dimension in
                dimension[.trailing]
            }
        }


        .colorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.checkIfLocationServiceIsEnabled()
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
        }
    }
    
    
    
    final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        // Define a published variable to hold the coordinate region for the Map view
        @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
        )

        // Define a variable to hold the location manager instance
        var locationManager: CLLocationManager?

        // Implement the locationManager(_:didUpdateLocations:) method to update the current location on the Map view
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        }

        // Check if location services is enabled
        func checkIfLocationServiceIsEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                checkLocationAuthorization()
            } else {
                print("Show an alert")
            }
        }

        // Check the authorization status and update the region accordingly
        private func checkLocationAuthorization() {
            guard let locationManager = locationManager else { return }
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted.")
            case .denied:
                print("You have denied location permissions.")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            @unknown default:
                break
            }
        }

        // Implement the locationManagerDidChangeAuthorization(_:) method to update the location authorization status
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }

        // Add a function to center the map on the user's current location
        func centerOnUser() {
            guard let userLocation = locationManager?.location?.coordinate else { return }
            region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.1))
        }

    }
    
    // Preview provider for the MapView
    struct MapView_Previews: PreviewProvider {
        // Define a static state property to store an array of IdentifiablePin objects
        @State static private var reportedLocations: [IdentifiablePin] = []

        // Provide a preview of the MapView with the reportedLocations binding
        static var previews: some View {
            MapView(reportedLocations: $reportedLocations)
        }
    }


}
