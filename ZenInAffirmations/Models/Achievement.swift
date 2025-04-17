import Foundation

// 定义Achievement结构体
struct Achievement: Codable {
    let id: String
    let name: String
    let description: String
    let requiredDays: Int
    var unlockDate: Date?
    
    static var allAchievements: [Achievement] {
        return [
            Achievement(id: "achievement_3days", name: "Beginner", description: "Check in for 3 consecutive days", requiredDays: 3, unlockDate: nil),
            Achievement(id: "achievement_7days", name: "One Week", description: "Check in for 7 consecutive days", requiredDays: 7, unlockDate: nil),
            Achievement(id: "achievement_14days", name: "Two Weeks", description: "Check in for 14 consecutive days", requiredDays: 14, unlockDate: nil),
            Achievement(id: "achievement_21days", name: "Habit Formed", description: "Check in for 21 consecutive days", requiredDays: 21, unlockDate: nil),
            Achievement(id: "achievement_30days", name: "One Month", description: "Check in for 30 consecutive days", requiredDays: 30, unlockDate: nil),
            Achievement(id: "achievement_60days", name: "Dedicated", description: "Check in for 60 consecutive days", requiredDays: 60, unlockDate: nil),
            Achievement(id: "achievement_100days", name: "Centurion", description: "Check in for 100 consecutive days", requiredDays: 100, unlockDate: nil),
            Achievement(id: "achievement_365days", name: "Year Long", description: "Check in for 365 consecutive days", requiredDays: 365, unlockDate: nil)
        ]
    }
} 