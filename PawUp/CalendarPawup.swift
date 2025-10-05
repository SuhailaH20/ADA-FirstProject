//
//  CalendarPawup.swift
//  PawUp
//
//  Created by dana on 08/04/1447 AH.
//
import Foundation
import SwiftUI

// Custom font helper
extension Font {
    static func gnf(_ size: CGFloat) -> Font {
        .custom("GNF", size: size)
    }
}

// Day cell view with an extra case `fadedNumber` for out-of-month days in gray
struct DayCell: View {
    enum Content: Equatable {
        case number(Int)        // Day inside the current month
        case fadedNumber(Int)   // Day from previous/next month (gray)
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

                case .fadedNumber(let n):
                    Text("\(n)")
                        .font(.gnf(24))
                        .foregroundStyle(.gray)

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

// Calendar screen using a 6x7 grid and previous/next month
struct CalendarPawup: View {
    private let pageBG = Color(red: 0.98, green: 0.96, blue: 0.92)
    private let weekdays = ["S","M","T","W","T","F","S"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 7)

    // Currently visible month
    @State private var visibleMonth: Date = Date()

    // Persisted start date set when user tapped Continue in SetUp
    @AppStorage("calendarStartDate") private var calendarStartDate: String = "" // ISO "yyyy-MM-dd"

    // Lock calculations to Gregorian, Sunday-first, and stable timezone
    private var cal: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale(identifier: "en_US_POSIX")
        c.firstWeekday = 1 // Sunday
        c.timeZone = TimeZone(secondsFromGMT: 0)! // keep weekday stable
        return c
    }

    // Parse ISO "yyyy-MM-dd" string to Date in UTC; return nil if not set
    private func parseStartDate(_ s: String) -> Date? {
        guard !s.isEmpty else { return nil }
        let fmt = DateFormatter()
        fmt.calendar = cal
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = cal.timeZone
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.date(from: s)
    }

    // Returns true if the given date is before the stored start date.
    // If no start date is stored yet, treat as "before" to suppress icons everywhere.
    private func isBeforeStartDate(_ date: Date) -> Bool {
        guard let start = parseStartDate(calendarStartDate) else { return true }
        return cal.startOfDay(for: date) < cal.startOfDay(for: start)
    }

    var body: some View {
        ZStack {
            pageBG.ignoresSafeArea()

            VStack(spacing: 30) {
                // Header bar
                HStack(spacing: 16) {
                    Button { changeMonth(by: -1) } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                    }

                    Text(monthTitle(for: visibleMonth))
                        .font(.gnf(28))

                    Button { changeMonth(by: 1) } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold))
                    }

                    Spacer()

                    Button("Today") { visibleMonth = Date() }
                        .font(.gnf(14))
                }
                .padding(.horizontal, 20)

                // Weekday headers
                HStack {
                    ForEach(weekdays, id: \.self) { d in
                        Text(d)
                            .font(.gnf(18))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 12)

                // 6x7 grid
                LazyVGrid(columns: columns, spacing: 14) {
                    let cells = buildCells(for: visibleMonth)
                    ForEach(0..<cells.count, id: \.self) { idx in
                        cells[idx]
                    }
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    // MARK: - Navigation and formatting
    private func changeMonth(by value: Int) {
        if let newDate = cal.date(byAdding: .month, value: value, to: visibleMonth) {
            visibleMonth = newDate
        }
    }

    private func monthTitle(for date: Date) -> String {
        let fmt = DateFormatter()
        fmt.calendar = cal
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = cal.timeZone
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: date)
    }

    // MARK: - Calendar helpers
    private func firstOfMonth(_ date: Date) -> Date {
        let comps = cal.dateComponents([.year, .month], from: date)
        return cal.date(from: comps)!
    }

    private func daysInMonth(_ date: Date) -> Int {
        let range = cal.range(of: .day, in: .month, for: firstOfMonth(date))!
        return range.count
    }

    private func weekday(_ date: Date) -> Int {
        cal.component(.weekday, from: date) // 1..7 (Sun..Sat)
    }

    private func plusMonth(_ date: Date, by v: Int) -> Date {
        cal.date(byAdding: .month, value: v, to: date)!
    }

    private func dateFor(_ baseMonth: Date, day: Int) -> Date {
        var comps = cal.dateComponents([.year, .month], from: baseMonth)
        comps.day = day
        return cal.date(from: comps)!
    }

    private func isPast(_ date: Date) -> Bool {
        let today = cal.startOfDay(for: Date())
        let target = cal.startOfDay(for: date)
        return target < today
    }

    /// Build 42 cells (6 rows x 7 columns)
    /// - Leading from previous month as gray numbers
    /// - Current month: show star/broken-heart ONLY on/after the stored start date; older days show plain numbers
    /// - Trailing from next month as gray numbers
    private func buildCells(for monthDate: Date) -> [AnyView] {
        let first = firstOfMonth(monthDate)
        let dim = daysInMonth(monthDate)

        // Sunday-first grid
        let leading = (weekday(first) - cal.firstWeekday + 7) % 7

        let prevMonth = plusMonth(monthDate, by: -1)
        let dimPrev = daysInMonth(prevMonth)

        let used = leading + dim
        let rows = Int(ceil(Double(used) / 7.0))
        let trailingCount = rows * 7 - used

        var views: [AnyView] = []
        views.reserveCapacity(leading + dim + trailingCount)

        // 1) Previous month days (gray)
        if leading > 0 {
            let startDay = dimPrev - leading + 1
            for d in startDay...dimPrev {
                views.append(AnyView(
                    DayCell(content: .fadedNumber(d))
                ))
            }
        }

        // 2) Current month days
        for d in 1...dim {
            let cellDate = dateFor(monthDate, day: d)

            // NEW RULE: suppress icons for any date earlier than the stored start date
            if isBeforeStartDate(cellDate) {
                views.append(AnyView(DayCell(content: .number(d))))
                continue
            }

            // From the stored start date onward: keep your original logic
            if let did = WorkoutStore.get(on: cellDate) {
                views.append(AnyView(
                    DayCell(content: .image(did ? "Star" : "brokenheart"))
                ))
            } else {
                if isPast(cellDate) {
                    views.append(AnyView(DayCell(content: .image("brokenheart"))))
                } else {
                    views.append(AnyView(DayCell(content: .number(d))))
                }
            }
        }

        // 3) Next month days (gray)
        if trailingCount > 0 {
            for d in 1...trailingCount {
                views.append(AnyView(
                    DayCell(content: .fadedNumber(d))
                ))
            }
        }

        return views
    }
}

#Preview { CalendarPawup() }
