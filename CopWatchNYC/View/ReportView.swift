import SwiftUI
import MapKit


struct ReportView: View {
    // Define state variables for the report information
    @State private var helpfulInformation: String = ""
    @State private var images: [UIImage] = []
    
    // Define a location manager to get the user's current location
    @StateObject private var locationManager = LocationManager()

    // Define a custom button style with no border
    struct NoBorderButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }

    var body: some View {
        Form {
            // Section for the report title
            Section(header: Text("Report Title:")
                        .foregroundColor(.white)) {
                Text("Sighting of Police officers")
            }

            // Section for the report location
            Section(header: Text("Location:")
                        .foregroundColor(.white)) {
                TextField("Enter location", text: .constant("68 Lexington Ave, NY, New York"))
            }

            // Section for the report description
            Section(header: Text("Description:")
                        .foregroundColor(.white)) {
                TextEditor(text: $helpfulInformation)
            }

            // Section for adding images to the report
            Section(header: Text("Add images:")
                        .foregroundColor(.white)) {
                VStack {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }

                    Button(action: {
                        // TODO: Implement image picker
                    }) {
                        Text("Add Image")
                    }
                }
            }

            // Section with a button to submit the report
            Section {
                NavigationLink(destination: NavBarView()) {
                    Text("Post")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .buttonStyle(NoBorderButtonStyle())
                }
            }
        }
        .navigationTitle("Report")
        .scrollContentBackground(.hidden)
        .background(Color("Color 2"))
    }
}

struct Reportview_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
