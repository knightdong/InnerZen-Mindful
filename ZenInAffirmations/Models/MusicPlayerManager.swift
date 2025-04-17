import Foundation
import AVFoundation
import UIKit

class MusicPlayerManager: NSObject {
    static let shared = MusicPlayerManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var musicList: [String] = []
    private var currentIndex = 0
    private var isPlaying = false
    private var isMuted = false
    private var previousVolume: Float = 1.0
    
    // 保存当前音量
    var volume: Float {
        get { audioPlayer?.volume ?? 1.0 }
        set { audioPlayer?.volume = newValue }
    }
    
    // 当前播放的音乐名称
    var currentMusicName: String? {
        guard currentIndex >= 0 && currentIndex < musicList.count else { return nil }
        return musicList[currentIndex].components(separatedBy: ".").first
    }
    
    override init() {
        super.init()
        
        // 加载音乐列表
        loadMusicList()
        
        // 设置音频会话
        setupAudioSession()
        
        // 注册应用程序通知
        registerNotifications()
    }
    
    private func loadMusicList() {
        // 从资源根目录直接加载MP3文件
        if let resourcePath = Bundle.main.resourcePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                // 仅保留mp3文件
                musicList = files.filter { $0.hasSuffix(".mp3") }
                print("加载的音乐列表: \(musicList)")
            } catch {
                print("加载音乐列表失败: \(error.localizedDescription)")
                // 使用模拟数据作为后备
                useDummyMusicList()
            }
        } else {
            print("无法获取资源路径")
            useDummyMusicList()
        }
        
        // 如果没有找到音乐文件，使用模拟数据
        if musicList.isEmpty {
            useDummyMusicList()
        }
    }
    
    private func useDummyMusicList() {
        print("无法找到音乐文件，使用模拟数据")
        musicList = [
            "Relaxing Music.mp3",
            "Ocean Waves.mp3",
            "Meditation.mp3"
        ]
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("设置音频会话失败: \(error.localizedDescription)")
        }
    }
    
    private func registerNotifications() {
        // 监听应用进入背景
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        // 监听应用回到前台
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func handleAppDidEnterBackground() {
        // 应用进入后台时暂停播放
        if isPlaying {
            audioPlayer?.pause()
        }
    }
    
    @objc private func handleAppWillEnterForeground() {
        // 应用回到前台时恢复播放
        if isPlaying {
            audioPlayer?.play()
        }
    }
    
    // 播放指定索引的音乐
    func playMusic(at index: Int) {
        guard index >= 0 && index < musicList.count else { return }
        
        currentIndex = index
        let musicName = musicList[index]
        
        // 直接从资源根目录加载音频
        if let musicPath = Bundle.main.path(forResource: musicName.components(separatedBy: ".").first, ofType: "mp3") {
            let musicURL = URL(fileURLWithPath: musicPath)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                isPlaying = true
                
                // 发送状态变化通知
                NotificationCenter.default.post(name: NSNotification.Name("MusicStatusChanged"), object: nil)
                
                print("正在播放: \(musicName)")
            } catch {
                print("播放音乐失败: \(error.localizedDescription)")
                // 如果是模拟数据，播放失败时设置为静默播放
                if musicList.count <= 3 {
                    isPlaying = true
                    
                    // 发送状态变化通知
                    NotificationCenter.default.post(name: NSNotification.Name("MusicStatusChanged"), object: nil)
                    
                    print("使用静默播放模式")
                }
            }
        } else {
            print("未找到音乐文件: \(musicName)")
            // 如果是模拟数据，找不到文件时设置为静默播放
            if musicList.count <= 3 {
                isPlaying = true
                
                // 发送状态变化通知
                NotificationCenter.default.post(name: NSNotification.Name("MusicStatusChanged"), object: nil)
                
                print("使用静默播放模式")
            }
        }
    }
    
    // 播放下一首
    func playNext() {
        currentIndex = (currentIndex + 1) % musicList.count
        playMusic(at: currentIndex)
    }
    
    // 播放上一首
    func playPrevious() {
        currentIndex = (currentIndex - 1 + musicList.count) % musicList.count
        playMusic(at: currentIndex)
    }
    
    // 暂停播放
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        
        // 发送状态变化通知
        NotificationCenter.default.post(name: NSNotification.Name("MusicStatusChanged"), object: nil)
    }
    
    // 继续播放
    func resume() {
        audioPlayer?.play()
        isPlaying = true
        
        // 发送状态变化通知
        NotificationCenter.default.post(name: NSNotification.Name("MusicStatusChanged"), object: nil)
    }
    
    // 停止播放
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        
        // 发送状态变化通知
        NotificationCenter.default.post(name: NSNotification.Name("MusicStatusChanged"), object: nil)
    }
    
    // 切换播放/暂停状态
    func togglePlayPause() -> Bool {
        if isPlaying {
            pause()
            return false
        } else {
            if audioPlayer != nil {
                resume()
            } else if !musicList.isEmpty {
                playMusic(at: currentIndex)
            }
            return true
        }
    }
    
    // 切换静音状态
    func toggleMute() -> Bool {
        if isMuted {
            // 恢复音量
            audioPlayer?.volume = previousVolume
            isMuted = false
            return false
        } else {
            // 静音
            previousVolume = audioPlayer?.volume ?? 1.0
            audioPlayer?.volume = 0
            isMuted = true
            return true
        }
    }
    
    // 获取所有音乐名称（不带扩展名）
    func getAllMusicNames() -> [String] {
        return musicList.map { $0.components(separatedBy: ".").first ?? $0 }
    }
    
    // 根据名称播放音乐
    func playMusic(named name: String) {
        if let index = musicList.firstIndex(where: { $0.contains(name) }) {
            playMusic(at: index)
        }
    }
    
    // 是否正在播放
    func isCurrentlyPlaying() -> Bool {
        return isPlaying
    }
    
    // 获取当前播放状态
    func getPlayingStatus() -> (isPlaying: Bool, currentMusic: String?) {
        return (isPlaying, currentMusicName)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - AVAudioPlayerDelegate
extension MusicPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // 自动播放下一首
            playNext()
        }
    }
} 