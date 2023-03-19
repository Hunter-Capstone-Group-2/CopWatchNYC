//
//  ReportView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 3/17/23.
//

import SwiftUI

struct ReportView: View {
    @State private var helpfulInformation: String = ""
    @State private var images: [UIImage] = []

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
                Text("Sighting of Police officers")
            }

            Section(header: Text("Location:")
                        .foregroundColor(.white)) {
                TextField("Enter location", text: .constant("68 Lexington Ave, NY, New York"))
            }

            Section(header: Text("Description:")
                        .foregroundColor(.white)) {
                TextEditor(text: $helpfulInformation)
            }

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

