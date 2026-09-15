//
//  FinishViewModel.swift
//  ExtractSport
//
//  Created by  Alexander Fedoseev on 25.08.2026.
//

import Foundation


protocol FinishViewModelProtocol: AnyObject {
    var win: String { get }
    func toMain()
    var onToMain: (() -> Void)? { get set }
}

final class FinishViewModel: FinishViewModelProtocol {
    
    var win: String
    var onToMain: (() -> Void)?

    init() {
        self.win = ("finish.win" + String(Int.random(in: 0...8))).localized
    }
    
    func toMain() {
        onToMain?()
    }
}
