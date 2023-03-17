// Import required modules
import SwiftUI
import MapKit
import CoreLocation

// Define a view that displays a Map view with a semi-transparent background color
struct Mapview: View {
    
    // Define a state variable to hold the coordinate region for the Map view
    @StateObject var locationManager = LocationManager()
    
    // Define a state variable to hold the view model for the Map view
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        
        // Layer a Map view and a semi-transparent Color view using a ZStack
        ZStack {
            // Create the Map instance here
            Map(coordinateRegion: $viewModel.region,interactionModes: [.all], showsUserLocation: true )
                .ignoresSafeArea()
                .accentColor(Color(.systemPink))
            // Add a semi-transparent background color to the map
//            Color(.systemBackground)
//                .opacity(0.1)
        }
        
        // Set the color scheme to dark, and ignore safe areas to extend to the edges of the screen
        .colorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
        
        // Customize the appearance of the map when it appears on the screen
        .onAppear {
            // Check if location services are enabled and set the point-of-interest filter to exclude all points of interest
            viewModel.checkIfLocationServiceIsEnabled()
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
        }
    }
}


// Define a preview provider for the MapView struct
struct Mapview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Define a view model to hold the coordinate region for the Map view
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Define a published variable to hold the coordinate region for the Map view
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Define a location manager variable
    var locationManager: CLLocationManager?
    
    // This function is called when the location manager receives new location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Check if there is at least one location in the array of locations passed to the function
        guard let location = locations.last else { return }
        
        // Set the coordinate region of the Map view to a new region centered around the user's current location
        region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }

    // Check if location services are enabled and set the delegate to self
    func checkIfLocationServiceIsEnabled() {
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // Initialize the location manager and set the delegate to self
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            // Show an alert if location services are not enabled
            print("Show an alert")
        }
    }
    
    // Check the current authorization status for location services
    private func checkLocationAuthorization() {
        // Make sure the locationManager is not nil
        guard let locationManager = locationManager else { return }

        // Switch on the authorization status returned from the location manager
        switch locationManager.authorizationStatus {
            case .notDetermined:
                // Request location authorization if the authorization status is not determined
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                // Display a message if the user's location is restricted due to parental controls
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                // Display a message if the user has denied location permissions
                print("You have denied Location Permission")
            case .authorizedAlways, .authorizedWhenInUse:
                // Set the region to the user's current location if the user has granted location permissions
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Call the checkLocationAuthorization function when the authorization status changes
        checkLocationAuthorization()
    }
}


