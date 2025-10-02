//
//  Untitled.swift
//  PawUp
//
//  Created by Wareef Saeed Alzahrani on 07/04/1447 AH.
//
//
//  ContentView.swift
//  Pawup
//
//  Created by Wareef Saeed Alzahrani on 06/04/1447 AH.
//
import SwiftUI

enum Buddy: String, CaseIterable, Identifiable {
    case cat, dog
    var id: String { rawValue }
    var assetName: String {
        switch self {
        case .cat: return "pet_cat_pixel"
        case .dog: return "pet_dog_pixel"
        }
    }
}

struct pickyourbuddy: View {
    @AppStorage("petName") private var petName: String = ""
    @AppStorage("selectedBuddy") private var selectedBuddyID: String = ""

    @State private var goSetUp = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0xFD/255, green: 0xF8/255, blue: 0xEF/255)
                    .ignoresSafeArea()

                VStack(spacing: 2) {

                    Text("Choose your Buddy!")
                        .font(.custom("GNF", size: 35))
                        .padding(.vertical, 20.0)
                        .foregroundStyle(Color("brandNavy"))
                        .padding(.top,70)

                    Text("Ready to meet your new fitness sidekick?")
                        .font(.custom("GNF", size: 20))
                        .foregroundStyle(Color("brandPink"))
                        .multilineTextAlignment(.center)

                    HStack(spacing: 16) {
                        ForEach(Buddy.allCases) { buddy in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedBuddyID = buddy.rawValue   // ← التخزين الفعلي
                                }
                            } label: {
                                Image(buddy.assetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 180)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 0)
                                            .fill(Color.white.opacity(0))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedBuddyID == buddy.rawValue ? Color("brandPink") : .clear, lineWidth: 3)
                                    )
                                    .shadow(radius: selectedBuddyID == buddy.rawValue ? 6 : 0)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pet name")
                            .font(.custom("GNF", size: 20))
                            .foregroundStyle(Color("brandNavy"))

                        TextField("Enter your pet name…", text: $petName)
                            .font(.custom("GNF", size: 20))
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            .shadow(color: .gray.opacity(0.2), radius: 2)
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button(action: { goSetUp = true }) {
                        Text("Continue")
                            .font(.custom("GNF", size: 21))
                            .foregroundStyle(Color.white)
                            .frame(width: 350, height: 49)
                            .background(Color.brandNavy)
                            .cornerRadius(5)
                    }
                    .disabled(petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedBuddyID.isEmpty)
                    .opacity((petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedBuddyID.isEmpty) ? 0.6 : 1)

                }
                .padding()
            }
            .navigationDestination(isPresented: $goSetUp) {
                SetUp()
            }
        }
    }
}

#Preview {
    pickyourbuddy()
}
