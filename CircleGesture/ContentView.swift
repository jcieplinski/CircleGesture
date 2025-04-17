//
//  ContentView.swift
//  CircleGesture
//
//  Created by Joe Cieplinski on 4/17/25.
//

import SwiftUI

struct ContentView: View {
  @State private var timeRemaining: Int = 300
  @State private var gestureActive: Bool = false
  @State private var ticks: Int = 0
  @State private var timeDifference: Int = 0
  @State var circleIncrement: CircleIncrement = .second
  
  var body: some View {
    ZStack {
      VStack {
        Text(timeRemaining, format: .timerCountdown)
          .font(.system(size: 2000))
          .fontWeight(.semibold)
          .minimumScaleFactor(0.01)
          .padding(.vertical)
          .frame(maxWidth: .infinity)
          .fontDesign(.monospaced)
          .geometryGroup()
          .contentTransition(.numericText())
      }
      .padding()
      .environment(\.contentTransitionAddsDrawingGroup, true)
      
      CircleGestureContainer(
        gestureActive: $gestureActive,
        ticks: $ticks,
        circleIncrement: $circleIncrement,
        textColor: .accentColor,
        coverColor: .defaultBackground
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .zIndex(5000)
    }
    .background(
      Color.defaultBackground
        .ignoresSafeArea()
    )
    .sensoryFeedback(.success, trigger: gestureActive) { _, newValue in
      newValue
    }
    .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 20) {
      gestureActive = true
    }
    .onChange(of: gestureActive) { _, newValue in
      if newValue == false {
        ticks = 0
      } else if newValue == true {
        timeDifference = timeRemaining
      }
    }
    .onChange(of: ticks) { _, newValue in
      ticksChanged(newValue)
    }
  }
  
  private func ticksChanged(_ newValue: Int) {
    guard gestureActive else { return }
    
    let changeTime = timeDifference + (newValue * circleIncrement.rawValue)
    
    guard changeTime >= 0 else { return }
    
    timeRemaining = changeTime
  }
}

#Preview {
  ContentView()
}
