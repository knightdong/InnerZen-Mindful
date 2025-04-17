import Foundation

// Affirmation category enum
enum AffirmationCategory: String, CaseIterable {
    case blessing = "blessing"
    case beauty = "beauty"
    case sleep = "sleep"
    case gratitude = "gratitude"
    case spiritual = "spiritual"
    case love = "love"
    case money = "money"
    case happiness = "happiness"
    case health = "health"
    case success = "success"
    case courage = "courage"
    case confidence = "confidence"
    case peace = "peace"
    case wisdom = "wisdom"
    case creativity = "creativity"
    case relationships = "relationships"
    case forgiveness = "forgiveness"
    case abundance = "abundance"
    case resilience = "resilience"
    case mindfulness = "mindfulness"
    
    var displayName: String {
        switch self {
        case .blessing: return "Blessing"
        case .beauty: return "Beauty"
        case .sleep: return "Sleep"
        case .gratitude: return "Gratitude"
        case .spiritual: return "Spiritual"
        case .love: return "Love"
        case .money: return "Money"
        case .happiness: return "Happiness"
        case .health: return "Health"
        case .success: return "Success"
        case .courage: return "Courage"
        case .confidence: return "Confidence"
        case .peace: return "Peace"
        case .wisdom: return "Wisdom"
        case .creativity: return "Creativity"
        case .relationships: return "Relationships"
        case .forgiveness: return "Forgiveness"
        case .abundance: return "Abundance"
        case .resilience: return "Resilience"
        case .mindfulness: return "Mindfulness"
        }
    }
} 