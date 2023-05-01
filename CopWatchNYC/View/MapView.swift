import SwiftUI
import MapKit
import CoreLocation

struct IdentifiablePin: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
    let firstCarouselOption: String
    let secondCarouselOption: String
}

struct CustomCalloutView: View {
    let pin: IdentifiablePin

    var body: some View {
        VStack(alignment: .leading) {
            Text(pin.firstCarouselOption)
                .font(.headline)
                .foregroundColor(.black) // Change the text color to black
            Text(pin.secondCarouselOption)
                .font(.subheadline)
                .foregroundColor(.black) // Change the text color to black
        }
        .padding()
        .frame(width: 250)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

struct MapView: View {
    @Binding var reportedLocations: [IdentifiablePin]
    
    // Define a state variable to hold the coordinate region for the Map view
    @StateObject var locationManager = LocationManager()
    
    //let test = reportedLocations[0].location.latitude
    
    
    // Define a state variable to hold the view model for the Map view
    @StateObject private var viewModel = ContentViewModel()
    //@StateObject var controller = PinningController()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Display the Map with user location and reported locations
                Map(coordinateRegion: $viewModel.region, interactionModes: [.all], showsUserLocation: true, annotationItems: reportedLocations) { pin in
                    // Add MapMarker for each reported location with a red tint
                    MapAnnotation(coordinate: pin.location) {
                                  Button(action: {
                                      viewModel.selectedPin = pin
                                      print("Tapped pin: \(pin)")
                                      print("Current reportedLocations: \(reportedLocations)")
                                  }) {
                                      Image("cop_icon")
                                          .resizable()
                                          .frame(width: 45, height: 45)
                                  }
                                  if viewModel.selectedPin == pin {
                                      CustomCalloutView(pin: pin)
                                  }
                              }
                    
                }
                .ignoresSafeArea() // Make the Map ignore the safe area to occupy the full screen
                .accentColor(Color(.systemGreen)) // Set the accent color for the map (e.g., the user location dot)
                
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
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {}, label: {
                            NavigationLink(destination: RightsView()) {
                                Image(systemName: "info.circle.fill")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                        })
                        .padding(.trailing)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
            }
        }

        .colorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.checkIfLocationServiceIsEnabled()
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
            
//            Task {
//                    do {
//                        try await controller.fetchPins()
//                    } catch {
//                        print("Error: \(error)")
//                    }
//                }
            }
            
        }
        
    
    
    final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var selectedPin: IdentifiablePin?
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
            region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
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

extension IdentifiablePin: Equatable {
    static func == (lhs: IdentifiablePin, rhs: IdentifiablePin) -> Bool {
        lhs.id == rhs.id
    }
}
