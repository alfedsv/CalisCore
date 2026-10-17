//
//  CharacterCarouselViewModel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.10.2026.
//


import Foundation

protocol CharacterCarouselViewModelProtocol: AnyObject {
    var characters: [Character] { get }
    var selectedIndex: Int { get }
    var onSelectedIndexChanged: ((Int) -> Void)? { get set }
    var onNext: ((Character) -> Void)? { get set }

    func selectCharacter(at index: Int)
    func next()
}

final class CharacterCarouselViewModel: CharacterCarouselViewModelProtocol {

    let characters: [Character]
    private(set) var selectedIndex: Int = 0

    var onSelectedIndexChanged: ((Int) -> Void)?
    var onNext: ((Character) -> Void)?

    init() {
        self.characters = [
            Character(id: "char1", name: "Lola",  idleScene: DataSource.idleLola, danceScene: DataSource.rumbaDancingLola),
            Character(id: "char2", name: "Adam",   idleScene: DataSource.idleAdam, danceScene: DataSource.rumbaDancingAdam),
            Character(id: "char3", name: "Sofie", idleScene: DataSource.idleSofie, danceScene: DataSource.rumbaDancingSofie),

        ]
    }

    func selectCharacter(at index: Int) {
        guard index >= 0, index < characters.count else { return }
        guard index != selectedIndex else { return }
        selectedIndex = index
        onSelectedIndexChanged?(index)
    }

    func next() {
        onNext?(characters[selectedIndex])
    }
}
