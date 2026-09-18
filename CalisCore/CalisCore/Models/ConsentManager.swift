//
//  ConsentManager.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 18.09.2026.
//

import Foundation

/// Менеджер для хранения и проверки факта согласия пользователя с EULA и Политикой конфиденциальности.
final class ConsentManager {
    
    static let shared = ConsentManager()
    
    /// Текущая версия документов. Меняем её при любом обновлении текста EULA или Политики —
    /// тогда пользователям будет показан экран согласия заново.
    static let currentTermsVersion = "1.0"
    
    private enum Keys {
        static let agreedVersion = "consent.agreedVersion"
        static let agreedDate    = "consent.agreedDate"
    }
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    /// Нужно ли показать экран согласия.
    var needsConsent: Bool {
        let savedVersion = defaults.string(forKey: Keys.agreedVersion)
        return savedVersion != Self.currentTermsVersion
    }
    
    /// Сохранить факт согласия с текущей версией документов.
    func saveConsent() {
        defaults.set(Self.currentTermsVersion, forKey: Keys.agreedVersion)
        defaults.set(Date(), forKey: Keys.agreedDate)
        
        // Для отладки — можно посмотреть в консоли
        if let date = defaults.object(forKey: Keys.agreedDate) as? Date {
            print("✅ Consent saved: version \(Self.currentTermsVersion), date \(date)")
        }
    }
    
    /// Дата согласия (если нужно показать пользователю или для логов).
    var consentDate: Date? {
        defaults.object(forKey: Keys.agreedDate) as? Date
    }
}
