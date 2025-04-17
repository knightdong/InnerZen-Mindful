import Foundation
import UIKit

// 删除重复定义的MoodType枚举和CheckInRecord结构体

class CheckInManager {
    static let shared = CheckInManager()
    
    private let userDefaults = UserDefaults.standard
    private let checkInRecordsKey = "checkInRecords"
    private let achievementsKey = "achievements"
    
    private var checkInRecords: [CheckInRecord] = []
    private var achievements: [Achievement] = Achievement.allAchievements
    
    // 初始化
    private init() {
        loadData()
    }
    
    // 从UserDefaults加载数据
    private func loadData() {
        if let data = userDefaults.data(forKey: checkInRecordsKey),
           let records = try? JSONDecoder().decode([CheckInRecord].self, from: data) {
            checkInRecords = records
        }
        
        if let data = userDefaults.data(forKey: achievementsKey),
           let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = savedAchievements
        }
    }
    
    // 保存数据到UserDefaults
    private func saveData() {
        if let data = try? JSONEncoder().encode(checkInRecords) {
            userDefaults.set(data, forKey: checkInRecordsKey)
        }
        
        if let data = try? JSONEncoder().encode(achievements) {
            userDefaults.set(data, forKey: achievementsKey)
        }
    }
    
    // 添加打卡记录
    func addCheckInRecord(date: Date = Date(), 
                          note: String? = nil, 
                          affirmationIds: [String]? = nil, 
                          voiceRecordingPaths: [String]? = nil,
                          readCount: Int = 0,
                          recitedCount: Int = 0) -> CheckInRecord {
        
        // 检查是否已经存在同一天的记录
        if let existingRecordIndex = checkInRecords.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            // 更新现有记录
            var updatedRecord = checkInRecords[existingRecordIndex]
            if let note = note {
                updatedRecord.note = note
            }
            
            if let affirmationIds = affirmationIds {
                if updatedRecord.affirmationIds != nil {
                    updatedRecord.affirmationIds?.append(contentsOf: affirmationIds)
                } else {
                    updatedRecord.affirmationIds = affirmationIds
                }
            }
            
            if let voiceRecordingPaths = voiceRecordingPaths {
                if updatedRecord.voiceRecordingPaths != nil {
                    updatedRecord.voiceRecordingPaths?.append(contentsOf: voiceRecordingPaths)
                } else {
                    updatedRecord.voiceRecordingPaths = voiceRecordingPaths
                }
            }
            
            updatedRecord.readCount += readCount
            updatedRecord.recitedCount += recitedCount
            
            checkInRecords[existingRecordIndex] = updatedRecord
            saveData()
            checkAchievements()
            return updatedRecord
        } else {
            // 创建新记录
            let newRecord = CheckInRecord(
                date: date,
                note: note,
                affirmationIds: affirmationIds,
                voiceRecordingPaths: voiceRecordingPaths,
                readCount: readCount,
                recitedCount: recitedCount
            )
            
            checkInRecords.append(newRecord)
            saveData()
            checkAchievements()
            return newRecord
        }
    }
    
    // 获取所有打卡记录
    func getAllCheckInRecords() -> [CheckInRecord] {
        return checkInRecords.sorted { $0.date > $1.date }
    }
    
    // 获取指定日期的打卡记录
    func getCheckInRecord(for date: Date) -> CheckInRecord? {
        return checkInRecords.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    // 获取最长连续打卡天数
    func getLongestStreakDays() -> Int {
        guard !checkInRecords.isEmpty else { return 0 }
        
        let sortedRecords = checkInRecords.sorted { $0.date < $1.date }
        var longestStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedRecords.count {
            let prevDate = Calendar.current.startOfDay(for: sortedRecords[i-1].date)
            let currentDate = Calendar.current.startOfDay(for: sortedRecords[i].date)
            
            let dayDifference = Calendar.current.dateComponents([.day], from: prevDate, to: currentDate).day ?? 0
            
            if dayDifference == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            
            longestStreak = max(longestStreak, currentStreak)
        }
        
        // 还需要考虑当前连续打卡天数，它可能是最长的
        let currentStreakDays = getCurrentStreakDays()
        longestStreak = max(longestStreak, currentStreakDays)
        
        return longestStreak
    }
    
    // 获取当前连续打卡天数
    func getCurrentStreakDays() -> Int {
        guard !checkInRecords.isEmpty else { return 0 }
        
        let sortedRecords = checkInRecords.sorted { $0.date > $1.date }
        var currentStreak = 1
        
        let today = Calendar.current.startOfDay(for: Date())
        let mostRecentDate = Calendar.current.startOfDay(for: sortedRecords[0].date)
        
        // 检查最近的记录是否是今天或昨天
        let dayDifference = Calendar.current.dateComponents([.day], from: mostRecentDate, to: today).day ?? 0
        if dayDifference > 1 {
            return 0
        }
        
        for i in 1..<sortedRecords.count {
            let prevDate = Calendar.current.startOfDay(for: sortedRecords[i-1].date)
            let currentDate = Calendar.current.startOfDay(for: sortedRecords[i].date)
            
            let dayDifference = Calendar.current.dateComponents([.day], from: currentDate, to: prevDate).day ?? 0
            
            if dayDifference == 1 {
                currentStreak += 1
            } else {
                break
            }
        }
        
        return currentStreak
    }
    
    // 检查成就
    private func checkAchievements() {
        let currentStreak = getCurrentStreakDays()
        
        for i in 0..<achievements.count {
            if achievements[i].unlockDate == nil && currentStreak >= achievements[i].requiredDays {
                // 解锁成就
                achievements[i].unlockDate = Date()
            }
        }
        
        saveData()
    }
    
    // 获取所有成就
    func getAllAchievements() -> [Achievement] {
        return achievements
    }
    
    // 获取已解锁的成就
    func getUnlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.unlockDate != nil }
    }
    
    // 重置所有数据（测试用）
    func resetAllData() {
        checkInRecords = []
        achievements = Achievement.allAchievements
        saveData()
    }
    
    // 获取某月的打卡记录
    func getCheckInsForMonth(year: Int, month: Int) -> [CheckInRecord] {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        
        guard let startDate = calendar.date(from: components) else { return [] }
        
        components.month = month + 1
        components.day = 0
        guard let endDate = calendar.date(from: components) else { return [] }
        
        return checkInRecords.filter { record in
            let date = record.date
            return date >= startDate && date <= endDate
        }
    }
    
    // 检查某日是否已打卡
    func isDateCheckedIn(_ date: Date) -> Bool {
        return checkInRecords.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
} 