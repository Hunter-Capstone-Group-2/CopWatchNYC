import SwiftUI
import MapKit
import CoreLocation

//let testCoord1 = IdentifiablePin(location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
//let testCoord2 = IdentifiablePin(location: CLLocationCoordinate2D(latitude: 37.79, longitude: -122.43))

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
                .foregroundColor(.black)
            Text(pin.secondCarouselOption)
                .font(.subheadline)
                .foregroundColor(.black)
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
    
    @StateObject var locationManager = LocationManager()
    @StateObject var pinningController = AddPinController()
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Display the Map with user location and reported locations
                Map(coordinateRegion: $viewModel.region, interactionModes: [.all], showsUserLocation: true, annotationItems: reportedLocations) { pin in
                    //Pinning System
                    MapAnnotation(coordinate: pin.location) {
                        Button(action: {
                            if viewModel.selectedPin == pin {
                                viewModel.selectedPin = nil // Deselect the pin if it's already selected
                            } else {
                                viewModel.selectedPin = pin // Otherwise, select the tapped pin
                            }
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
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        })
                        .padding(.leading)
                        Spacer()
                        
                        Button(action: {
                            print("-------------------")
                        }, label: {
                            Image(systemName: "cross.circle.fill")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        })
                        
                    }
                    .padding(.top)
                    .padding(.trailing)
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
            
            Task {
     
                do {
                    try await pinningController.fetchPins()
                    
                } catch {
                    print("Error: \(error)")
                }
                
                for pins in pinningController.pins {
                    
                    print("Coordinates Here: API")
                    print(pins)
                    print("--------------------")
                    
                    let latitude = CLLocationDegrees(pins.latitude)
                    let longitude = CLLocationDegrees(pins.longitude)
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let coordinate = IdentifiablePin(location: location, firstCarouselOption: "pin.firstCarouselOption", secondCarouselOption: "pin.secondCarouselOption")
                    
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
            @Published var selectedPin: IdentifiablePin?
            //Map
            @Published var region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
                span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
            )
            var locationManager: CLLocationManager?
            
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
            
            func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                checkLocationAuthorization()
            }
            
            func centerOnUser() {
                guard let userLocation = locationManager?.location?.coordinate else { return }
                region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            }
            
        }
        
        // Preview provider for the MapView
        struct MapView_Previews: PreviewProvider {
            // array of IdentifiablePin Objects
            @State static private var reportedLocations: [IdentifiablePin] = []
            
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
