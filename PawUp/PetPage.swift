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
                    .fixedSize(horizontal: false, vertical: true).padding(.bottom)
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


//  Main View that holds all the Action Buttons
struct ActionButtonView: View {
    
    // Keeps track of which button is currently selected ("streak", "breakday", etc.)
    @State private var selectedButton: String? = nil
    
    // Progress for the "Streak" button (ranges from 0.0 to 5.0)
    @State private var streakProgress: CGFloat = 0.0
    
    // Progress for the "Breakday" button (ranges from 0.0 to 5.0)
    @State private var breakDayProgress: CGFloat = 0.0
    
    // Controls whether the break day confirmation alert is shown
    @State private var showBreakdayConfirmation: Bool = false

    var body: some View {
        HStack(spacing: 40) {
            
            // Trophy Button (doesn't have progress or selection)
            ActionButton(
                isSelected: .constant(false), // always unselected
                imageName: "trophy",
                progress: .constant(0.0),
                onSecondTap: {} // no action on second tap
            )

            // Streak Button
            ActionButton(
                isSelected: Binding(
                    get: { selectedButton == "streak" }, // selected if "streak" is current
                    set: { selectedButton = $0 ? "streak" : nil } // set or unset selection
                ),
                imageName: "Streak",
                progress: $streakProgress, // bind to streak progress
                onSecondTap: {} // add custom behavior if needed
            )

            // Breakday Button
            ActionButton(
                isSelected: Binding(
                    get: { selectedButton == "breakday" }, // selected if "breakday" is current
                    set: { newValue in
                        // If already selected and tapped again, show confirmation
                        if selectedButton == "breakday" {
                            showBreakdayConfirmation = true
                        }
                        // Set or unset selection
                        selectedButton = newValue ? "breakday" : nil
                    }
                ),
                imageName: "breakday",
                progress: $breakDayProgress, // bind to breakday progress
                onSecondTap: {
                    // Show alert when tapped again while selected
                    showBreakdayConfirmation = true
                }
            )
        }
        // Show confirmation alert when breakday is tapped twice
        .alert("Use a break day?", isPresented: $showBreakdayConfirmation) {
            Button("Yes", role: .destructive) {
                // Increase progress if confirmed (max 5 can be added later)
                breakDayProgress += 1
            }
            Button("Cancel", role: .cancel) {} // Dismiss alert
        }
    }
}

//
// Reusable Action Button
//
struct ActionButton: View {
    
    // Tracks whether this specific button is selected
    @Binding var isSelected: Bool
    
    // Name of the image to display
    var imageName: String
    
    // Progress value (from 0.0 to 5.0)
    @Binding var progress: CGFloat
    
    // What to do when the selected button is tapped again
    var onSecondTap: () -> Void

    var body: some View {
        Button(action: {
            withAnimation {
                // If already selected, it's a second tap
                if isSelected {
                    onSecondTap()
                }
                // Toggle selection
                isSelected.toggle()
            }
        }) {
            ZStack {
                // Background box with shadow
                Rectangle()
                    .fill(Color(red: 0.9, green: 0.8, blue: 0.6)) // Light beige color
                    .frame(width: isSelected ? 140 : 80, height: 80) // Expand if selected
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(radius: 2)

                HStack(spacing: 10) {
                    // Icon image
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)

                    // Show progress only when selected
                    if isSelected {
                        ZStack {
                            // Custom progress bar, divided by 5 to make 0.0–1.0 range
                            CustomProgressBar(progress: progress / 5.0)
                                .frame(width: 50, height: 20)

                            // Display progress number
                            Text("\(Int(progress))/5")
                                .font(.custom("GNF", size: 14).weight(.bold))
                                .foregroundColor(Color(red: 0x2F/255, green: 0x2F/255, blue: 0x4B/255))
                        }
                        // Animation when appearing
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}

//
// Custom Progress Bar View
//
struct CustomProgressBar: View {
    
    // The progress value from 0.0 to 1.0
    var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                // Background of the progress bar
                Rectangle()
                    .fill(Color(red: 0xD1/255, green: 0x7F/255, blue: 0x74/255)) // #D17F74
                    .frame(width: geometry.size.width, height: geometry.size.height)

                // Filled portion based on progress
                Rectangle()
                    .fill(Color(red: 0.9, green: 0.4, blue: 0.4)) // A darker red
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
            }
            .cornerRadius(2)
            // Add border around the progress bar
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0x2F/255, green: 0x2F/255, blue: 0x4B/255), lineWidth: 3) // #2F2F4B
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
                        .font(.custom("GNF", size: 20))
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
        VStack(alignment: .leading, spacing: 5) {
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
