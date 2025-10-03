//
//  ContentView.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 03/04/1447 AH.
//
//areeeg
import SwiftUI

//Date funtion
// Returns today's date as a string
func formattedToday() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
}

struct PetPage: View {
    // To display the goal taken
    
    @AppStorage("selectedGoal") var storedGoal: String = ""
    @AppStorage("petName") private var petName: String = ""
    @AppStorage("selectedBuddy") private var selectedBuddyID: String = ""
    

    @StateObject private var streakManager = StreakManager()


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
                
                ExerciseView(streakManager: streakManager)
                        .padding(.top, 60)
                
                InsightsSection(streakManager: streakManager)
               


            }
        }
    }
}

struct coinsView: View {
    @AppStorage("coins") private var coins: Int = 0
    
    var body: some View{
        ZStack{
            Image("coins")
                .resizable()
                .frame(width: 84, height: 40)
            Text("\(coins)")
                .font(.custom("GNF", size: 20))
                .padding(.leading, 23.0)
                
                   
        }
    }
    
}


struct BuddyCardView: View {
    @AppStorage("selectedBuddy") private var selectedBuddyID: String = ""
    @AppStorage("selectedAccessory") private var selectedAccessory: String = "" // add this
    
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
                    .padding(.bottom)
                    .layoutPriority(1)
                
                Spacer(minLength: 20)
                
                ZStack {
                    // Pet base
                    Image("\(selectedBuddyID)_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    
                    // Accessory overlay (if chosen)
                    if !selectedAccessory.isEmpty {
                        Image(selectedAccessory)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 62, height: 62)
                            .offset(accessoryOffsets[selectedBuddyID]?[selectedAccessory] ?? .zero)
                        
                    }
                }
            }
            .padding(20)
        }
        .fixedSize(horizontal: false, vertical: true) // shrink-wrap
    }
    
    private let accessoryOffsets: [String: [String: CGSize]] = [
        "dog":[
            "necklace": CGSize(width: -8, height:-2),
            "redTie": CGSize(width: -8, height: 4),
            "pinkTie": CGSize(width: -8, height: -42)
            // Add more accessories here and tweak their x/y individually
        ],
        "cat": [
            "necklace": CGSize(width: -15, height: 4),
            "redTie": CGSize(width: -16, height: 3),
            "pinkTie": CGSize(width: -15, height: -40)
        ]
]
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
    //
    @State private var showTrophySheet: Bool = false


    var body: some View {
        HStack(spacing: 40) {
            
            // Trophy Button (doesn't have progress or selection)
            TrophyButton {
                showTrophySheet = true
            }
            
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
        .sheet(isPresented: $showTrophySheet) {
            BottomSheetView()
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

// Trophy Button (no progress bar, just the icon)
struct TrophyButton: View {
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            Rectangle()
                .fill(Color(red: 0.9, green: 0.8, blue: 0.6))
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 2)
                .overlay(
                    Image("trophy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                )
        }
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
    @ObservedObject var streakManager: StreakManager
    @AppStorage("coins") private var coins: Int = 0 //total of coins
    @AppStorage("lastCheckInDate") private var lastCheckInDate: String = "" //
    
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
                   streakManager.resetIfMissed()  // Reset streak if missed before checking in
                   isChecked.toggle()
                   
                   if isChecked {
                       streakManager.checkInToday()
                       
                       let today = formattedToday() //today's date
                               if lastCheckInDate != today {
                                   coins += 1 // increase the coins +1
                                   lastCheckInDate = today     // Save today's date so they can't claim again on the same day

                               }
                   }
                   
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
    @ObservedObject var streakManager: StreakManager
    @AppStorage("selectedGoal") var storedGoal: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 9.0) {
            Text("Your Insights")
                .font(.custom("GNF", size: 24))
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)

            HStack(alignment: .top, spacing: 10) {
                // Daily Goal Card - wider
                VStack(alignment: .leading, spacing: 8) {
                    Text("🎯 Daily Goal")
                        .font(.custom("GNF", size: 18))
                        .fontWeight(.semibold)

                    Text(storedGoal.isEmpty ? "No goal enterd" : storedGoal)
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer().frame(minHeight: 10)

                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                .frame(maxWidth: .infinity) // Removed maxHeight

                // Streak Card - narrower
                VStack(alignment: .leading, spacing: 8) {
                    Text("⚡️ Streak")
                        .font(.custom("GNF", size: 18))
                        .fontWeight(.semibold)

                    Text("\(streakManager.streakDays) days")
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.4))
                        .fontWeight(.bold)

                    Text("Keep going!")
                        .font(.custom("GNF", size: 14))
                        .foregroundColor(.gray)

                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                .frame(width: 120) // Removed maxHeight
            }
            .frame(height: 130) // Controls the total height
            .padding(.horizontal, 20)
        }
    }
}


struct ContentView: View {
    @StateObject private var streakManager = StreakManager()

    var body: some View {
        VStack {
            ExerciseView(streakManager: streakManager)
            InsightsSection(streakManager: streakManager)
        }
        .onAppear {
            streakManager.resetIfMissed()
        }
    }
}

struct BottomSheetView: View {
    let items = ["necklace", "redTie", "pinkTie"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Shared storage for selected accessory
    @AppStorage("selectedAccessory") private var selectedAccessory: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 237/255, green: 225/255, blue: 198/255)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Trophies")
                        .font(.custom("GNF", size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                    Image("trophy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                
                Text("Every workout earns you coins—spend them on special accessories to celebrate your progress!")
                    .font(.custom("GNF", size: 20))
                    .foregroundColor(Color(red: 208/255, green: 127/255, blue: 116/255))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items, id: \.self) { item in
                            TrophyTile(
                                imageName: item,
                                isSelected: selectedAccessory == item
                            ) {
                                // Toggle accessory: if already selected, remove it
                                if selectedAccessory == item {
                                    selectedAccessory = ""
                                } else {
                                    selectedAccessory = item
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
        
        struct TrophyTile: View {
            var imageName: String
            var isSelected: Bool = false
            var onTap: () -> Void = {}
            
            var body: some View {
                Button(action: { onTap() }) {
                    VStack(spacing: 8) {
                        Image(imageName)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(height: 60)
                        
                        ZStack {
                            Image("coins")
                                .resizable()
                                .frame(width: 60, height: 24)
                            Text("20")
                                .font(.custom("GNF", size: 16))
                                .foregroundColor(.black)
                                .offset(x: 4)
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 237/255, green: 225/255, blue: 198/255))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

#Preview {
    PetPage()
}
