//
//  ContentView.swift
//  PawUp
//
//  Created by Areeg Altaiyah on 06/04/1447 AH.
//
import SwiftUI
import UserNotifications

struct NotificationPawUp: View {
    
    let notificationManager = NotificationManager()
    @State private var goPawUpApp = false   // For navigation
    @AppStorage("didCompleteOnboarding") private var didCompleteOnboarding = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0xFD/255, green: 0xF8/255, blue: 0xEF/255)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    //Title
                    Text("Turn on Notifications")
                        .font(.custom("GNF", size: 28))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                        .padding(.bottom, 100)
                    
                    // Image + Pink Text
                    VStack {
                        Image("GroupNotification")
                            .resizable()
                            .frame(width: 300, height: 123)
                            .padding(.bottom, 20)
                        
                        Text("Get reminders from your virtual pet \nto stay active")
                            .font(.custom("GNF", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.brandPink)
                    }
                    
                    Spacer()
                    
                    // Buttons
                    VStack {
                        // Allow Notification
                        Button(action: {
                            notificationManager.requestNotificationPermission { granted in
                                DispatchQueue.main.async {
                                    if granted {
                                        notificationManager.scheduleDailyNotificationsWithDifferentContent()
                                        
                                        // Navigate forward
                                        goPawUpApp = true
                                        didCompleteOnboarding = true

                                    } else {
                                        print("Notification permission was denied.")
                                        didCompleteOnboarding = true
                                        goPawUpApp = true // still go forward
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
                        
                        // Maybe Later
                        Button(action: {
                            print("User chose 'Maybe Later'.")
                            goPawUpApp = true
                            didCompleteOnboarding = true

                        }) {
                            Text("Maybe Later")
                                .font(.custom("GNF", size: 21))
                                .foregroundStyle(Color.black)
                                .frame(width: 350, height: 49)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }
            }
            // ✅ Navigation destination
            .navigationDestination(isPresented: $goPawUpApp) {
                PetPage()
                    .navigationBarBackButtonHidden(true) // no back button
            }
        }
    }
}

#Preview {
    NotificationPawUp()
}
