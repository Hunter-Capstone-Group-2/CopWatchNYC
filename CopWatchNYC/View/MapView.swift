import SwiftUI
import MapKit
import CoreLocation

struct IdentifiablePin: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}

let testCoord1 = IdentifiablePin(location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))

let testCoord2 = IdentifiablePin(location: CLLocationCoordinate2D(latitude: 37.79, longitude: -122.43))


struct MapView: View {
    @Binding var reportedLocations: [IdentifiablePin]
    // Define a state variable to hold the coordinate region for the Map view
    @StateObject var locationManager = LocationManager()
    
    //let test = reportedLocations[0].location.latitude
    
    // Define a state variable to hold the view model for the Map view
    @StateObject private var viewModel = ContentViewModel()
    @StateObject var controller = AddPinController()
    
    @State private var animateScan = false
    @State private var scanScale: CGFloat = 0.1
    
    //reportedLocations.append(testCoord1)
    
    var body: some View {
        
        ZStack {
            // Display the Map with user location and reported locations
            Map(coordinateRegion: $viewModel.region, interactionModes: [.all], showsUserLocation: true, annotationItems: reportedLocations) { pin in
                // Add MapMarker for each reported location with a red tint
                MapAnnotation(coordinate: pin.location) {
                    Image("cop_icon")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            .ignoresSafeArea() // Make the Map ignore the safe area to occupy the full screen
            .accentColor(Color(.systemGreen)) // Set the accent color for the map (e.g., the user location dot)
            
            Circle()
                .stroke(Color("Color 1").opacity(0.8), lineWidth: 8)
                .scaleEffect(scanScale)
                .opacity(animateScan ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false))
                .onAppear {
                    animateScan.toggle()
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                        scanScale = 1.0
                    }
                }

            
            // Add a button to return the map to the user's current location
            VStack {
                HStack {
                    Button(action: {
                        viewModel.centerOnUser() // Center the map on the user's location when the button is tapped
                    }, label: {
                        Image(systemName: "location.fill") // Use a location icon for the button
                            .padding()
                            .foregroundColor(.white) // Set the color of the icon to white
                            .background(Color.black) // Set the background color of the button to black
                            .clipShape(Circle()) // Clip the button background into a circle shape
                            .shadow(radius: 5) // Add a shadow to the button
                    })
                    .padding(.leading) // Add padding on the leading side of the button
                    Spacer() // Add a spacer to push the button to the left side of the screen
                    
                    Button(action: {
                        //print(controller.pins[0].latitude)
                        print("-------------------")
                        reportedLocations.append(testCoord1)
                        reportedLocations.append(testCoord2)
                        print(reportedLocations)
                        // print(controller.pins[0].longitude)
                        
                    }, label: {
                        Image(systemName: "cross.circle.fill") // Use a location icon for the button
                            .padding()
                            .foregroundColor(.white) // Set the color of the icon to white
                            .background(Color.black) // Set the background color of the button to black
                            .clipShape(Circle()) // Clip the button background into a circle shape
                            .shadow(radius: 5) // Add a shadow to the button
                    })
                    
                }
                .padding(.top) // Add padding to the top of the VStack
                .padding(.trailing) // Add padding to the trailing side of the VStack
            }
        }
        
        
        
        .colorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.checkIfLocationServiceIsEnabled()
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
            
            //reportedLocations.append(testCoord1)
            //reportedLocations.append(testCoord2)
            
            Task {
                do {
                    try await controller.fetchPins()
                    
                } catch {
                    print("Error: \(error)")
                }
                
                for pins in controller.pins {
                    
                    print("Coordinates Here: API")
                    print(pins)
                    print("--------------------")
                    
                    let latitude = CLLocationDegrees(pins.latitude)
                    let longitude = CLLocationDegrees(pins.longitude)
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let coordinate = IdentifiablePin(location: location)
                    
                    print("Coordinates Here: Loop")
                    print(coordinate)
                    print("--------------------")
                    
                    reportedLocations.append(coordinate)
                }
                
                print("Coordinates Here: Array")
                print(reportedLocations)
                print("--------------------")
                
            }
            
            
            
            
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
            region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
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
