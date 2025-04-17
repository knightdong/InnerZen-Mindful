import UIKit
import Kingfisher

class ImageManager {
    static let shared = ImageManager()
    
    private let fileManager = FileManager.default
    private let localImagesDirectory: URL
    
    private init() {
        // 创建app专用的图片目录
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        localImagesDirectory = documentsDirectory.appendingPathComponent("LocalImages", isDirectory: true)
        
        // 确保目录存在
        do {
            try fileManager.createDirectory(at: localImagesDirectory, withIntermediateDirectories: true)
        } catch {
            print("创建本地图片目录失败: \(error)")
        }
    }
    
    // 下载图片并保存到本地
    func downloadImage(from urlString: String, fileName: String, completion: @escaping (Bool, URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        // 本地文件URL
        let localURL = localImagesDirectory.appendingPathComponent("\(fileName).jpg")
        
        // 检查文件是否已存在
        if fileManager.fileExists(atPath: localURL.path) {
            completion(true, localURL)
            return
        }
        
        // 使用Kingfisher下载图片
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                // 保存图片到本地
                if let data = value.image.jpegData(compressionQuality: 0.8) {
                    do {
                        try data.write(to: localURL)
                        print("图片已保存到: \(localURL.path)")
                        completion(true, localURL)
                    } catch {
                        print("保存图片失败: \(error)")
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
                
            case .failure(let error):
                print("下载图片失败: \(error)")
                completion(false, nil)
            }
        }
    }
    
    // 获取图片 - 先检查本地，不存在则从URL下载
    func getImage(urlString: String, fileName: String, completion: @escaping (UIImage?) -> Void) {
        // 检查本地是否有缓存
        let localURL = localImagesDirectory.appendingPathComponent("\(fileName).jpg")
        
        if fileManager.fileExists(atPath: localURL.path),
           let image = UIImage(contentsOfFile: localURL.path) {
            completion(image)
            return
        }
        
        // 本地没有，从URL下载
        downloadImage(from: urlString, fileName: fileName) { success, savedURL in
            if success, let savedURL = savedURL, 
               let image = UIImage(contentsOfFile: savedURL.path) {
                completion(image)
            } else if let url = URL(string: urlString) {
                // 下载失败，直接从URL加载一次
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        completion(value.image)
                    case .failure:
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    // 下载所有情境练习图片
    func downloadAllContextImages(completion: @escaping (Int, Int) -> Void) {
        let contexts = PracticeContext.allCases
        var successCount = 0
        let totalCount = contexts.count
        
        let group = DispatchGroup()
        
        for context in contexts {
            group.enter()
            
            downloadImage(from: context.imageURL, fileName: context.rawValue) { success, _ in
                if success {
                    successCount += 1
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(successCount, totalCount)
        }
    }
    
    // 清除所有本地图片
    func clearLocalImages() {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: localImagesDirectory, 
                                                         includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
            print("已清除所有本地图片")
        } catch {
            print("清除本地图片失败: \(error)")
        }
    }
} 