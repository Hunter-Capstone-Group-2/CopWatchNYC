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

            Section(header: Text("Location:")
                        .foregroundColor(.white)) {
                TextField("Enter location", text: .constant("695 Park Ave, New York, NY 10065"))
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

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
