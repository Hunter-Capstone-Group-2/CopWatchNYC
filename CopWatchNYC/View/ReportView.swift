// Import SwiftUI
import SwiftUI

// Create a SwiftUI view called `ReportView`
struct ReportView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Binding var reportedLocations: [IdentifiablePin]
    private func storeReportLocation() {
        guard let userLocation = locationManager.location else { return }
        let reportLocation = userLocation.coordinate
        reportedLocations.append(IdentifiablePin(location: reportLocation))
    }

    @State private var helpfulInformation: String = ""
    @State private var images: [UIImage] = []
    @State private var selectedTitle: String = ""

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
            Section(header: Text("Report Title:")
                        .foregroundColor(.white)) {
                HStack {
                    if selectedTitle.isEmpty {
                        Text("Choose a Report Title...")
                            .foregroundColor(.gray)
                    } else {
                        Text(selectedTitle)
                    }
                    Spacer()
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

            Section(header: Text("Description:")
                        .foregroundColor(.white)) {
                ZStack(alignment: .topLeading) {
                    if helpfulInformation.isEmpty {
                        Text("Briefly describe what you saw, add any helpful information, including amount of officers, exact location, badge numbers, etc....")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $helpfulInformation)
                        .frame(minHeight: 200)
                        .padding(.horizontal, 4)
                }
            }

            Section {
                NavigationLink(destination: Home(reportedLocations: $reportedLocations)) {
                    Text("Post")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .buttonStyle(NoBorderButtonStyle())
                        .onTapGesture {
                            storeReportLocation()
                        }
                }
            }
        }
        .navigationTitle("Report")
        .scrollContentBackground(.hidden)
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
