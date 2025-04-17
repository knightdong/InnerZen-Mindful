import Foundation

class DailyActivityManager {
    static let shared = DailyActivityManager()
    
    private let userDefaults = UserDefaults.standard
    private let dailyReadCountKey = "dailyReadCount"
    private let dailyReciteCountKey = "dailyReciteCount"
    private let lastResetDateKey = "lastResetDate"
    private let historyStatsKey = "historyStats"
    
    private init() {
        checkAndResetDailyCounters()
    }
    
    // 检查并在需要时重置每日计数器
    func checkAndResetDailyCounters() {
        let calendar = Calendar.current
        
        // 获取上次重置的日期
        if let lastResetDateString = userDefaults.string(forKey: lastResetDateKey),
           let lastResetDate = dateFromString(lastResetDateString) {
            
            // 如果不是今天，则保存昨天的统计并重置计数器
            if !calendar.isDateInToday(lastResetDate) {
                // Save yesterday's data before resetting
                saveYesterdayStats(date: lastResetDate)
                resetDailyCounters()
                print("每日计数器已重置，昨日数据已保存")
            }
        } else {
            // 首次运行，设置今天的日期
            userDefaults.set(stringFromDate(Date()), forKey: lastResetDateKey)
            print("首次运行，设置重置日期")
        }
    }
    
    // 保存昨天的统计数据
    private func saveYesterdayStats(date: Date) {
        let readCount = userDefaults.integer(forKey: dailyReadCountKey)
        let reciteCount = userDefaults.integer(forKey: dailyReciteCountKey)
        
        // Only save if there was activity
        if readCount > 0 || reciteCount > 0 {
            // Get existing history
            var historyStats = getHistoryStats()
            
            // Create entry for yesterday
            let dateString = stringFromDate(date)
            historyStats[dateString] = [
                "readCount": readCount,
                "reciteCount": reciteCount
            ]
            
            // Save updated history
            if let encodedData = try? JSONEncoder().encode(historyStats) {
                userDefaults.set(encodedData, forKey: historyStatsKey)
                print("Saved history for \(dateString): Read \(readCount), Recite \(reciteCount)")
            }
            
            // Notify CheckInManager to update the record if needed
            updateCheckInRecord(for: date, readCount: readCount, reciteCount: reciteCount)
        }
    }
    
    // 更新CheckInRecord中的统计数据
    private func updateCheckInRecord(for date: Date, readCount: Int, reciteCount: Int) {
        let checkInManager = CheckInManager.shared
        
        if var record = checkInManager.getCheckInRecord(for: date) {
            // Update with final counts if they're higher than what's already recorded
            record.readCount = max(record.readCount, readCount)
            record.recitedCount = max(record.recitedCount, reciteCount)
            
            // Save the updated record
            checkInManager.addCheckInRecord(date: record.date, note: record.note, affirmationIds: record.affirmationIds, voiceRecordingPaths: record.voiceRecordingPaths, readCount: record.readCount, recitedCount: record.recitedCount)
            print("Updated check-in record for \(stringFromDate(date)) with Read: \(record.readCount), Recite: \(record.recitedCount)")
        } else if readCount > 0 || reciteCount > 0 {
            // Create a new record if there was activity but no check-in
            let newRecord = CheckInRecord(
                date: date,
                note: nil,
                affirmationIds: nil,
                voiceRecordingPaths: nil,
                readCount: readCount,
                recitedCount: reciteCount
            )
            
            // Save the new record
            checkInManager.addCheckInRecord(date: newRecord.date, note: newRecord.note, affirmationIds: newRecord.affirmationIds, voiceRecordingPaths: newRecord.voiceRecordingPaths, readCount: newRecord.readCount, recitedCount: newRecord.recitedCount)
            print("Created check-in record for \(stringFromDate(date)) with Read: \(readCount), Recite: \(reciteCount)")
        }
    }
    
    // 重置每日计数器
    private func resetDailyCounters() {
        userDefaults.set(0, forKey: dailyReadCountKey)
        userDefaults.set(0, forKey: dailyReciteCountKey)
        userDefaults.set(stringFromDate(Date()), forKey: lastResetDateKey)
    }
    
    // 获取当天已读数量
    func getDailyReadCount() -> Int {
        checkAndResetDailyCounters()
        return userDefaults.integer(forKey: dailyReadCountKey)
    }
    
    // 获取当天已录音数量
    func getDailyReciteCount() -> Int {
        checkAndResetDailyCounters()
        return userDefaults.integer(forKey: dailyReciteCountKey)
    }
    
    // 增加已读数量
    func incrementReadCount() {
        checkAndResetDailyCounters()
        let currentCount = userDefaults.integer(forKey: dailyReadCountKey)
        userDefaults.set(currentCount + 1, forKey: dailyReadCountKey)
        print("已读数量增加到: \(currentCount + 1)")
    }
    
    // 增加已录音数量
    func incrementReciteCount() {
        checkAndResetDailyCounters()
        let currentCount = userDefaults.integer(forKey: dailyReciteCountKey)
        userDefaults.set(currentCount + 1, forKey: dailyReciteCountKey)
        print("录音数量增加到: \(currentCount + 1)")
    }
    
    // 获取历史统计数据
    func getHistoryStats() -> [String: [String: Int]] {
        guard let data = userDefaults.data(forKey: historyStatsKey),
              let historyStats = try? JSONDecoder().decode([String: [String: Int]].self, from: data) else {
            return [:]
        }
        return historyStats
    }
    
    // 获取特定日期的历史统计数据
    func getHistoryStats(for date: Date) -> (readCount: Int, reciteCount: Int)? {
        let dateString = stringFromDate(date)
        let historyStats = getHistoryStats()
        
        if let stats = historyStats[dateString] {
            let readCount = stats["readCount"] ?? 0
            let reciteCount = stats["reciteCount"] ?? 0
            return (readCount, reciteCount)
        }
        
        return nil
    }
    
    // 将日期转换为字符串
    private func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // 将字符串转换为日期
    private func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
} 