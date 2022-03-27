//
//  TranslateCountryCode.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//


/// Country codes from `https://cloud.google.com/translate/docs/languages`
enum TranslateCountryCode: String, CaseIterable {
    /// Czech
    case cz
    /// German
    case de
    /// English
    case en
    /// French
    case fr
    /// Hungarian
    case hu
    /// Italian
    case it
    /// Japanese
    case ja
    /// Korean
    case ko
    /// Macedonian
    case mk
    /// Russian
    case ru
    /// Slovene
    case sl
    /// Serbian
    case sr
    /// Hebrew
    case he
    /// Croatian
    case hr
    /// Chinese (Simplified)
    case zh
}

extension TranslateCountryCode: Identifiable {
    var id: String { self.rawValue }
}

extension TranslateCountryCode {
    
    var sloveneTranslate: String {
        switch self {
        case .cz:
            return "Češčina"
        case .de:
            return "Nemščina"
        case .en:
            return "Angleščina"
        case .fr:
            return "Francoščina"
        case .hu:
            return "Madžarščina"
        case .it:
            return "Italijanščina"
        case .ja:
            return "Japonščina"
        case .ko:
            return "Korejščina"
        case .mk:
            return "Makedonščina"
        case .ru:
            return "Ruščina"
        case .sl:
            return "Slovenščina"
        case .sr:
            return "Srbščina"
        case .he:
            return "Hebrejščina"
        case .hr:
            return "Hrvaščina"
        case .zh:
            return "Kitajščina (poenostavljena)"
        }
    }
}

