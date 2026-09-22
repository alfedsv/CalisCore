//
//  Int+RandomTriangular.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 21.09.2026.
//

import Foundation

// MARK: - Расширение для треугольного распределения
extension Int {
    static func randomTriangular(min: Int, max: Int, mode: Int) -> Int {
        let u = Double.random(in: 0...1)
        let minD = Double(min), maxD = Double(max), modeD = Double(mode)
        let f = (modeD - minD) / (maxD - minD)
        if u < f {
            return Int(minD + sqrt(u * (maxD - minD) * (modeD - minD)))
        } else {
            return Int(maxD - sqrt((1 - u) * (maxD - minD) * (maxD - modeD)))
        }
    }
}
