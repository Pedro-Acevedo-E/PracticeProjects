//
//  ContentView.swift
//  UITestingDemo
//
//  Created by Pedro Acevedo on 31/03/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showLogin = false
    @EnvironmentObject private var user: User
    
    var body: some View {
        VStack {
            Text(!user.isLoggedIn ? "Welcome!" : "Welcome \(user.username)!")
                .font(.title)
            
            Spacer().frame(height: 20)
            
            Button(action: {
                if !user.isLoggedIn {
                    showLogin = true
                } else {
                    user.logout()
                }
            }, label: {
                Text(!user.isLoggedIn ? "Login" : "Logout")
            })
            .accessibilityIdentifier("loginButton")
            if user.isLoggedIn {
                Form {
                    Section {
                        VStack {
                            Text("Color Theme")
                            Picker("", selection: $user.colorTheme) {
                                Text("Light").tag(0)
                                Text("Dark").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .accessibilityIdentifier("colorTheme")
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Text Size")
                            Slider(value: $user.textSize, in: 1...100)
                                .accessibilityIdentifier("slider")
                        }
                    }
                    
                    Section {
                        VStack {
                            Text("Font")
                            Picker("", selection: $user.font) {
                                Text("Arial").tag("Arial")
                                Text("Avenir Next").tag("Avenir Next")
                                Text("Noteworthy").tag("Noteworthy")
                                Text("Futura").tag("Futura")
                            }
                            .pickerStyle(WheelPickerStyle())
                            .accessibilityIdentifier("fontPicker")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
