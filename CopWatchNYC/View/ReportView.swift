// Import SwiftUI
import SwiftUI

// Create a SwiftUI view called `ReportView`
struct ReportView: View {
    // Use an environment object to access the LocationManager
    @EnvironmentObject var locationManager: LocationManager
    // A binding to the reported locations array
    @Binding var reportedLocations: [IdentifiablePin]

    // A function to store the report location when called
    private func storeReportLocation() {
        // Check if the user location is available
        guard let userLocation = locationManager.location else { return }
        // Get the user's current coordinates
        let reportLocation = userLocation.coordinate
        // Add a new IdentifiablePin to the reportedLocations array
        reportedLocations.append(IdentifiablePin(location: reportLocation))
        // Store reportLocation for later use (e.g., adding a pin on the map)
        print("New report location added:", reportLocation) // Add this line
    }

    // State variables to store user input
    @State private var helpfulInformation: String = ""
    @State private var images: [UIImage] = []
    @State private var selectedTitle: String = ""

    // Custom button style for the "Post" button
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

    // The body of the `ReportView`
    var body: some View {
        // A form to gather user input
        Form {
            // Report title section
            Section(header: Text("Report Title:")
                        .foregroundColor(.white)) {
                HStack {
                    // Display the selected title or a placeholder
                    if selectedTitle.isEmpty {
                        Text("Choose a Report Title...")
                            .foregroundColor(.gray)
                    } else {
                        Text(selectedTitle)
                    }
                    Spacer()
                    // Menu for selecting a report title
                    Menu {
                        Button(action: {
                            selectedTitle = "Cop Presence Nearby"
                        }) {
                            Text("Cop Presence Nearby")
                        }
                        Button(action: {
                            selectedTitle = "Cop in Subway Station"
                        }) {
                            Text("Cop in Subway Station")
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.blue)
                }
            }

            // Location section
//            Section(header: Text("Location:")
//                        .foregroundColor(.white)) {
//                TextField("Enter location", text: .constant("695 Park Ave, New York, NY 10065"))
//            }

            // Description section
            Section(header: Text("Description:")
                        .foregroundColor(.white)) {
                ZStack(alignment: .topLeading) {
                    // Display a placeholder if the text is empty
                    if helpfulInformation.isEmpty {
                        Text("Briefly describe what you saw, add any helpful information, including amount of officers, exact location, badge numbers, etc....")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    // Text editor for entering a description
                    TextEditor(text: $helpfulInformation)
                        .frame(minHeight: 200)
                        .padding(.horizontal, 4)
                }
            }
//            Section(header: Text("Add images:")
//                        .foregroundColor(.white)) {
//                VStack {
//                    ForEach(images, id: \.self) { image in
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .padding()
//                    }
//
//                    Button(action: {
//                        // TODO: Implement image picker
//                    }) {
//                        Text("Add Image")
//                    }
//                }
//            }
            // Section containing the "Post" button
            Section {
                // NavigationLink to navigate to NavBarView when tapped
                NavigationLink(destination: NavBarView(reportedLocations: $reportedLocations)) {
                    // "Post" button UI
                    Text("Post")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .buttonStyle(NoBorderButtonStyle())// Use the custom button style
                        .onTapGesture {
                            // Call the storeReportLocation() function when the button is tapped
                            storeReportLocation()
                        }
                }
            }
        }
        // Set the navigation bar title for the view
        .navigationTitle("Report")
        // Hide the scroll content background
        .scrollContentBackground(.hidden)
        // Set the background color for the view
        .background(Color("Color 2"))
    }
}

// Create a preview for the ReportView
struct ReportView_Previews: PreviewProvider {
    // State variable for the preview
    @State static private var previewReportedLocations: [IdentifiablePin] = []

    // Define the preview
    static var previews: some View {
        // Instantiate the ReportView with the preview data and environment object
        ReportView(reportedLocations: $previewReportedLocations)
            .environmentObject(LocationManager())
    }
}
