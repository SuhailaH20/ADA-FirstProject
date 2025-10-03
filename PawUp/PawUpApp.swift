//
//  PawUpApp.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 03/04/1447 AH.
//

import SwiftUI

@main
struct PawUpApp: App {
    var body: some Scene {
        WindowGroup {
           RootView()
        }
    }
}



struct RootView: View {
    @AppStorage("didCompleteOnboarding") private var didCompleteOnboarding = false
    
    var body: some View {
        if didCompleteOnboarding {
            PetPage()
        } else {
            // 🟢 Start onboarding flow
            Splash()
        }
    }
}
