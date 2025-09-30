//
//  ContentView.swift
//  PawUp
//
//  Created by Areeg Altaiyah on 06/04/1447 AH.
//
import SwiftUI
import UserNotifications


struct NotificationPawUp: View {
    // 1. STATE VARIABLE to control navigation
    @State private var shouldNavigateToPetPage: Bool = false
    
    // Instantiating NotificationManager
    let notificationManager = NotificationManager()
    
    var body: some View {
        // Use a NavigationStack for general structure,
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0xFD/255, green: 0xF8/255, blue: 0xEF/255)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Turn on Notifications")
                        .font(.custom("GNF", size: 28))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black).padding(.bottom, 100)
                    
                    
                    // Image + Pink Text
                    VStack {
                        Image("GroupNotification")
                            .resizable()
                            .frame(width: 300, height: 123).padding(.bottom, 20)
                        
                        
                        Text("Get reminders from your virtual pet \nto stay active")
                            .font(.custom("GNF", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.brandPink)
                    }
                    Spacer()
                    
                    // Buttons
                    VStack {
                        Button(action: {
                            // Call the manager's function to request permission
                            notificationManager.requestNotificationPermission { granted in
                                DispatchQueue.main.async {
                                    if granted {
                                        // If permission is granted
                                        notificationManager.scheduleDailyNotificationsWithDifferentContent()
                                        
                                        // 3. Set state to trigger navigation
                                        self.shouldNavigateToPetPage = true
                                    } else {
                                        // User denied permission
                                        self.shouldNavigateToPetPage = true
                                        print("Notification permission was denied.")
                                    }
                                }
                            }
                        }) {
                            Text("Allow Notification")
                                .font(.custom("GNF", size: 21))
                                .foregroundStyle(Color.white)
                                .frame(width: 350, height: 49)
                                .background(Color.brandNavy)
                                .cornerRadius(5)
                                .padding(.bottom, 5)
                        }
                        
                        Button(action: {
                            self.shouldNavigateToPetPage = true
                            print("User chose 'Maybe Later'.")
                        }) {
                            Text("Maybe Later")
                                .font(.custom("GNF", size: 21))
                                .foregroundStyle(Color.black)
                                .frame(width: 350, height: 49)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                    }.padding()
                }
            }
        }
        // 4. Use a fullScreenCover to cleanly transition to the PetPage,
        //    making it look like the onboarding view is replaced.
        .fullScreenCover(isPresented: $shouldNavigateToPetPage) {
            PetPage()
        }
    }
}
