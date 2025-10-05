//
//  ContentView.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 03/04/1447 AH.
//
//areeeg
import SwiftUI

// Date function
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
        NavigationStack{
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
                    
                    // Main card and action btn
                    ZStack(alignment: .bottom) {
                        BuddyCardView()
                        ActionButtonView(streakManager: streakManager)
                            .offset(y: 40)
                    }
                    
                    ExerciseView(streakManager: streakManager)
                        .padding(.top, 60)
                    
                    InsightsSection(streakManager: streakManager)
                    
                    CalendarWeekView()
                    
                }
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
    @ObservedObject var streakManager: StreakManager

    @State private var selectedButton: String? = nil
    @State private var breakDayProgress: CGFloat = 0.0
    @State private var showBreakdayConfirmation: Bool = false
    @State private var showTrophySheet: Bool = false

    var body: some View {
        HStack(spacing: 40) {
            TrophyButton {
                showTrophySheet = true
            }

            // Use streakManager.streakDays for progress
            ActionButton(
                isSelected: Binding(
                    get: { selectedButton == "streak" },
                    set: { selectedButton = $0 ? "streak" : nil }
                ),
                imageName: "Streak",
                progress: .constant(CGFloat(min(streakManager.streakDays, 5))), // max 5
                onSecondTap: {}
            )

            ActionButton(
                isSelected: Binding(
                    get: { selectedButton == "breakday" },
                    set: {
                        if selectedButton == "breakday" {
                            showBreakdayConfirmation = true
                        }
                        selectedButton = $0 ? "breakday" : nil
                    }
                ),
                imageName: "breakday",
                progress: $breakDayProgress,
                onSecondTap: {
                    showBreakdayConfirmation = true
                }
            )
        }
        .alert("Use a break day?", isPresented: $showBreakdayConfirmation) {
            Button("Yes", role: .destructive) {
                breakDayProgress += 1
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showTrophySheet) {
            BottomSheetView()
        }
    }
}

struct ActionButton: View {
    @Binding var isSelected: Bool
    var imageName: String
    @Binding var progress: CGFloat
    var onSecondTap: () -> Void

    var body: some View {
        Button(action: {
            withAnimation {
                if isSelected { onSecondTap() }
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
                        ZStack {
                            CustomProgressBar(progress: progress / 5.0)
                                .frame(width: 50, height: 20)
                            Text("\(Int(progress))/5")
                                .font(.custom("GNF", size: 14).weight(.bold))
                                .foregroundColor(Color(red: 0x2F/255, green: 0x2F/255, blue: 0x4B/255))
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TrophyButton: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: { onTap() }) {
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

struct CustomProgressBar: View {
    var progress: CGFloat
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color("brandBG"))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Rectangle()
                    .fill(Color("brandPink"))
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
            }
            .cornerRadius(2)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0x2B/255, green: 0x2F/255, blue: 0x4B/255), lineWidth: 3)
            )
        }
    }
}

struct ExerciseView: View {
    @State private var isChecked: Bool = false
    @ObservedObject var streakManager: StreakManager
    @State private var isButtonDisabled = false
    @AppStorage("coins") private var coins: Int = 0
    @AppStorage("lastCheckInDate") private var lastCheckInDate: String = ""

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
                    .foregroundColor(Color(red: 0xC7/255, green: 0xAA/255, blue: 0x82/255))

                Text("Just a quick checkup...")
                    .font(.custom("GNF", size: 14))
                    .foregroundColor(Color(red: 0xC7/255, green: 0xAA/255, blue: 0x82/255))
                    .lineLimit(2)
            }

            Spacer()

            Button(action: {
                // Keep original behavior + persist workout = true for today
                streakManager.resetIfMissed()
                isChecked.toggle()
                isButtonDisabled = true
                streakManager.checkInToday()

               
                if isChecked {
                    WorkoutStore.set(true, on: Date())
                }

                // Reset after 1 minute (UI only)
                DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                    isChecked = false
                    isButtonDisabled = false
                }

                if isChecked {
                    let today = formattedToday()
                    if lastCheckInDate != today {
                        coins += 1
                        lastCheckInDate = today
                    }
                }
            }) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(isChecked ? Color(red: 0xC7/255, green: 0xAA/255, blue: 0x82/255) : .white)
            }
            .disabled(isButtonDisabled || isChecked)
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
                .frame(maxWidth: .infinity)

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
                .frame(width: 120)
            }
            .frame(height: 130)
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
            ActionButtonView(streakManager: streakManager)
        }
        .onAppear {
            streakManager.resetIfMissed()
        }
    }
}

struct Item {
    var name: String
    var price: Int
}

struct BottomSheetView: View {
    //  items name and a price
    let items: [Item] = [
            Item (name: "necklace", price: 10),
            Item (name: "redTie", price: 15),
            Item (name: "pinkTie", price: 20)
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    // Shared storage for selected accessory
    @AppStorage("selectedAccessory") private var selectedAccessory: String = ""
    @AppStorage("coins") private var coins: Int = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                
                // Trophy grid
                VStack {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items, id: \.name) { item in
                            TrophyTile(
                                imageName: item.name,
                                price: item.price,
                                isSelected: selectedAccessory == item.name
                            ) {
                                // Toggle accessory: if already selected, remove it
                                if selectedAccessory == item.name {
                                    selectedAccessory = ""
                                } else if coins >= item.price {
                                    // Enough coins → buy and equip
                                    coins -= item.price
                                    selectedAccessory = item.name
                                    alertMessage = "You bought the \(item.name)!"
                                    showAlert = true
                                }
                                else {
                                    // Not enough coins
                                    alertMessage = "Workout more to earn enough coins!"
                                    showAlert = true
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
        .alert(alertMessage, isPresented: $showAlert) {
            Button ("OK"
                    , role: .cancel) {
            }
        }
    }
        
        
    struct TrophyTile: View {
        var imageName: String
        var price: Int
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
                            Text("\(price)")
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
    
    struct CalendarWeekView: View {
        private let calendar = Calendar.current
        private let today = Date()
        
        // Weekday letters for display: ["S", "M", ..., "S"]
        private let weekdaySymbols = Calendar.current.shortWeekdaySymbols
        
        private var weekDates: [Date] {
            // Start from Sunday of current week
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        }
        
        var body: some View {
            VStack(alignment: .leading){
                NavigationLink(destination: CalendarPawup()) {
                    HStack (spacing: -15){
                        Text("Your Calendar")
                            .font(.custom("GNF", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                        
                        Image("paly")
                            .resizable()
                            .frame(width: 28, height: 28)
                        
                    }
                }
                HStack(spacing: 12) {
                    ForEach(Array(weekDates.enumerated()), id: \.element) { index, date in
                        VStack(spacing: 6) {
                            // Weekday letter above each cell
                            Text(weekdayLetter(for: date))
                                .font(.gnf(16))
                                .foregroundColor(.black)
                            
                            // Day content
                            let day = calendar.component(.day, from: date)
                            
                            if let did = WorkoutStore.get(on: date) {
                                DayCell(content: .image(did ? "Star" : "brokenheart"))
                            } else if isPast(date) {
                                DayCell(content: .image("brokenheart"))
                            } else {
                                DayCell(content: .number(day))
                            }
                        }
                    }
                } .padding(.horizontal, 12)
            }
            
        }
        
        private func isPast(_ date: Date) -> Bool {
            let today = calendar.startOfDay(for: Date())
            let target = calendar.startOfDay(for: date)
            return target < today
        }
        
        private func weekdayLetter(for date: Date) -> String {
            let index = calendar.component(.weekday, from: date) - 1
            // Make sure it's in bounds
            return (0..<7).contains(index) ? String(weekdaySymbols[index].prefix(1)) : ""
        }
    }


#Preview {
    PetPage()
}

