//
//  String+Localization.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

// MARK: - Расширение для локализации строк
extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}
