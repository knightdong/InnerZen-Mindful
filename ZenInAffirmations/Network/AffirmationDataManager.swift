import Foundation

// Data manager for affirmations
class AffirmationDataManager {
    static let shared = AffirmationDataManager()
    
    private var affirmations: [String: [String]] = [:]
    private var allAffirmations: [Affirmation] = []
    private let favoriteManager = FavoriteManager.shared
    
    private init() {
        loadAffirmationsFromJSON()
    }
    
    // Load affirmation data from local JSON file
    private func loadAffirmationsFromJSON() {
        print("Loading affirmation data...")
        
        // Try to load data file from multiple locations
        var jsonPath: String?
        
        // 1. Try loading from documents directory
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("affirmations.json")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                jsonPath = fileURL.path
                print("File found in documents directory: \(fileURL.path)")
            }
        }
        
        // 2. Try loading from app bundle
        if jsonPath == nil {
            if let bundlePath = Bundle.main.path(forResource: "affirmations", ofType: "json") {
                jsonPath = bundlePath
                print("File found in main bundle: \(bundlePath)")
            }
        }
        
        // 3. Try loading from Resources directory
        if jsonPath == nil {
            if let resourcePath = Bundle.main.path(forResource: "affirmations", ofType: "json", inDirectory: "Resources") {
                jsonPath = resourcePath
                print("File found in Resources directory: \(resourcePath)")
            }
        }
        
        // Create mock data if file not found
        guard let path = jsonPath else {
            print("⚠️ affirmations.json file not found")
            createMockDataIfNeeded()
            return
        }
        
        print("JSON file found: \(path)")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDict = jsonObject as? [String: Any] else {
                print("❌ Failed to parse JSON as dictionary")
                createMockDataIfNeeded()
                return
            }
            
            print("JSON structure: Dictionary type")
            
            // Parse affirmations for each category
            for category in AffirmationCategory.allCases {
                let categoryName = category.rawValue
                if let categoryArray = jsonDict[categoryName] as? [String] {
                    print("Category \(categoryName) has \(categoryArray.count) affirmations")
                    affirmations[categoryName] = categoryArray
                    
                    // Build complete affirmation array
                    for content in categoryArray {
                        // Create affirmation with content-based ID and set properties during initialization
                        let contentHash = abs(content.hashValue)
                        let id = "\(contentHash)_\(categoryName)"
                        let isFavorite = favoriteManager.isAffirmationFavorited(id)
                        let recordedAudioPath = favoriteManager.getRecordingPath(forAffirmationId: id)
                        
                        allAffirmations.append(Affirmation(
                            id: id,
                            content: content, 
                            category: categoryName, 
                            isFavorite: isFavorite, 
                            recordedAudioPath: recordedAudioPath
                        ))
                    }
                }
            }
            
            print("Successfully loaded affirmation data: \(allAffirmations.count) total")
        } catch {
            print("❌ Failed to parse affirmation data: \(error)")
            createMockDataIfNeeded()
        }
    }
    
    // Create mock data if JSON file not found
    private func createMockDataIfNeeded() {
        if allAffirmations.isEmpty {
            print("Creating mock data...")
            let mockData: [AffirmationCategory: [String]] = [
                .gratitude: ["Thank you for everything today", "Grateful for everyone in my life"],
                .love: ["Love is the most powerful force", "Living each day filled with love"],
                .success: ["I can succeed", "I believe in my abilities"]
            ]
            
            for (category, contents) in mockData {
                affirmations[category.rawValue] = contents
                for content in contents {
                    // Create affirmation with content-based ID and set properties during initialization
                    let contentHash = abs(content.hashValue)
                    let id = "\(contentHash)_\(category.rawValue)"
                    let isFavorite = favoriteManager.isAffirmationFavorited(id)
                    let recordedAudioPath = favoriteManager.getRecordingPath(forAffirmationId: id)
                    
                    allAffirmations.append(Affirmation(
                        id: id,
                        content: content, 
                        category: category.rawValue, 
                        isFavorite: isFavorite, 
                        recordedAudioPath: recordedAudioPath
                    ))
                }
            }
            print("Mock data created: \(allAffirmations.count) entries")
        }
    }
    
    // Get all affirmations for a specific category
    func getAffirmations(for category: AffirmationCategory) -> [Affirmation] {
        let categoryName = category.rawValue
        guard let categoryAffirmations = affirmations[categoryName] else {
            return []
        }
        
        return categoryAffirmations.map { content -> Affirmation in
            // Create affirmation with content-based ID and set properties during initialization
            let contentHash = abs(content.hashValue)
            let id = "\(contentHash)_\(categoryName)"
            let isFavorite = favoriteManager.isAffirmationFavorited(id)
            let recordedAudioPath = favoriteManager.getRecordingPath(forAffirmationId: id)
            
            return Affirmation(
                id: id,
                content: content, 
                category: categoryName, 
                isFavorite: isFavorite, 
                recordedAudioPath: recordedAudioPath
            )
        }
    }
    
    // Get a random affirmation
    func getRandomAffirmation() -> Affirmation? {
        guard !allAffirmations.isEmpty else { return nil }
        return allAffirmations.randomElement()
    }
    
    // Get a random affirmation for a specific category
    func getRandomAffirmation(for category: AffirmationCategory) -> Affirmation? {
        let categoryAffirmations = getAffirmations(for: category)
        guard !categoryAffirmations.isEmpty else { return nil }
        return categoryAffirmations.randomElement()
    }
    
    // Get today's affirmation (one fixed affirmation per day)
    func getTodayAffirmation() -> Affirmation? {
        guard !allAffirmations.isEmpty else { return nil }
        
        // Use current date as seed to select fixed affirmation
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.year, .month, .day], from: today)
        
        // Use year-month-day combination as seed
        guard let year = components.year, let month = components.month, let day = components.day else {
            return getRandomAffirmation()
        }
        
        let seed = year * 10000 + month * 100 + day
        let index = seed % allAffirmations.count
        
        return allAffirmations[index]
    }
    
    // Get all categories
    func getAllCategories() -> [AffirmationCategory] {
        return AffirmationCategory.allCases
    }
    
    // Search affirmations by keyword
    func searchAffirmations(keyword: String) -> [Affirmation] {
        guard !keyword.isEmpty else { return allAffirmations }
        
        return allAffirmations.filter { $0.content.localizedCaseInsensitiveContains(keyword) }
    }
    
    // MARK: - Favorite and Recording Methods
    
    // Toggle favorite status
    func toggleFavorite(for affirmation: Affirmation) -> Bool {
        let newStatus = favoriteManager.toggleFavorite(
            affirmation.id,
            content: affirmation.content,
            category: affirmation.category
        )
        return newStatus
    }
    
    // Check if an affirmation is favorited
    func isFavorite(for affirmation: Affirmation) -> Bool {
        return favoriteManager.isAffirmationFavorited(affirmation.id)
    }
    
    // Get all favorited affirmations
    func getFavoritedAffirmations() -> [Affirmation] {
        let favoriteIds = favoriteManager.getFavoriteAffirmationIds()
        print("Looking for favorite IDs: \(favoriteIds)")
        
        // First try to find matching affirmations in the loaded collection
        let foundAffirmations = allAffirmations.filter { favoriteIds.contains($0.id) }
        print("Found \(foundAffirmations.count) favorites in loaded affirmations")
        
        // If we couldn't find all favorited affirmations, create them from stored content
        if foundAffirmations.count < favoriteIds.count {
            var result = foundAffirmations
            
            // For each ID that wasn't found, try to reconstruct the affirmation
            for id in favoriteIds {
                // Skip IDs we already found
                if result.contains(where: { $0.id == id }) {
                    continue
                }
                
                // First try to get stored content
                if let contentInfo = favoriteManager.getFavoriteContent(forAffirmationId: id) {
                    let affirmation = Affirmation(
                        id: id,
                        content: contentInfo.content,
                        category: contentInfo.category,
                        isFavorite: true
                    )
                    result.append(affirmation)
                    print("Created favorite from stored content: \(contentInfo.content)")
                } else {
                    // Fall back to placeholder if no stored content (legacy data)
                    let components = id.split(separator: "_")
                    if components.count == 2, let categoryName = components.last {
                        let content = "Favorited affirmation from \(categoryName)"
                        let affirmation = Affirmation(
                            id: id,
                            content: content,
                            category: String(categoryName),
                            isFavorite: true
                        )
                        result.append(affirmation)
                        print("Created placeholder for favorited ID: \(id)")
                    }
                }
            }
            
            return result
        }
        
        return foundAffirmations
    }
    
    // Save recording for an affirmation
    func saveRecording(path: String, for affirmation: Affirmation) {
        favoriteManager.saveRecordingPath(
            path,
            forAffirmationId: affirmation.id,
            content: affirmation.content,
            category: affirmation.category
        )
    }
    
    // Get recording path for an affirmation
    func getRecordingPath(for affirmation: Affirmation) -> String? {
        return favoriteManager.getRecordingPath(forAffirmationId: affirmation.id)
    }
    
    // Check if an affirmation has a recording
    func hasRecording(for affirmation: Affirmation) -> Bool {
        return favoriteManager.hasRecording(forAffirmationId: affirmation.id)
    }
    
    // Get all affirmations with recordings
    func getRecordedAffirmations() -> [Affirmation] {
        let recordedIds = favoriteManager.getRecordedAffirmationIds()
        print("Looking for recorded IDs: \(recordedIds)")
        
        // 确保录音文件存在
        var validRecordedIds = [String]()
        for id in recordedIds {
            if favoriteManager.hasRecording(forAffirmationId: id) {
                validRecordedIds.append(id)
            } else {
                print("警告: 录音文件不存在或已删除 ID: \(id)")
            }
        }
        
        if recordedIds.count != validRecordedIds.count {
            print("注意: 有\(recordedIds.count - validRecordedIds.count)个录音记录无效，将被忽略")
        }
        
        // First try to find matching affirmations in the loaded collection
        let foundAffirmations = allAffirmations.filter { validRecordedIds.contains($0.id) }
        print("Found \(foundAffirmations.count) recordings in loaded affirmations")
        
        // If we couldn't find all recorded affirmations, create them from stored content
        if foundAffirmations.count < validRecordedIds.count {
            var result = foundAffirmations
            
            // For each ID that wasn't found, try to reconstruct the affirmation
            for id in validRecordedIds {
                // Skip IDs we already found
                if result.contains(where: { $0.id == id }) {
                    continue
                }
                
                let recordingPath = favoriteManager.getRecordingPath(forAffirmationId: id)
                
                // First try to get stored content
                if let contentInfo = favoriteManager.getRecordedContent(forAffirmationId: id) {
                    let affirmation = Affirmation(
                        id: id,
                        content: contentInfo.content,
                        category: contentInfo.category,
                        isFavorite: favoriteManager.isAffirmationFavorited(id),
                        recordedAudioPath: recordingPath
                    )
                    result.append(affirmation)
                    print("Created recording from stored content: \(contentInfo.content)")
                } else {
                    // Fall back to placeholder if no stored content (legacy data)
                    let components = id.split(separator: "_")
                    if components.count == 2, let categoryName = components.last {
                        let content = "Recorded affirmation from \(categoryName)"
                        let affirmation = Affirmation(
                            id: id,
                            content: content,
                            category: String(categoryName),
                            isFavorite: favoriteManager.isAffirmationFavorited(id),
                            recordedAudioPath: recordingPath
                        )
                        result.append(affirmation)
                        print("Created placeholder for recorded ID: \(id)")
                    }
                }
            }
            
            return result
        }
        
        return foundAffirmations
    }
    
    // Remove recording for an affirmation
    func removeRecording(for affirmation: Affirmation) {
        favoriteManager.removeRecordingPath(forAffirmationId: affirmation.id)
    }
} 