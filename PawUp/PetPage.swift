//
//  ContentView.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 03/04/1447 AH.
//
//areeeg
import SwiftUI

struct PetPage: View {
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
                
                ExerciseView()
                        .padding(.top, 60)
                
                InsightsSection()
               


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


struct ActionButtonView: View {
    @State private var selectedButton: String? = nil
    @State private var streakProgress: CGFloat = 0.0
    @State private var breakDayProgress: CGFloat = 0.0

    var body: some View {
        HStack(spacing: 40) {
            ActionButton(
                isSelected: .constant(false),
                imageName: "trophy",
                progress: .constant(0.0)
            )

            ActionButton(
                isSelected: Binding(
                    get: { selectedButton == "streak" },
                    set: { selectedButton = $0 ? "streak" : nil }
                ),
                imageName: "Streak",
                progress: $streakProgress
            )

            ActionButton(
                isSelected: Binding(
                    get: { selectedButton == "breakday" },
                    set: { selectedButton = $0 ? "breakday" : nil }
                ),
                imageName: "breakday",
                progress: $breakDayProgress
            )
        }
    }
}

struct ActionButton: View {
    @Binding var isSelected: Bool
    var imageName: String
    @Binding var progress: CGFloat

    var body: some View {
        Button(action: {
            withAnimation {
                isSelected.toggle()
            }
        }) {
            ZStack {
                Rectangle()
                    .fill(Color(red: 0.9, green: 0.8, blue: 0.6))
                    .frame(width: isSelected ? 140 : 80, height: 80)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(radius: 2)

                HStack(spacing: 10) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)

                    if isSelected {
                        ZStack() {
                            CustomProgressBar(progress: progress / 5.0)
                                .frame(width: 50, height: 20)

                            Text("\(Int(progress))/5")
                                                            .font(.custom("GNF", size: 14).weight(.bold))
                                                            .foregroundColor(Color(red: 0x2F/255, green: 0x2F/255, blue: 0x4B/255)) // Changed to #2F2F4B


                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomProgressBar: View {
    var progress: CGFloat // from 0.0 to 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0xD1/255, green: 0x7F/255, blue: 0x74/255)) // Changed to #D17F74
                    .frame(width: geometry.size.width, height: geometry.size.height)

                Rectangle()
                    .fill(Color(red: 0.9, green: 0.4, blue: 0.4))
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
            }
            .cornerRadius(2)
            .overlay(
                           RoundedRectangle(cornerRadius: 2)
                               .stroke(Color(red: 0x2F/255, green: 0x2F/255, blue: 0x4B/255), lineWidth: 3) // Updated stroke color to #2F2F4B
                       )
        }
    }
}




struct ExerciseView: View {
    @State private var isChecked: Bool = false
       
       var body: some View {
           HStack {
               VStack() {
                   Image("clock")
                       .resizable()
                       .frame(width: 50, height: 50)
                   
                   Text("1:30")
                       .font(.custom("GNF", size: 14))
               }
               .padding(.top, 20)
               .frame(width: 50, height: 50)
               .cornerRadius(3)
               
               VStack(alignment: .leading, spacing: 4) {
                   Text("Did you Workout today?")
                       .font(.custom("GNF", size: 18))
                       .foregroundColor(Color(red: 0xC7/255, green: 0xAA/255, blue: 0x82/255)) // similar color from screenshot
                   
                   Text("Just a quick checkup...") // placeholder description
                       .font(.custom("GNF", size: 14))
                       .foregroundColor(Color(red: 0xC7/255, green: 0xAA/255, blue: 0x82/255))
                       .lineLimit(2)
               }
               
               Spacer()
               
               Button(action: {
                   isChecked.toggle()
               }) {
                   Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                       .resizable()
                       .frame(width: 26, height: 26)
                       .foregroundColor(isChecked ? Color(red: 0xC7/255, green: 0xAA/255, blue: 0x82/255) : .white)
               }
           }
           .padding()
           .background(Color.brandNavy)
           .cornerRadius(5)
           .padding(.horizontal, 20)
       }
}

struct InsightsSection: View {
    var dailyGoal: CGFloat = 3.5
    var dailyGoalMax: CGFloat = 5
    var petLevel: Int = 4
    var maxPetLevel: Int = 10
    var streakDays: Int = 12

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Insights")
                .font(.custom("GNF", size: 24))
                .fontWeight(.bold)
                .padding(.horizontal, 20)

            LazyVGrid(columns: columns, spacing: 20) {
                InsightCard(title: "Daily Goal") {

                    Text("Run 10k miles")
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(.gray)
                }

                InsightCard(title: "Streak") {
                    Text("\(streakDays) days")
                        .font(.custom("GNF", size: 30))
                        .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.4))
                        .fontWeight(.bold)

                    Text("Keep going!")
                        .font(.custom("GNF", size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 40)
    }
}
struct InsightCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom("GNF", size: 18))
                .fontWeight(.semibold)

            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    PetPage()
}
