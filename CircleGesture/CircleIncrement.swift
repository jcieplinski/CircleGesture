//
//  CircleIncrement.swift
//  CircleGesture
//
//  Created by Joe Cieplinski on 4/17/25.
//

import Foundation

enum CircleIncrement: Int, CaseIterable, Identifiable {
    case second = 1
    case minute = 60
    case hour = 3600
    
    var title: String {
        switch self {
        case .second:
            "seconds"
        case .minute:
            "minutes"
        case .hour:
            "hours"
        }
    }
    
    var id: String { title }
}
