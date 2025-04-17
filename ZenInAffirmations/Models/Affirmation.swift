import Foundation

// Affirmation model
struct Affirmation {
    let id: String
    let content: String
    let category: String
    var isFavorite: Bool = false
    var recordedAudioPath: String? = nil
    
    // Use for initialization with automatic ID generation
    init(content: String, category: String, isFavorite: Bool = false, recordedAudioPath: String? = nil) {
        // Use a consistent hash of the content as the ID
        // This ensures the same content always has the same ID
        let contentHash = abs(content.hashValue)
        self.id = "\(contentHash)_\(category)"
        self.content = content
        self.category = category
        self.isFavorite = isFavorite
        self.recordedAudioPath = recordedAudioPath
    }
    
    // Use for loading from database with existing ID
    init(id: String, content: String, category: String, isFavorite: Bool = false, recordedAudioPath: String? = nil) {
        self.id = id
        self.content = content
        self.category = category
        self.isFavorite = isFavorite
        self.recordedAudioPath = recordedAudioPath
    }
} 