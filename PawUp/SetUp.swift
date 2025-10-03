import SwiftUI

struct SetUp: View {
    
    // Persisted values across app launch
    @AppStorage("name") var name: String = ""
    @AppStorage("selectedGoal") var storedGoal: String = ""
    @AppStorage("breakDayCount") var storedBreakDays: Int = 0
    
    // Local state for UI
    @State private var selectedGoal: String? = nil
    @State private var isGoalDropdownOpen: Bool = false
    @State private var breakDayCount = 0
    @State private var goNotification: Bool = false

    let goals: [String] = [
        "Build muscle and improve physical fitness",
        "Practice regularly without missing planned sessions",
        "Do sport multiple times a week",
        "Stay hydrated on training days",
        "Do yoga",
        "Walk 10,000 steps daily",
        "Lose 10 kg through regular sports",
        "Play basketball consistently",
        "Eat healthy foods",
        "Reduce stress and improve mental well being",
        "Try a new sport this month",
        "Eat vegetables with every meal"
    ]
    
    var isFormValid: Bool {
        return !name.isEmpty && !(selectedGoal ?? storedGoal).isEmpty
    }
    
        
    var body: some View {
        ZStack {
            Color(red: 253/255, green: 248/255, blue: 239/255)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                Text("Let's Set You Up!")
                    .font(.custom("GNF", size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                
                Text("Your buddy’s excited to cheer you on let’s tell them a bit about you!")
                    .font(.custom("GNF", size: 20))
                    .foregroundColor(Color(red: 208/255, green: 127/255, blue: 116/255))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Name field
                    Text("Name:")
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                    
                    TextField("Enter your name", text: $name)
                        .font(.custom("GNF", size: 18))
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 216/255, green: 184/255, blue: 135/255), lineWidth: 2)
                        )
                    
                    // Goals dropdown
                    Text("Goals:")
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                    
                    customDropdown(
                        label: selectedGoal ?? (storedGoal.isEmpty ? "Select your goal" : storedGoal),
                        isOpen: $isGoalDropdownOpen,
                        options: goals,
                        selectedOption: $selectedGoal
                    )
                    
                    // Breakdays
                    Text("Breakdays:")
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))

                    Stepper(value: $breakDayCount, in: 0...3) {
                        Text("\(breakDayCount) Day\(breakDayCount == 1 ? "" : "s")")
                            .font(.custom("GNF", size: 18))
                            .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(red: 216/255, green: 184/255, blue: 135/255), lineWidth: 2)
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Continue button (saves + navigates)
                Button(action: {
                    storedGoal = selectedGoal ?? storedGoal
                    storedBreakDays = breakDayCount
                    goNotification = true
                }) {
                    Text("Continue")
                        .font(.custom("GNF", size: 21))
                        .foregroundStyle(Color.white)
                        .frame(width: 350, height: 49)
                        .background(isFormValid ? Color.brandNavy : Color.gray)
                        .cornerRadius(5)
                }
                .disabled(!isFormValid)
                .navigationDestination(isPresented: $goNotification) {
                    NotificationPawUp()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    // MARK: - Custom Dropdown
    @ViewBuilder
    func customDropdown(label: String, isOpen: Binding<Bool>, options: [String], selectedOption: Binding<String?>, otherDropdown: Binding<Bool>? = nil) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation {
                    if !isOpen.wrappedValue {
                        otherDropdown?.wrappedValue = false
                    }
                    isOpen.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text(label)
                        .font(.custom("GNF", size: 18))
                        .foregroundColor(label == "Select your goal" ? .gray : Color(red: 47/255, green: 47/255, blue: 75/255))
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()
                    Image(systemName: isOpen.wrappedValue ? "chevron.up" : "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(red: 216/255, green: 184/255, blue: 135/255))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(red: 216/255, green: 184/255, blue: 135/255), lineWidth: 2)
                )
            }

            if isOpen.wrappedValue {
                VStack(alignment: .leading, spacing: 12) {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    selectedOption.wrappedValue = option
                                    storedGoal = option
                                }) {
                                    HStack {
                                        Image(systemName: (selectedOption.wrappedValue ?? storedGoal) == option ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(Color(red: 208/255, green: 127/255, blue: 116/255))
                                        Text(option)
                                            .font(.custom("GNF", size: 18))
                                            .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .frame(maxHeight: 250)

                    Button("Done") {
                        withAnimation {
                            isOpen.wrappedValue = false
                        }
                    }
                    .font(.custom("GNF", size: 18))
                    .padding(.top, 8)
                    .foregroundColor(Color(red: 216/255, green: 184/255, blue: 135/255))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(red: 216/255, green: 184/255, blue: 135/255), lineWidth: 2)
                )
                .padding(.top, 5)
            }
        }
    }
}

#Preview {
    SetUp()
}
