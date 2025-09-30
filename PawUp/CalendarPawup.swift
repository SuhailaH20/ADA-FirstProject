//
//  CalendarPawup.swift
//  PawUp
//
//  Created by dana on 08/04/1447 AH.
//

import Foundation
import SwiftUI

extension Font {
    static func gnf(_ size: CGFloat) -> Font {
        .custom("GNF", size: size)
    }
}

struct DayCell: View {
    enum Content: Equatable {
        case number(Int)
        case image(String)
        case empty
        case none
    }
    let content: Content

    var body: some View {
        switch content {
        case .none:
            EmptyView()
        default:
            ZStack {
                Image("Rectangle2")
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5))

                switch content {
                case .number(let n):
                    Text("\(n)")
                        .font(.gnf(24))
                        .foregroundStyle(.black)

                case .image(let name):
                    Image(name)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 28, height: 28)

                case .empty:
                    Image("Star")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 28, height: 28)

                case .none:
                    EmptyView()
                }
            }
        }
    }
}

struct CalendarPawup: View {
    private let pageBG = Color(red: 0.98, green: 0.96, blue: 0.92)
    private let weekdays = ["S","M","T","W","T","F","S"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 7)

    @State private var didWorkoutToday: Bool = true

    private let grid: [[DayCell.Content]] = [
        [.empty, .image("Star"), .image("Star"), .image("brokenheart"), .image("Star"), .number(5), .number(6)],
        [.image("Star"), .image("Star"), .image("brokenheart"), .image("Star"), .image("brokenheart"), .number(12), .number(13)],
        [.image("Star"), .empty, .image("brokenheart"), .empty, .image("brokenheart"), .number(19), .number(20)],
        [.image("Star"), .image("Star"), .image("brokenheart"), .image("Star"), .image("brokenheart"), .number(26), .number(27)],
        [.image("Star"), .image("brokenheart"), .image("Star"), .none, .none, .none, .none]
    ]

    var body: some View {
        ZStack {
            pageBG.ignoresSafeArea()

            VStack(spacing: 30) {
                HStack(spacing: 10) {
                    Spacer()
                    Image(systemName: "chevron.left")
                        .font(.system(size: 23, weight: .bold))
                    Text("September")
                        .font(.gnf(36))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 23, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal, 63)

            
                HStack(spacing: 12) {
                    Button("Workout completed today") { didWorkoutToday = true }
                    Button("Skip workout today") { didWorkoutToday = false }
                }
                .font(.gnf(12))
                .padding(.horizontal, 63)

                HStack {
                    ForEach(weekdays, id: \.self) { d in
                        Text(d)
                            .font(.gnf(18))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 17)

            
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(0..<grid.count, id: \.self) { r in
                        ForEach(0..<7, id: \.self) { c in
                            let base = grid[r][c]

                            if let day = dayNumberAt(row: r, col: c),
                               isToday(day: day) {
                                
                                DayCell(content: .image(didWorkoutToday ? "Star" : "brokenheart"))
                            } else {
                
                                if base == .none {
                                    EmptyView()
                                } else {
                                    DayCell(content: base)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .center)
            .offset(y: -24)
        }
    }


    private func dayNumberAt(row: Int, col: Int) -> Int? {
        let cal = Calendar.current
        let today = Date()
        guard let firstOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: today)),
              let daysRange = cal.range(of: .day, in: .month, for: today) else { return nil }

        let weekdayOfFirst = cal.component(.weekday, from: firstOfMonth)
        let leadingEmpty = weekdayOfFirst - 1
        let index = row * 7 + col
        let dayNumber = index - leadingEmpty + 1
        return daysRange.contains(dayNumber) ? dayNumber : nil
    }

   
    private func isToday(day: Int) -> Bool {
        let cal = Calendar.current
        let comps = cal.dateComponents([.day], from: Date())
        return comps.day == day
    }
}

#Preview {
    CalendarPawup()
}
