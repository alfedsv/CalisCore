//
//  Bundle+AppInfo.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.09.2026.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    var appBuild: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }
}
