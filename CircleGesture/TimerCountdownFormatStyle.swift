//
//  TimerCountdownFormatStyle.swift
//  CircleGesture
//
//  Created by Joe Cieplinski on 4/17/25.
//

import SwiftUI

struct TimerCountdownFormatStyle: FormatStyle {
    func format(_ value: Int) -> String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = value < 60 ?
        [.minute, .second] : [.hour, .minute, .second]
        
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = value < 60 ? .pad : .dropLeading
        
        return formatter.string(from: TimeInterval(value)) ?? ""
    }
}
