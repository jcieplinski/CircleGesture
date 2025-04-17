//
//  CircularGestureView.swift
//  CircleGesture
//
//  Created by Joe Cieplinski on 4/17/25.
//

import SwiftUI

struct CircularGestureView: View {
  @Binding var circleIncrement: CircleIncrement
  @Binding var ticks: Int
  @Binding var gestureActive: Bool
  
  let textColor: Color
  
  @State private var timeValue: CGFloat = 0.0
  @State private var currentValue: CGFloat = 0.0
  @State private var accumulatedValue: CGFloat = 0.0
  @State private var rotations: Int = 0
  @State private var angleValue: CGFloat = 0.0
  @State private var radius: CGFloat = 0
  @State private var direction: CircleDirection = .none
  @State private var currentAdjustedX: CGFloat = 0.0
  @State private var currentAdjustedY: CGFloat = 0.0
  @State private var safeAreaInsets: EdgeInsets = .init()
  
  @GestureState private var gestureState: CGFloat = 0
  
  let config = CircleGestureConfiguration(
    minimumValue: 0.0,
    maximumValue: 60.0,
    totalValue: 60.0,
    knobRadius: 15.0
  )
  
  var body: some View {
    ZStack {
      Circle()
        .foregroundStyle(Color.clear)
        .frame(width: radius * 2, height: radius * 2)
        .scaleEffect(1.2)
      
      Circle()
        .stroke(textColor,
                style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
        .frame(width: radius * 2, height: radius * 2)
      
      Circle()
        .trim(from: 0.0, to: timeValue/config.totalValue)
        .stroke(
          ticks >= 0 ? Color.finBlue : Color.finOrange,
          lineWidth: 3
        )
        .frame(width: radius * 2, height: radius * 2)
        .rotationEffect(.degrees(-90))
      
      Circle()
        .fill(ticks >= 0 ? Color.finBlue : Color.finOrange)
        .frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
        .padding(10)
        .offset(y: -radius)
        .rotationEffect(Angle.degrees(Double(angleValue)))
        .simultaneousGesture(DragGesture(minimumDistance: 0.0)
          .updating($gestureState) { value, state, transaction in
            change(location: value.location)
          }
          .onEnded { value in
            withAnimation {
              gestureActive = false
            } completion: {
              reset()
            }
          }
        )
      
      Text(ticks * circleIncrement.rawValue, format: .timerCountdown)
        .font(.caption)
        .foregroundColor(.secondary)
        .offset(y: -radius - 40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.top, 20)
    .background(
      GeometryReader { geometry in
        Color.clear
          .task {
            setRadius(size: geometry.size)
          }
          .onChange(of: geometry.size) { _, _ in
            gestureActive = false
            setRadius(size: geometry.size)
          }
      }
    )
  }
  
  private func reset() {
    timeValue = 0
    currentValue = 0
    currentAdjustedX = 0
    currentAdjustedY = 0
    angleValue = 0
    accumulatedValue = 0
    rotations = 0
    direction = .none
    ticks = 0
  }
  
  private func setRadius(size: CGSize) {
    let diameter = min(size.width, size.height)
    radius = diameter / 2 - 20
  }
  
  private func change(location: CGPoint) {
    let vector = CGVector(dx: location.x, dy: location.y)
    
    var adjustedX = vector.dx - (config.knobRadius + 10)
    let adjustedY = vector.dy - (config.knobRadius + 10)
    
    if adjustedX > -(config.knobRadius) && adjustedX < config.knobRadius {
      adjustedX = 0.0
    }
    
    let angle = atan2(adjustedY, adjustedX) + .pi/2.0
    
    let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
    
    let value = fixedAngle / (2.0 * .pi) * config.totalValue
    
    let currentDirection = direction
    
    if floor(currentValue) == 0 && floor(value) == 59.0 {
      direction = .backward
    } else if floor(currentValue) == 59 && floor(value) == 0.0 {
      direction = .forward
    } else {
      direction = value >= currentValue ? .forward : .backward
    }
    
    if currentDirection == .none && direction == .backward {
      rotations -= 1
    } else if currentDirection == .none && direction == .forward {
      rotations = 0
    }
    
    if value >= config.minimumValue && value <= config.maximumValue {
      if currentAdjustedY < 0.0 {
        if currentAdjustedX < 0 && adjustedX >= 0 {
          rotations += 1
        }
        
        if currentAdjustedX >= 0 && adjustedX < 0 {
          rotations -= 1
        }
      }
      
      currentAdjustedX = adjustedX
      currentAdjustedY = adjustedY
      
      var rounded = floor(value)
      
      if rounded == 60 {
        rounded = 0
      }
      
      ticks = Int(rounded) + (Int(config.maximumValue) * rotations)
      
      timeValue = rounded
      currentValue = rounded
      let rotationValue = config.totalValue * CGFloat(rotations)
      accumulatedValue = timeValue + rotationValue
      angleValue = fixedAngle * 180 / .pi
    }
  }
}
