//
//  CurrentState.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

enum CurrentState {
    case running     // в ходе выполнения
    case begin              // в начале
    case ended              // закончено
    case stopped            // приостановлено
}
