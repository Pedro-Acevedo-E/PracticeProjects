//
//  LoginView.swift
//  UITestingDemo
//
//  Created by Pedro Acevedo on 31/03/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var user: User
    @Environment(\.presentationMode) var presentationMode //for dismissing sheet
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $user.username)
                    SecureField("Password", text: $user.password)
                }
                
                Button {
                    if user.login() {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("Login")
                }
                .accessibilityIdentifier("loginNow")
            }
            .navigationTitle(Text("Login"))
            .navigationBarItems(trailing: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .accessibilityLabel("Dismiss")
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"),
                  message: Text("Either username or password is missing, or they are wrong."),
                  dismissButton: Alert.Button.default(Text("OK"), action: {
                    showAlert = false
                  }))
        }
    }
}
