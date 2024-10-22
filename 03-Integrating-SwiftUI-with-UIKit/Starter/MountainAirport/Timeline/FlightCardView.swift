/// Copyright (c) 2024 Kodeco Inc
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct FlightCardView: View {
  var flight: FlightInformation

  func minutesBetween(_ start: Date, and end: Date) -> Int {
    // 1
    let diff = Calendar.current.dateComponents(
      [.minute], from: start, to: end
    )
    // 2
    guard let minute = diff.minute else {
      return 0
    }
    // 3
    return abs(minute)
  }

  func flightTimeFraction(flight: FlightInformation) -> Double {
    // 1
    let now = Date()
    // 2
    if flight.direction == .departure {
      // 3
      if flight.localTime > now {
        return 0.0
      // 4
      } else if flight.otherEndTime < now {
        return 1.0
      } else {
        // 5
        let timeInFlight = minutesBetween(
          flight.localTime, and: now
        )
        // 6
        let fraction =
          Double(timeInFlight) / Double(flight.flightTime)
        // 7
        return fraction
      }
    } else {
      if flight.otherEndTime > now {
        return 0.0
      } else if flight.localTime < now {
        return 1.0
      } else {
        let timeInFlight = minutesBetween(
          flight.otherEndTime, and: now
        )
        let fraction =
          Double(timeInFlight) / Double(flight.flightTime)
        return fraction
      }
    }
  }

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text(flight.statusBoardName)
        Spacer()
      }
      HStack(alignment: .bottom) {
        DepartureTimeView(flight: flight)
        FlightProgressView(
          flight: flight,
          progress: flightTimeFraction(
            flight: flight
          )
        )
        ArrivalTimeView(flight: flight)
      }
      .padding([.bottom], 12.0)
    }
    .padding()
    .background(
      Color.gray.opacity(0.3)
    )
    .clipShape(
      RoundedRectangle(cornerRadius: 20)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke()
    )
  }
}

#Preview {
  FlightCardView(flight: FlightData.generateTestFlight(date: Date()))
}
