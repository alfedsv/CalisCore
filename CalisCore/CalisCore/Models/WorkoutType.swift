//
//  WorkoutType.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 21.09.2026.
//

import Foundation

enum WorkoutType: String {
    
    case strength
    case endurance
    case explosivePower
    case circuit
    
    var localizedTitle: String {
        ("setupButton." + rawValue).localized
    }
    
    static var `default`: WorkoutType {
        .strength
    }
}
