import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    // Define a state variable to hold the coordinate region for the Map view
    @StateObject var locationManager = LocationManager()
    
    // Define a state variable to hold the view model for the Map view
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, interactionModes: [.all], showsUserLocation: true)
                .ignoresSafeArea()
                .accentColor(Color(.systemGreen))
            
            // Add a button to return the map to the user's current location
            VStack {
                HStack {
                    Button(action: {
                        viewModel.centerOnUser()
                    }, label: {
                        Image(systemName: "location.fill")
                            .padding()
                            .foregroundColor(.white) // Set the color of the arrow to white
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    })
                    .padding(.leading)
                    Spacer()
                }
                .padding(.top)
                .padding(.trailing)
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
        
        @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        var locationManager: CLLocationManager?
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        
        func checkIfLocationServiceIsEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                checkLocationAuthorization()
            } else {
                print("Show an alert")
            }
        }
        
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
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
        
        // Add a function to center the map on the user's current location
        func centerOnUser() {
            guard let userLocation = locationManager?.location?.coordinate else { return }
            region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
    }
    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
}
