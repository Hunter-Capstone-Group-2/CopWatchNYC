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
    
    var body: some View {
        Form {
            Section(header: Text("What are you reporting?")) {
                Text("Sighting of Police officers")
            }
            
            Section(header: Text("Location:")) {
                TextField("Enter location", text: .constant("68 Lexington Ave, NY, New York"))
            }
            
            Section(header: Text("Helpful information:")) {
                TextEditor(text: $helpfulInformation)
            }
            
            Section(header: Text("Add images:")) {
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
        }
        .navigationTitle("Report")
    }
}


struct Reportview_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}

