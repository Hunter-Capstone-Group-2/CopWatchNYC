// Import required modules
import MapKit
import CoreLocation

// Define a class that manages location services and conforms to CLLocationManagerDelegate
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Initialize a location manager
    private let locationManager = CLLocationManager()
    
    // Define a published variable to hold the current location
    @Published var location: CLLocation?
    
    // Override the default initializer to configure the location manager
    override init() {
        super.init()
        
        // Set the delegate to self, desired accuracy to best, and request authorization
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Start updating the location
        locationManager.startUpdatingLocation()
    }
    
    // Implement the locationManager(_:didUpdateLocations:) method to update the current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the last location from the locations array
        guard let location = locations.last else { return }
        
        // Update the published location variable with the new location
        self.location = location
    }
}
