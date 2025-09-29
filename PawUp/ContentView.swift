//
//  ContentView.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 03/04/1447 AH.
//
//areeeg
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Background color
            Color(red: 0xFD/255, green: 0xF8/255, blue: 0xEF/255)
                .ignoresSafeArea()

            // Main content
            VStack(alignment: .leading) {
                // Align coinsView to the leading edge
                coinsView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                //main card and action btn
                ZStack(alignment: .bottom) {
                    BuddyCardView()
                    ActionButtonView()
                        .offset(y: 40)
                }
               


            }
        }
    }
}

struct coinsView: View {
    var body: some View{
        ZStack{
            Image("coins")
                .resizable()
                .frame(width: 84, height: 40)
            Text("3")
                .font(.custom("GNF", size: 20))
                .padding(.leading, 23.0)
                
                   
        }
    }
    
}

struct BuddyCardView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            // Background image as a card
            Image("petCard")
                .resizable()
                .clipped()

            // Content over the image
            HStack(alignment: .center) {
                Text("Your buddy’s tail is wagging—ready to move?")
                    .font(.custom("GNF", size: 24))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)

                Spacer(minLength: 20)

                Image("cat_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            }
            .padding(20)
        }

        .fixedSize(horizontal: false, vertical: true) // This makes the ZStack shrink-wrap
    }
}


struct ActionButtonView:View {
    var body: some View {
        HStack(spacing: 50) {
            Button(action: {
                // Action logic
            }) {
                Image("trophy")
                    .resizable()
                    .frame(width: 80, height: 80)
            }

            Button(action: {
                // Action logic
            }) {
                Image("Streak")
                    .resizable()
                    .frame(width: 80, height: 80)
            }

            Button(action: {
                //  Action logic
            }) {
                Image("breakday")
                    .resizable()
                    .frame(width: 80, height: 80)
                
            }
        }

    }
}

#Preview {
    ContentView()
}
