import Foundation

// 打卡记录模型
struct CheckInRecord: Codable {
    var date: Date
    var note: String?
    var affirmationIds: [String]? // 关联的语录ID
    var voiceRecordingPaths: [String]? // 语音录制文件路径
    var readCount: Int // 阅读语录数量
    var recitedCount: Int // 朗读语录数量
    
    init(date: Date, note: String? = nil, affirmationIds: [String]? = nil, voiceRecordingPaths: [String]? = nil, readCount: Int = 0, recitedCount: Int = 0) {
        self.date = date
        self.note = note
        self.affirmationIds = affirmationIds
        self.voiceRecordingPaths = voiceRecordingPaths
        self.readCount = readCount
        self.recitedCount = recitedCount
    }
} 
