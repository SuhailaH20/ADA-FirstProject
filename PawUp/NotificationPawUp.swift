//
//  ContentView.swift
//  PawUp
//
//  Created by Areeg Altaiyah on 06/04/1447 AH.
//

import SwiftUI
import UserNotifications

struct NotificationPawUp: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0xFD/255, green: 0xF8/255, blue: 0xEF/255)
                    .ignoresSafeArea()
                VStack {
    Spacer()
                    Text("Turn on notifications")
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
                        Button(action: {                        requestNotificationPermission()}) {
                            ZStack {
                                Image("Rectangle")
                                    .resizable()
                                    .scaledToFit()
                                Text("Allow Notification").font(.custom("GNF", size: 21)).foregroundStyle(Color.white)
                            }
                        }
                        Button(action: {}) {
                            ZStack {
                                Image("Rectangle2")
                                    .resizable()
                                    .scaledToFit()
                                Text("Maybe Later").font(.custom("GNF", size: 21)).foregroundStyle(Color.black)

                            }
                            
                        }
                        

                    }.padding()
                                    }
            }
        } // closes ZStack
    }
    
    //Notification Function
    private func requestNotificationPermission() {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if let error = error {
                   print("Error requesting notifications: \(error)")
                   return
               }

               if granted {
                   print("Notifications Allowed")
                   DispatchQueue.main.async {
                       UIApplication.shared.registerForRemoteNotifications()
                   }
               } else {
                   print("Notifications Denied")
               }
           }
       }
    
 

   }





#Preview {
    NotificationPawUp()
}
