import SwiftUI
import FirebaseAuth

struct CreateReportView: View {
    @State private var selectedIndex: Int = 0
    @State private var secondCarouselIndex: Int = 0
    @StateObject private var addressViewModel = AddressViewModel()
    @StateObject private var pinningController = AddPinController()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    @Binding var reportedLocations: [IdentifiablePin] // Add this line
    @Binding var selectedTab: String
    
    let globalUserID = Auth.auth().currentUser?.uid
    
    let firstCarouselImages = ["subway", "public", "bus"]
    let secondCarouselImages = ["fare", "heavy", "other"]
    
    private func storeReportLocation() async {
        guard let userLocation = locationManager.location else { return }
        let reportLocation = userLocation.coordinate
        let (firstOptionText, secondOptionText) = selectedOptionText()
        reportedLocations.append(IdentifiablePin(location: reportLocation, firstCarouselOption: firstOptionText, secondCarouselOption: secondOptionText))
        
        print("New report added: \(reportedLocations.last!)")
        
        pinningController.latitude = reportLocation.latitude
        pinningController.longitude = reportLocation.longitude
        pinningController.report = firstOptionText
        pinningController.report_detail = secondOptionText
        pinningController.report_location = addressViewModel.address
        
        do {
            try await pinningController.addPin()
        } catch {
            print("Error: \(error)")
            print(firstOptionText)
            print(secondOptionText)
            print(addressViewModel.address)
        }
        
    }
    
    func selectedOptionText() -> (String, String) {
        let firstOptionText = selectedIndex == 0 ? "Cops in Subway Station" : (selectedIndex == 1 ? "Cops in Public" : "Cops near Bus Stop")
        let secondOptionText = secondCarouselIndex == 0 ? "Checking for Fare Evaders" : (secondCarouselIndex == 1 ? "Heavy Presence" : "Add what is happening in the comments of your post!")
        
        return (firstOptionText, secondOptionText)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.black), Color("Color 1")]), startPoint: .top, endPoint: .bottom)
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
                
                Text("State a general description of the area.")
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                TextField("123 Street, New York, NY, 12345", text: $addressViewModel.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(.black)
                
                PostButtonView(action: {
                    await storeReportLocation()
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
                    .cornerRadius(20)
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
    let action: @MainActor () async -> Void
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            Task {
                await action()
                selectedTab = "home"
        }
        }) {
            Text("Post Your Report!")
                .font(.headline)
                .fontWeight(.bold)
                .padding()
                .background(Color("Color"))
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
