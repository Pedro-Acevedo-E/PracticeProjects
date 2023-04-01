//
//  UITestingDemoApp.swift
//  UITestingDemo
//
//  Created by Pedro Acevedo on 31/03/23.
//

import SwiftUI

@main
struct UITestingDemoApp: App {
    var user = User()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
    }
}
