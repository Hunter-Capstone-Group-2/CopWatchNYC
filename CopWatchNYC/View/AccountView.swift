//
//  AccountView.swift
//  CopWatchNYC
//
//  Created by Steve Roy on 2/18/23.
//

import SwiftUI

struct Accountview: View {
    @State private var profileImage: UIImage?
    @State private var username: String = "@username"
    @State private var likesCount: Int = 100
    @State private var postsCount: Int = 1
    @State var selectedTab: String = "user"
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: profileImage ?? UIImage(systemName: "person.circle.fill")!)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                    .padding(.top, 50)
                    .onTapGesture {
                        // Implement image picker logic here to allow the user to upload their profile picture
                    }
                
                Text(username)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.white)
                
                HStack {
                    Text("Likes:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(likesCount)")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Posts:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(postsCount)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 5)
                
                Text("Your Posts:")
                    .font(.headline)
                    .padding(.top, 20)
                    .foregroundColor(.white)
                
                List {
                    Section {
                        if postsCount == 0 {
                            Text("You haven't made any posts yet.")
                        } else {
                            ForEach(0..<postsCount, id: \.self) { index in
                                Text("Post \(index + 1)")
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("Color 1"))
                Spacer()
            }
            .background(Color("Color 1"))
            .navigationBarTitle(Text("My Account"))
            .navigationBarItems(
                leading: Spacer(),
                trailing: ZStack {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
            )
        }
    }
}

struct SettingsView: View {
    @State private var isNotificationsEnabled = true
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 80)
            
            HStack {
                Text("Notifications:")
                    .font(.headline)
                    .foregroundColor(.white)
                Toggle(isOn: $isNotificationsEnabled){
                    Text("")
                }
                .tint(Color.blue)
            }
            .padding(.top, 50)
            
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        .background(Color("Color 2"))
    }
}

struct Accountview_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
