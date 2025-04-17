import UIKit

class MusicPlayerWindow: UIWindow {
    
    // 音乐播放器视图
    private var musicPlayerView: FloatingMusicPlayerView?
    
    // 初始化方法
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        // 设置窗口级别为高于普通窗口
        self.windowLevel = .normal + 1
        
        // 确保窗口可以接收触摸事件，但背景部分透明不接收事件
        self.backgroundColor = .clear
        
        // 添加音乐播放器视图
        setupMusicPlayerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置音乐播放器视图
    private func setupMusicPlayerView() {
        let musicPlayerSize: CGFloat = 50
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 初始位置：屏幕右侧中部，略高于Tabbar位置
        let initialFrame = CGRect(
            x: screenWidth - musicPlayerSize - 20,
            y: screenHeight * 0.1 - musicPlayerSize / 2,
            width: musicPlayerSize,
            height: musicPlayerSize
        )
        
        musicPlayerView = FloatingMusicPlayerView(frame: initialFrame)
        
        if let musicPlayerView = musicPlayerView {
            self.addSubview(musicPlayerView)
        }
    }
    
    // 重写此方法以确保仅接收音乐播放器视图的点击
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // 如果点击到的是音乐播放器或其子视图，则返回对应视图
        if hitView == musicPlayerView || (hitView?.isDescendant(of: musicPlayerView!) ?? false) {
            return hitView
        }
        
        // 其他区域不接收触摸
        return nil
    }
} 
