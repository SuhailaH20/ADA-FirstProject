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
                    Image("Star 1")
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

struct CalendarView: View {
    private let pageBG = Color(red: 0.98, green: 0.96, blue: 0.92)
    private let weekdays = ["S","M","T","W","T","F","S"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 7)

    // Visible month/year (starts at current date)
    @State private var visibleMonth: Date = Date()

    var body: some View {
        ZStack {
            pageBG.ignoresSafeArea()

            VStack(spacing: 30) {
                // Header bar + arrows
                HStack(spacing: 16) {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                    }

                    Text(monthTitle(for: visibleMonth))
                        .font(.gnf(28))

                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold))
                    }

                    Spacer()

                    // Jump back to current month
                    Button("Today") {
                        visibleMonth = Date()
                    }
                    .font(.gnf(14))
                }
                .padding(.horizontal, 20)

                // Weekday titles
                HStack {
                    ForEach(weekdays, id: \.self) { d in
                        Text(d)
                            .font(.gnf(18))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 12)

                // Day grid (reads per-day state from storage)
                LazyVGrid(columns: columns, spacing: 14) {
                    let model = monthModel(for: visibleMonth)
                    ForEach(0..<model.totalCells, id: \.self) { index in
                        if let day = model.dayNumber(at: index) {
                            if let dateForCell = dateFor(visibleMonth, day: day) {
                                if let did = WorkoutStore.get(on: dateForCell) {
                                    // Stored explicitly → show star or broken heart
                                    DayCell(content: .image(did ? "Star" : "brokenheart"))
                                } else {
                                    // Not stored:
                                    // - Past day → treat as missed (broken heart)
                                    // - Today or future → just show the number
                                    if isPast(dateForCell) {
                                        DayCell(content: .image("brokenheart"))
                                    } else {
                                        DayCell(content: .number(day))
                                    }
                                }
                            } else {
                                DayCell(content: .number(day))
                            }
                        } else {
                            DayCell(content: .none)
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
            // Center content vertically
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    // MARK: - Month navigation & formatting
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: visibleMonth) {
            visibleMonth = newDate
        }
    }

    private func monthTitle(for date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: date)
    }

    // MARK: - Helpers
    private func dateFor(_ monthDate: Date, day: Int) -> Date? {
        var comps = Calendar.current.dateComponents([.year, .month], from: monthDate)
        comps.day = day
        return Calendar.current.date(from: comps)
    }

    private func isPast(_ date: Date) -> Bool {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let target = cal.startOfDay(for: date)
        return target < today
    }

    private func monthModel(for date: Date) -> MonthGridModel {
        let cal = Calendar.current
        guard
            let firstOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: date)),
            let daysRange = cal.range(of: .day, in: .month, for: date)
        else {
            return MonthGridModel(leadingEmpty: 0, daysInMonth: 30) // fallback
        }
        let weekdayOfFirst = cal.component(.weekday, from: firstOfMonth)
        let leading = weekdayOfFirst - 1
        return MonthGridModel(leadingEmpty: leading, daysInMonth: daysRange.count)
    }

    struct MonthGridModel {
        let leadingEmpty: Int
        let daysInMonth: Int

        var totalCells: Int {
            let total = leadingEmpty + daysInMonth
            let rows = Int(ceil(Double(total) / 7.0))
            return rows * 7
        }

        func dayNumber(at index: Int) -> Int? {
            let day = index - leadingEmpty + 1
            return (1...daysInMonth).contains(day) ? day : nil
        }
    }
}
#Preview {
    CalendarView()
}

