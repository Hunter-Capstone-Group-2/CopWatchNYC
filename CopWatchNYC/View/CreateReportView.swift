import SwiftUI

struct CreateReportView: View {
    @State private var selectedIndex: Int = 0
    @State private var secondCarouselIndex: Int = 0
    @StateObject private var addressViewModel = AddressViewModel()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    @Binding var reportedLocations: [IdentifiablePin] // Add this line
    @Binding var selectedTab: String


    let firstCarouselImages = ["subway", "public", "bus"]
    let secondCarouselImages = ["fare", "heavy", "other"]
    
    private func storeReportLocation() {
           guard let userLocation = locationManager.location else { return }
           let reportLocation = userLocation.coordinate
           reportedLocations.append(IdentifiablePin(location: reportLocation))
       }
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color 1")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

            VStack {
                Text("What Would You Like to Report?")
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(.white)

                Text(selectedIndex == 0 ? "Cops in Subway Station" : (selectedIndex == 1 ? "Cops in Public" : "Cops near Bus Stop"))
                    .font(.headline)
                    .foregroundColor(.white)

                CarouselView(selectedIndex: $selectedIndex, images: firstCarouselImages)

                Text("What's Happening?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(secondCarouselIndex == 0 ? "Checking for Fare Evaders" : (secondCarouselIndex == 1 ? "Heavy Presence" : "Add what is happening in the comments of your post!"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                CarouselView(selectedIndex: $secondCarouselIndex, images: secondCarouselImages)

                Text("Where is it Happening?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                TextField("123 Street, New York, NY, 12345", text: $addressViewModel.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(.black)

                PostButtonView(action: {
                    storeReportLocation()
                    presentationMode.wrappedValue.dismiss()
                }, selectedTab: $selectedTab)
                .padding(.top, 20)
            }
        }
    }
}

struct CarouselView: View {
    @Binding var selectedIndex: Int
    let images: [String]

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                    .padding()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

class AddressViewModel: ObservableObject {
    @Published var address: String = ""
}

struct PostButtonView: View {
    let action: () -> Void
    @Binding var selectedTab: String

    var body: some View {
        Button(action: {
            action()
            selectedTab = "home"
        }) {
            Text("Post Your Report!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}


struct CreateReportView_Previews: PreviewProvider {
    @State static private var previewReportedLocations: [IdentifiablePin] = []
    @State static private var selectedTab = "report"

    static var previews: some View {
        CreateReportView(reportedLocations: $previewReportedLocations, selectedTab: $selectedTab)
    }
}
