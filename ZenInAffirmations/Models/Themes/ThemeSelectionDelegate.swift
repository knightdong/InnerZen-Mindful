import Foundation

// Protocol for theme selection delegate
protocol ThemeSelectionDelegate: AnyObject {
    func didSelectTheme(_ theme: ThemeType)
} 