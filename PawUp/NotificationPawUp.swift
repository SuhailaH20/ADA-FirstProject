//
//  ContentView.swift
//  PawUp
//
//  Created by Areeg Altaiyah on 06/04/1447 AH.
//
import SwiftUI
import UserNotifications

struct NotificationPawUp: View {
    // Instantiate your NotificationManager here
    let notificationManager = NotificationManager()
    
    var body: some View {
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
                                if granted {
                                    // If permission is granted, immediately schedule the daily notifications
                                    notificationManager.scheduleDailyNotificationsWithDifferentContent()
                                    
                                    // TODO: Add navigation logic here to move the user to the next screen
                                    print("Ready to navigate to the next screen!")
                                } else {
                                    // User denied permission
                                    print("Notification permission was denied.")
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
                            // TODO: Add navigation logic here to move the user to the next screen (without notifications)
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
        } // closes NavigationStack
    }
}


#Preview {
    NotificationPawUp()
}

