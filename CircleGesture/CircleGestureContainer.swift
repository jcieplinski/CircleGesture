//
//  CircleGestureContainer.swift
//  CircleGesture
//
//  Created by Joe Cieplinski on 4/17/25.
//

import SwiftUI

struct CircleGestureContainer: View {
  
  @Binding var gestureActive: Bool
  @Binding var ticks: Int
  @Binding var circleIncrement: CircleIncrement
  
  let textColor: Color
  let coverColor: Color
  let animation = Animation.snappy(duration: 0.22, extraBounce: 0.4)
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(coverColor.opacity(0.3))
        .opacity(gestureActive ? 1.0 : 0.0)
        .onTapGesture {
          gestureActive = false
        }
      CircularGestureView(
        circleIncrement: $circleIncrement,
        ticks: $ticks,
        gestureActive: $gestureActive,
        textColor: textColor
      )
      .scaleEffect(
        gestureActive ? CGSize(width: 1.0, height: 1.0) :
          CGSize(width: 0.9, height: 0.9)
      )
      .opacity(gestureActive ? 1.0 : 0.0)
      .animation(animation, value: gestureActive)
      
      VStack {
        HStack {
          Spacer()
          
          Picker("", selection: $circleIncrement) {
            ForEach(CircleIncrement.allCases) { increment in
              Text(increment.title)
                .tag(increment)
            }
          }
          .pickerStyle(.menu)
        }
        
        Spacer()
      }
      .padding(.vertical)
      .padding(.top, 33)
      .opacity(gestureActive ? 1.0 : 0.0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  @Previewable @State var gestureActive: Bool = false
  @Previewable @State var ticks: Int = 0
  @Previewable @State var circleIncrement: CircleIncrement = .minute
  
  VStack {
    CircleGestureContainer(
      gestureActive: $gestureActive,
      ticks: $ticks,
      circleIncrement: $circleIncrement,
      textColor: Color.accentColor,
      coverColor: Color.defaultBackground
    )
  }
  .background(Color.defaultBackground)
  .onTapGesture {
    gestureActive = false
  }
  .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 20) {
    gestureActive = true
  } onPressingChanged: { _ in }
}
