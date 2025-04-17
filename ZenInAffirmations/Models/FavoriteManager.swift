import Foundation

class FavoriteManager {
    // Singleton pattern
    static let shared = FavoriteManager()
    
    // Store favorite affirmation IDs and recording paths
    private let defaults = UserDefaults.standard
    private let favoriteAffirmationsKey = "favoriteAffirmations"
    private let favoriteContentsKey = "favoriteContents" // New key for storing content
    private let recordedAffirmationsKey = "recordedAffirmationsDict"
    private let recordedContentsKey = "recordedContents" // New key for storing content
    
    // Private initializer
    private init() {
        // Clean up legacy UUID IDs on startup
        cleanupLegacyIDs()
        migrateToContentStorage()
        migrateToRelativePaths() // 添加相对路径迁移
    }
    
    // MARK: - Legacy ID Cleanup
    
    // Clean up old UUID format IDs that are no longer valid
    private func cleanupLegacyIDs() {
        // Check if cleanup has already been done
        if defaults.bool(forKey: "legacyIDsCleanedUp") {
            return
        }
        
        print("Cleaning up legacy UUID format IDs...")
        
        // Get current favorite IDs
        let favoriteIds = getFavoriteAffirmationIds()
        
        // Filter out UUID-formatted IDs (they contain hyphens)
        let validIds = favoriteIds.filter { !$0.contains("-") }
        
        // Save the filtered list back
        defaults.set(validIds, forKey: favoriteAffirmationsKey)
        
        // Get current recording paths
        let recordingDict = getRecordingPaths()
        
        // Filter out entries with UUID keys
        let validRecordings = recordingDict.filter { !$0.key.contains("-") }
        
        // Save the filtered recordings back
        defaults.set(validRecordings, forKey: recordedAffirmationsKey)
        
        // Mark cleanup as done
        defaults.set(true, forKey: "legacyIDsCleanedUp")
        defaults.synchronize()
        
        print("Cleanup complete. Removed \(favoriteIds.count - validIds.count) legacy favorite IDs and \(recordingDict.count - validRecordings.count) legacy recordings.")
    }
    
    // Migrate from ID-only storage to content storage
    private func migrateToContentStorage() {
        // Check if migration has already been done
        if defaults.bool(forKey: "contentMigrationDone") {
            return
        }
        
        print("Starting migration to content storage...")
        
        // Create empty dictionaries for content storage if they don't exist
        if defaults.dictionary(forKey: favoriteContentsKey) == nil {
            defaults.set([String: [String: String]](), forKey: favoriteContentsKey)
        }
        
        if defaults.dictionary(forKey: recordedContentsKey) == nil {
            defaults.set([String: [String: String]](), forKey: recordedContentsKey)
        }
        
        // Mark migration as done
        defaults.set(true, forKey: "contentMigrationDone")
        defaults.synchronize()
        
        print("Migration to content storage complete.")
    }
    
    // 迁移绝对路径到相对路径
    private func migrateToRelativePaths() {
        if defaults.bool(forKey: "pathMigrationDone") {
            return
        }
        
        print("开始迁移录音路径从绝对路径到相对路径...")
        
        let recordingDict = getRecordingPaths()
        var updatedDict = [String: String]()
        
        // 获取文档目录路径
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        for (id, path) in recordingDict {
            // 如果是绝对路径，转换为相对路径
            if path.hasPrefix("/var/") || path.hasPrefix("/private/var/") {
                if path.contains("/Documents/") {
                    // 提取Documents之后的部分作为相对路径
                    if let range = path.range(of: "/Documents/") {
                        let relativePath = String(path[range.upperBound...])
                        updatedDict[id] = relativePath
                        print("路径迁移: \(id)\n从: \(path)\n到: \(relativePath)")
                    } else {
                        // 无法转换，保留原路径
                        updatedDict[id] = path
                    }
                } else {
                    // 如果不包含Documents路径，保留原路径
                    updatedDict[id] = path
                }
            } else {
                // 已经是相对路径，保留
                updatedDict[id] = path
            }
        }
        
        // 保存更新后的字典
        defaults.set(updatedDict, forKey: recordedAffirmationsKey)
        defaults.set(true, forKey: "pathMigrationDone")
        defaults.synchronize()
        
        print("路径迁移完成。处理了 \(recordingDict.count) 个录音路径。")
    }
    
    // MARK: - Favorite Methods
    
    // Get all favorited affirmation IDs
    func getFavoriteAffirmationIds() -> [String] {
        return defaults.stringArray(forKey: favoriteAffirmationsKey) ?? []
    }
    
    // Check if an affirmation is favorited
    func isAffirmationFavorited(_ affirmationId: String) -> Bool {
        let favoriteIds = getFavoriteAffirmationIds()
        return favoriteIds.contains(affirmationId)
    }
    
    // Add an affirmation to favorites
    func addToFavorites(_ affirmationId: String, content: String? = nil, category: String? = nil) {
        var favoriteIds = getFavoriteAffirmationIds()
        
        // Add if not already in favorites
        if !favoriteIds.contains(affirmationId) {
            favoriteIds.append(affirmationId)
            defaults.set(favoriteIds, forKey: favoriteAffirmationsKey)
            
            // If content is provided, store it
            if let content = content, let category = category {
                var contentDict = getFavoriteContents()
                contentDict[affirmationId] = ["content": content, "category": category]
                defaults.set(contentDict, forKey: favoriteContentsKey)
            }
            
            defaults.synchronize() // Ensure data is written immediately
        }
    }
    
    // Remove an affirmation from favorites
    func removeFromFavorites(_ affirmationId: String) {
        var favoriteIds = getFavoriteAffirmationIds()
        
        // Remove if in favorites
        if let index = favoriteIds.firstIndex(of: affirmationId) {
            favoriteIds.remove(at: index)
            defaults.set(favoriteIds, forKey: favoriteAffirmationsKey)
            
            // Remove content data if it exists
            var contentDict = getFavoriteContents()
            contentDict.removeValue(forKey: affirmationId)
            defaults.set(contentDict, forKey: favoriteContentsKey)
            
            defaults.synchronize() // Ensure data is written immediately
        }
    }
    
    // Toggle favorite status
    func toggleFavorite(_ affirmationId: String, content: String? = nil, category: String? = nil) -> Bool {
        if isAffirmationFavorited(affirmationId) {
            removeFromFavorites(affirmationId)
            return false
        } else {
            addToFavorites(affirmationId, content: content, category: category)
            return true
        }
    }
    
    // Get all favorite contents as a dictionary
    func getFavoriteContents() -> [String: [String: String]] {
        return defaults.dictionary(forKey: favoriteContentsKey) as? [String: [String: String]] ?? [:]
    }
    
    // Get content for a specific favorite affirmation
    func getFavoriteContent(forAffirmationId id: String) -> (content: String, category: String)? {
        let contents = getFavoriteContents()
        if let contentInfo = contents[id], 
           let content = contentInfo["content"], 
           let category = contentInfo["category"] {
            return (content, category)
        }
        return nil
    }
    
    // MARK: - Recording Methods
    
    // 将绝对路径转换为相对路径
    private func convertToRelativePath(_ absolutePath: String) -> String {
        // 如果已经是相对路径，直接返回
        if !absolutePath.hasPrefix("/") {
            return absolutePath
        }
        
        // 获取文档目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        // 转换为相对路径
        if absolutePath.hasPrefix(documentsDirectory) {
            // 去除文档目录前缀
            let relativePath = String(absolutePath.dropFirst(documentsDirectory.count))
            // 移除开头的/字符（如果有）
            return relativePath.hasPrefix("/") ? String(relativePath.dropFirst()) : relativePath
        }
        
        return absolutePath
    }
    
    // 将相对路径转换为绝对路径
    private func convertToAbsolutePath(_ relativePath: String) -> String {
        // 如果已经是绝对路径，直接返回
        if relativePath.hasPrefix("/var/") || relativePath.hasPrefix("/private/var/") {
            return relativePath
        }
        
        // 获取文档目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        // 构建绝对路径
        let absolutePath = "\(documentsDirectory)/\(relativePath)"
        return absolutePath
    }
    
    // Associate a recording path with an affirmation ID
    func saveRecordingPath(_ path: String, forAffirmationId affirmationId: String, content: String? = nil, category: String? = nil) {
        // 确保文件存在
        if !FileManager.default.fileExists(atPath: path) {
            print("警告: 尝试保存不存在的录音文件路径: \(path)")
            return
        }
        
        // 将绝对路径转换为相对路径
        let relativePath = convertToRelativePath(path)
        
        var recordingDict = getRecordingPaths()
        recordingDict[affirmationId] = relativePath
        
        // Store as a dictionary directly (safer than JSON serialization)
        defaults.set(recordingDict, forKey: recordedAffirmationsKey)
        
        // If content is provided, store it
        if let content = content, let category = category {
            var contentDict = getRecordedContents()
            contentDict[affirmationId] = ["content": content, "category": category]
            defaults.set(contentDict, forKey: recordedContentsKey)
        }
        
        defaults.synchronize() // Ensure data is written immediately
        
        print("成功保存录音 - ID: \(affirmationId)")
        print("相对路径: \(relativePath)")
        print("绝对路径: \(path)")
        print("当前所有录音: \(recordingDict.count)个")
    }
    
    // Get recording path for an affirmation
    func getRecordingPath(forAffirmationId affirmationId: String) -> String? {
        let recordingDict = getRecordingPaths()
        guard let relativePath = recordingDict[affirmationId] else { return nil }
        
        // 将相对路径转换为绝对路径
        return convertToAbsolutePath(relativePath)
    }
    
    // Delete recording for an affirmation
    func removeRecordingPath(forAffirmationId affirmationId: String) {
        var recordingDict = getRecordingPaths()
        
        // 检查是否存在录音记录
        if let relativePath = recordingDict[affirmationId], let absolutePath = getRecordingPath(forAffirmationId: affirmationId) {
            print("移除录音记录 - ID: \(affirmationId)")
            print("相对路径: \(relativePath)")
            print("绝对路径: \(absolutePath)")
            
            // 尝试删除文件
            if FileManager.default.fileExists(atPath: absolutePath) {
                do {
                    try FileManager.default.removeItem(atPath: absolutePath)
                    print("已删除文件: \(absolutePath)")
                } catch {
                    print("删除文件失败: \(error.localizedDescription)")
                }
            } else {
                print("文件不存在，仅移除记录")
            }
        }
        
        recordingDict.removeValue(forKey: affirmationId)
        
        // Store as a dictionary directly
        defaults.set(recordingDict, forKey: recordedAffirmationsKey)
        
        // Remove content data if it exists
        var contentDict = getRecordedContents()
        contentDict.removeValue(forKey: affirmationId)
        defaults.set(contentDict, forKey: recordedContentsKey)
        
        defaults.synchronize() // Ensure data is written immediately
    }
    
    // Get all affirmation IDs and recording paths
    func getRecordingPaths() -> [String: String] {
        // Get directly as a dictionary rather than using JSON serialization
        if let dict = defaults.dictionary(forKey: recordedAffirmationsKey) as? [String: String] {
            return dict
        }
        return [:]
    }
    
    // Get all recorded contents as a dictionary
    func getRecordedContents() -> [String: [String: String]] {
        return defaults.dictionary(forKey: recordedContentsKey) as? [String: [String: String]] ?? [:]
    }
    
    // Get content for a specific recorded affirmation
    func getRecordedContent(forAffirmationId id: String) -> (content: String, category: String)? {
        let contents = getRecordedContents()
        if let contentInfo = contents[id], 
           let content = contentInfo["content"], 
           let category = contentInfo["category"] {
            return (content, category)
        }
        return nil
    }
    
    // Get all recorded affirmation IDs
    func getRecordedAffirmationIds() -> [String] {
        return Array(getRecordingPaths().keys)
    }
    
    // Check if an affirmation has a recording
    func hasRecording(forAffirmationId affirmationId: String) -> Bool {
        let recordingDict = getRecordingPaths()
        guard let relativePath = recordingDict[affirmationId] else { return false }
        
        // 转换为绝对路径并检查文件是否存在
        let absolutePath = convertToAbsolutePath(relativePath)
        return FileManager.default.fileExists(atPath: absolutePath)
    }
    
    // Debug: print all stored data
    func printStoredData() {
        print("=== FAVORITES MANAGER DEBUG ===")
        
        // 打印收藏信息
        let favoriteIds = getFavoriteAffirmationIds()
        print("Favorite IDs: \(favoriteIds)")
        
        // 打印录音信息
        let recordingPaths = getRecordingPaths()
        print("Recording IDs: \(Array(recordingPaths.keys))")
        print("Total recordings: \(recordingPaths.count)")
        
        if !recordingPaths.isEmpty {
            print("=== Recording paths details ===")
            for (id, relativePath) in recordingPaths {
                let absolutePath = convertToAbsolutePath(relativePath)
                print("ID: \(id), Path: \(absolutePath)")
                // 检查文件是否存在
                let fileExists = FileManager.default.fileExists(atPath: absolutePath)
                print("File exists: \(fileExists)")
                print("Relative path: \(relativePath)")
            }
        }
        
        // 打印录音内容
        let recordedContents = getRecordedContents()
        print("Recorded content entries: \(recordedContents.count)")
    }
    
    // Force cleanup of legacy IDs (for testing)
    func forceCleanupLegacyIDs() {
        defaults.set(false, forKey: "legacyIDsCleanedUp")
        cleanupLegacyIDs()
    }
    
    // 强制执行路径迁移（用于测试）
    func forceMigrateToRelativePaths() {
        defaults.set(false, forKey: "pathMigrationDone")
        migrateToRelativePaths()
    }
} 