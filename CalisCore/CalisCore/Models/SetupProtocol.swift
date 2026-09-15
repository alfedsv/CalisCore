//
//  SetupProtocol.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

protocol SetupProtocol {
    var localizedTitle: String { get }
    var activeBackgroundColor: String { get }
    var unactiveBackgroundColor: String { get }
    static var `default`: Self { get }
}
