import SwiftUI

struct CreateReportView: View {
    @State private var selectedIndex: Int = 0
    @State private var secondCarouselIndex: Int = 0
    @StateObject private var addressViewModel = AddressViewModel()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    @Binding var reportedLocations: [IdentifiablePin] // Add this line


    let firstCarouselImages = ["subway", "public", "bus"]
    let secondCarouselImages = ["fare", "heavy", "other"]
    
    private func storeReportLocation() {
           guard let userLocation = locationManager.location else { return }
           let reportLocation = userLocation.coordinate
           reportedLocations.append(IdentifiablePin(location: reportLocation))
       }
    var body: some View {
        ZStack {
            Color("Color 1").edgesIgnoringSafeArea(.all)

            VStack {
                Text("What Would You Like to Report?")
                    .font(.title)
                    .foregroundColor(.white)

                Text(selectedIndex == 0 ? "Cops in Subway Station" : (selectedIndex == 1 ? "Cops in Public" : "Cops near Bus Stop"))
                    .font(.subheadline)
                    .foregroundColor(.white)

                CarouselView(selectedIndex: $selectedIndex, images: firstCarouselImages)

                Text("What's Happening?")
                    .font(.title)
                    .foregroundColor(.white)

                Text(secondCarouselIndex == 0 ? "Checking for Fare Evaders" : (secondCarouselIndex == 1 ? "Heavy Presence" : "Add what is happening in the comments of your post!"))
                    .font(.subheadline)
                    .foregroundColor(.white)

                CarouselView(selectedIndex: $secondCarouselIndex, images: secondCarouselImages)

                Text("Where is it Happening?")
                    .font(.title)
                    .foregroundColor(.white)

                TextField("123 Street, New York, NY, 12345", text: $addressViewModel.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(.white)

                PostButtonView {
                    storeReportLocation()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct CarouselView: View {
    @Binding var selectedIndex: Int
    let images: [String]

    var body: some View {
        HStack {
            ForEach(0..<images.count) { index in
                Image(images[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding()
                    .onTapGesture {
                        selectedIndex = index
                    }
            }
        }
    }
}

class AddressViewModel: ObservableObject {
    @Published var address: String = ""
}

struct PostButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Post Your Report!")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct CreateReportView_Previews: PreviewProvider {
    @State static private var previewReportedLocations: [IdentifiablePin] = []
    static var previews: some View {
           CreateReportView(reportedLocations: $previewReportedLocations)
               .environmentObject(LocationManager())
       }
}
