import SwiftUI

struct RightsView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("What is CopWatchNYC?")
                .font(.largeTitle)
                .padding(.top)

            Text("Police brutality and misconduct has become an issue in the United States for decades. There is a lack of transparency for the communities that the police are supposed to protect. Although there are numerous popular apps that aim to increase transparency of crime, our app was made for the lack of effort in making police activity transparent to communities, which is increasingly important in light of recent events.  What’s more, the access to information of Citizen Rights is not always readily available for those who are in need of it.")
                .font(.system(size:10))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Know Your Rights!")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            VStack(spacing: 20) {
                LinkButton(title: "Cops stopped you in public", url: URL(string: "https://www.aclu.org/know-your-rights/stopped-by-police#ive-been-stopped-by-the-police-in-public")!)
                LinkButton(title: "Cops pulled you over in public", url: URL(string: "https://www.aclu.org/know-your-rights/stopped-by-police#ive-been-pulled-over-by-the-police")!)
                LinkButton(title: " Cops at your front door", url: URL(string: "https://www.aclu.org/know-your-rights/stopped-by-police#the-police-are-at-my-door")!)
                LinkButton(title: "Cops attempting for possible arrest", url: URL(string: "https://www.aclu.org/know-your-rights/stopped-by-police#ive-been-arrested-by-the-police")!)
                LinkButton(title: "Cops violated my rights", url: URL(string: "https://www.nyc.gov/site/ccrb/complaints/file-a-complaint/file-online.page")!)
            }
        }
    }
}
struct LinkButton: View {
    let title: String
    let url: URL

    var body: some View {
        Button(action: {
            UIApplication.shared.open(url)
        }, label: {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        })
        .padding(.horizontal)
    }
}

struct RightsView_Previews: PreviewProvider {
    static var previews: some View {
        RightsView()
    }
}
