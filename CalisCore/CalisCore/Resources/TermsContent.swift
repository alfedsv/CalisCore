//
//  TermsContent.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 18.09.2026.
//

import UIKit

/// Содержит тексты EULA и Политики конфиденциальности.
/// В реальном проекте их лучше вынести в отдельные .md или .txt файлы и загружать из бандла.
enum TermsContent {
    
    /// Загружает содержимое файла из бандла с учётом текущей локали.
    /// - Parameter fileName: Имя файла без расширения (например, "TermsOfService").
    /// - Returns: Текст документа или nil, если файл не найден.
    private static func loadMarkdown(named fileName: String) -> String? {
        // Bundle.main автоматически найдёт файл в нужной .lproj-папке по языку системы
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "md"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        return text
    }
    
    static var termsOfService: String {
        loadMarkdown(named: "TermsOfService") ?? "Terms of Service not found."
    }
    
    static var privacyPolicy: String {
        loadMarkdown(named: "PrivacyPolicy") ?? "Privacy Policy not found."
    }
    
    /// Формирует атрибутированный текст для отображения на экране согласия.
    static func combinedAttributedText() -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        let headerAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        let bodyAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.label
        ]
        
        // Локализованные заголовки — из String Catalog
        let termsHeader = NSLocalizedString("consent.legal.terms.header", comment: "Terms of Service header")
        let privacyHeader = NSLocalizedString("consent.legal.privacy.header", comment: "Privacy Policy header")
        
        result.append(NSAttributedString(string: termsHeader + "\n\n", attributes: headerAttrs))
        result.append(NSAttributedString(string: termsOfService + "\n\n\n", attributes: bodyAttrs))
        result.append(NSAttributedString(string: privacyHeader + "\n\n", attributes: headerAttrs))
        result.append(NSAttributedString(string: privacyPolicy, attributes: bodyAttrs))
        
        return result
    }
}
