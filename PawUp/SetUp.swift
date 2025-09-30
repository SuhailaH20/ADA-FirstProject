import SwiftUI

struct SetUp: View {
    
    @State private var name: String = ""
    @State private var selectedGoal: String? = nil
    @State private var isGoalDropdownOpen: Bool = false
    @State private var breakDayCount = 0

    let goals: [String] = [
        "Build muscle and improve physical fitness" ,"Practice regularly without missing planned sessions","Do sport multiple times a week","Stay hydrated on training days","Do yoga","RWalk 10,000 steps daily", "Lose 10 kg through regular sports", "Play basketball consistently","Eating healthy foods", "Reduce stress and improve mental well being","Try a new sport this month","Eat vegetables with every meal"
    ]
        
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
                    
                    Text("Goals:")
                        .font(.custom("GNF", size: 20))
                        .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))
                    customDropdown(
                        label: selectedGoal ?? "Select your goal",
                        isOpen: $isGoalDropdownOpen,
                        options: goals,
                        selectedOption: $selectedGoal
                    )
                    
                    Text("Breakdays:")
                        .font(.custom("GNF", size: 20))
                            .foregroundColor(Color(red: 47/255, green: 47/255, blue: 75/255))

                        Stepper(value: $breakDayCount, in: 0...5) {
                            Text("\(breakDayCount) day\(breakDayCount == 1 ? "" : "s")")
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
                
                Button(action: {
                    print("Name: \(name)")
                    print("Goal: \(selectedGoal ?? "None")")
                    print("Breakdays: \(breakDayCount)")
                }) {
                    ZStack {
                        Image("Rectangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Continue")
                            .font(.custom("GNF", size: 22))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        
    }
    
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
                        .foregroundColor(selectedOption.wrappedValue == nil
                            ? .gray : Color(red: 47 / 255, green: 47 / 255, blue: 75 / 255))
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
                                }) {
                                    HStack {
                                        Image(systemName: selectedOption.wrappedValue == option ? "largecircle.fill.circle" : "circle")
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



    
    func toggleSelection(_ option: String, selectedSet: Binding<Set<String>>) {
        if selectedSet.wrappedValue.contains(option) {
            selectedSet.wrappedValue.remove(option)
        } else {
            selectedSet.wrappedValue.insert(option)
        }
    }
}

#Preview {
    SetUp()
}
