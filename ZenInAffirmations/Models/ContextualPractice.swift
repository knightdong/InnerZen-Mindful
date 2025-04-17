import Foundation

// 定义情境练习类型
enum PracticeContext: String, CaseIterable {
    case morningRoutine = "morning_routine"
    case commuting = "commuting"
    case workBreak = "work_break"
    case beforeMeeting = "before_meeting"
    case beforeInterview = "before_interview"
    case beforePresentation = "before_presentation"
    case beforeDate = "before_date"
    case afterConflict = "after_conflict"
    case beforeBedtime = "before_bedtime"
    case duringTravel = "during_travel"
    case waitingInLine = "waiting_in_line"
    case afterExercise = "after_exercise"
    case stressRelief = "stress_relief"
    
    var displayName: String {
        switch self {
        case .morningRoutine: return "Morning Routine"
        case .commuting: return "Commuting"
        case .workBreak: return "Work Break"
        case .beforeMeeting: return "Before Meeting"
        case .beforeInterview: return "Before Interview"
        case .beforePresentation: return "Before Presentation"
        case .beforeDate: return "Before Date"
        case .afterConflict: return "After Conflict"
        case .beforeBedtime: return "Before Bedtime"
        case .duringTravel: return "During Travel"
        case .waitingInLine: return "Waiting in Line"
        case .afterExercise: return "After Exercise"
        case .stressRelief: return "Stress Relief"
        }
    }
    
    // 返回场景图片URL
    var imageURL: String {
        switch self {
        case .morningRoutine: return "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?q=80&w=2068"
        case .commuting: return "https://images.unsplash.com/photo-1494515843206-f3117d3f51b7?q=80&w=1472"
        case .workBreak: return "https://images.unsplash.com/photo-1524901548305-08eeddc35080?q=80&w=2070"
        case .beforeMeeting: return "https://images.unsplash.com/photo-1600880292089-90a7e086ee0c?q=80&w=1974"
        case .beforeInterview: return "https://images.unsplash.com/photo-1573497620053-ea5300f94f21?q=80&w=2070"
        case .beforePresentation: return "https://images.unsplash.com/photo-1557426272-fc759fdf7a8d?q=80&w=2070"
        case .beforeDate: return "https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?q=80&w=1869"
        case .afterConflict: return "https://images.unsplash.com/photo-1529007196863-d07650a3f0ea?q=80&w=2070"
        case .beforeBedtime: return "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=2070"
        case .duringTravel: return "https://images.unsplash.com/photo-1502301197179-65228ab57f78?q=80&w=2070"
        case .waitingInLine: return "https://images.unsplash.com/photo-1513279922550-250c2129b13a?q=80&w=1770"
        case .afterExercise: return "https://images.unsplash.com/photo-1518611012118-696072aa579a?q=80&w=2070"
        case .stressRelief: return "https://images.unsplash.com/photo-1455849318743-b2233052fcff?q=80&w=2069"
        }
    }
    
    // 返回场景描述
    var description: String {
        switch self {
        case .morningRoutine: return "Start your day with mindfulness and intention"
        case .commuting: return "Transform travel time into peaceful moments"
        case .workBreak: return "Refresh your mind during short breaks"
        case .beforeMeeting: return "Center yourself before important discussions"
        case .beforeInterview: return "Calm nerves and boost confidence before interviews"
        case .beforePresentation: return "Find focus and clarity before presenting"
        case .beforeDate: return "Release anxiety and be present for connection"
        case .afterConflict: return "Restore inner peace after difficult interactions"
        case .beforeBedtime: return "Prepare mind and body for restful sleep"
        case .duringTravel: return "Stay grounded while navigating new environments"
        case .waitingInLine: return "Transform waiting time into mindful moments"
        case .afterExercise: return "Deepen the benefits of physical activity"
        case .stressRelief: return "Quick practices for moments of overwhelm"
        }
    }
    
    // 返回适合该场景的音乐类型提示
    var suggestedMusicType: String {
        switch self {
        case .morningRoutine: return "gentle_morning"
        case .commuting: return "ambient_focus"
        case .workBreak: return "light_refresh"
        case .beforeMeeting, .beforeInterview, .beforePresentation: return "calm_confidence" 
        case .beforeDate: return "light_positive"
        case .afterConflict: return "healing_calm"
        case .beforeBedtime: return "sleep_deep"
        case .duringTravel: return "world_ambient"
        case .waitingInLine: return "light_meditation"
        case .afterExercise: return "relaxing_restore"
        case .stressRelief: return "stress_relief"
        }
    }
}

// 情境练习模型
struct ContextualPractice {
    let id: String
    let context: PracticeContext
    let title: String
    let description: String
    let duration: Int // 以秒为单位
    let steps: [String]
    let breathingExercise: Bool // 是否包含呼吸练习
    let affirmations: [String] // 相关肯定语
    
    // 初始化方法
    init(id: String = UUID().uuidString, 
         context: PracticeContext, 
         title: String, 
         description: String, 
         duration: Int, 
         steps: [String], 
         breathingExercise: Bool = true, 
         affirmations: [String]) {
        self.id = id
        self.context = context
        self.title = title
        self.description = description
        self.duration = duration
        self.steps = steps
        self.breathingExercise = breathingExercise
        self.affirmations = affirmations
    }
}

// 情境练习数据管理器
class ContextualPracticeManager {
    static let shared = ContextualPracticeManager()
    
    // 所有情境练习
    private var practices: [ContextualPractice] = []
    
    private init() {
        loadPractices()
    }
    
    // 加载所有情境练习数据
    private func loadPractices() {
        practices = [
            // 晨间例行
            ContextualPractice(
                context: .morningRoutine,
                title: "Morning Intention Setting",
                description: "Start your day with clarity and purpose",
                duration: 300,
                steps: [
                    "Find a comfortable seated position",
                    "Take 3 deep breaths to awaken your body",
                    "Reflect on what you want to accomplish today",
                    "Set a positive intention for the day",
                    "Visualize yourself moving through the day with ease"
                ],
                affirmations: [
                    "I welcome this new day with gratitude and joy",
                    "I am prepared for whatever comes my way today",
                    "Today I choose peace over worry and love over fear"
                ]
            ),
            
            // 通勤
            ContextualPractice(
                context: .commuting,
                title: "Mindful Commuting",
                description: "Transform travel time into a peaceful experience",
                duration: 420,
                steps: [
                    "Notice your surroundings without judgment",
                    "Be aware of your body and any tension you're holding",
                    "Focus on your breath for 10 cycles",
                    "Let go of planning thoughts and return to the present",
                    "Find three things to appreciate in your environment"
                ],
                affirmations: [
                    "I am exactly where I need to be right now",
                    "This journey is part of my day, not separate from it",
                    "I move through space with awareness and calm"
                ]
            ),
            
            // 工作休息
            ContextualPractice(
                context: .workBreak,
                title: "2-Minute Reset",
                description: "Quick refresh for mental clarity",
                duration: 120,
                steps: [
                    "Close your eyes and roll your shoulders",
                    "Take 5 deep belly breaths",
                    "Scan your body for tension and release it",
                    "Imagine your mind clearing like a blue sky",
                    "Set an intention for your return to work"
                ],
                affirmations: [
                    "I give myself permission to rest and recharge",
                    "Each break increases my productivity and creativity",
                    "My mind works best when I allow it moments of stillness"
                ]
            ),
            
            // 会议前
            ContextualPractice(
                context: .beforeMeeting,
                title: "Pre-Meeting Centering",
                description: "Collect your thoughts and prepare yourself",
                duration: 180,
                steps: [
                    "Find a quiet space for 3 minutes",
                    "Close your eyes and breathe deeply",
                    "Release any anticipation or anxiety",
                    "Clarify what you want to contribute",
                    "Visualize a successful, collaborative interaction"
                ],
                affirmations: [
                    "I communicate with clarity and purpose",
                    "My contributions are valuable and appreciated",
                    "I listen deeply and respond thoughtfully"
                ]
            ),
            
            // 面试前
            ContextualPractice(
                context: .beforeInterview,
                title: "Interview Confidence Builder",
                description: "Calm nerves and access your best self",
                duration: 300,
                steps: [
                    "Find a private space to center yourself",
                    "Practice 4-7-8 breathing for 2 minutes",
                    "Recall your achievements and strengths",
                    "Adopt a power pose for 2 minutes",
                    "Visualize a successful, engaging conversation"
                ],
                breathingExercise: true,
                affirmations: [
                    "I am well-prepared and ready for this opportunity",
                    "I speak with confidence about my skills and experience",
                    "I am calm, focused, and present in this conversation"
                ]
            ),
            
            // 演讲前
            ContextualPractice(
                context: .beforePresentation,
                title: "Presenter's Calm",
                description: "Ground yourself before speaking",
                duration: 300,
                steps: [
                    "Find a quiet moment to be alone",
                    "Practice diaphragmatic breathing for 2 minutes",
                    "Gently stretch your neck and shoulders",
                    "Remind yourself of your expertise and preparation",
                    "Visualize connecting with your audience"
                ],
                breathingExercise: true,
                affirmations: [
                    "I share my knowledge with clarity and confidence",
                    "I am well-prepared and enjoy connecting with my audience",
                    "My presence is strong, my voice is clear, my message matters"
                ]
            ),
            
            // 约会前
            ContextualPractice(
                context: .beforeDate,
                title: "Pre-Date Presence",
                description: "Release anxiety and open to connection",
                duration: 240,
                steps: [
                    "Take 5 deep, calming breaths",
                    "Remind yourself that nervousness and excitement feel similar",
                    "Focus on curiosity rather than impression",
                    "Set an intention to be present and authentic",
                    "Visualize an enjoyable, genuine interaction"
                ],
                affirmations: [
                    "I am worthy of connection and affection",
                    "I bring my authentic self to every interaction",
                    "I am open to genuine connection and new possibilities"
                ]
            ),
            
            // 冲突后
            ContextualPractice(
                context: .afterConflict,
                title: "Emotional Reset",
                description: "Restore balance after difficult exchanges",
                duration: 360,
                steps: [
                    "Find a private space to process",
                    "Acknowledge your emotions without judgment",
                    "Practice 5 minutes of compassionate breathing",
                    "Extend understanding to yourself and the other person",
                    "Set an intention for moving forward"
                ],
                breathingExercise: true,
                affirmations: [
                    "I respond rather than react to challenging situations",
                    "I honor my feelings while choosing my actions wisely",
                    "Each interaction is an opportunity for growth and understanding"
                ]
            ),
            
            // 睡前
            ContextualPractice(
                context: .beforeBedtime,
                title: "Sleep Preparation",
                description: "Calm your mind for restful sleep",
                duration: 600,
                steps: [
                    "Dim the lights and find a comfortable position",
                    "Scan your body from head to toe, releasing tension",
                    "Practice 4-7-8 breathing for 3 minutes",
                    "Review three positive moments from your day",
                    "Let go of planning thoughts for tomorrow"
                ],
                breathingExercise: true,
                affirmations: [
                    "I release the day and welcome peaceful rest",
                    "My body knows how to restore itself through sleep",
                    "Tomorrow will take care of itself as I rest completely now"
                ]
            ),
            
            // 旅行中
            ContextualPractice(
                context: .duringTravel,
                title: "Traveler's Grounding",
                description: "Stay centered in unfamiliar places",
                duration: 300,
                steps: [
                    "Take a moment to observe your surroundings",
                    "Feel your feet on the ground, connecting to earth",
                    "Notice three things you can see, hear, and feel",
                    "Take 10 deep, centering breaths",
                    "Remind yourself that you carry your center with you"
                ],
                affirmations: [
                    "I am adaptable and at ease wherever I go",
                    "I bring peace and stability with me in all circumstances",
                    "I am open to new experiences while remaining grounded"
                ]
            ),
            
            // 排队等待
            ContextualPractice(
                context: .waitingInLine,
                title: "Waiting Mindfulness",
                description: "Transform waiting time into meditation",
                duration: 180,
                steps: [
                    "Notice your posture and adjust for comfort",
                    "Bring awareness to your breathing without changing it",
                    "Observe your thoughts without attachment",
                    "Practice subtle finger or toe movements mindfully",
                    "Find three interesting details in your environment"
                ],
                affirmations: [
                    "This moment of waiting is a gift of time to myself",
                    "I am patient and present in this moment",
                    "Waiting teaches me the value of slowing down"
                ]
            ),
            
            // 运动后
            ContextualPractice(
                context: .afterExercise,
                title: "Post-Workout Integration",
                description: "Deepen the benefits of your exercise",
                duration: 300,
                steps: [
                    "Find a comfortable position to be still",
                    "Breathe deeply and appreciate your body's efforts",
                    "Scan your body with gratitude for its capabilities",
                    "Notice how exercise has shifted your energy",
                    "Set an intention for how to carry this energy forward"
                ],
                affirmations: [
                    "I honor my body's strength and capabilities",
                    "With each breath, I integrate the benefits of movement",
                    "I am grateful for my health and committed to nurturing it"
                ]
            ),
            
            // 压力缓解
            ContextualPractice(
                context: .stressRelief,
                title: "Rapid Stress Reset",
                description: "Quick relief for overwhelming moments",
                duration: 180,
                steps: [
                    "Stop and acknowledge that you're feeling stressed",
                    "Take 5 very deep, slow breaths",
                    "Place one hand on your heart, one on your stomach",
                    "Name 3 things you can see, hear, and feel",
                    "Remind yourself: 'This is temporary, I am capable'"
                ],
                breathingExercise: true,
                affirmations: [
                    "I can handle this one step at a time",
                    "I am stronger than any temporary challenge",
                    "I choose calm amidst the storm"
                ]
            )
        ]
    }
    
    // 获取所有情境练习
    func getAllPractices() -> [ContextualPractice] {
        return practices
    }
    
    // 按场景获取练习
    func getPractices(for context: PracticeContext) -> [ContextualPractice] {
        return practices.filter { $0.context == context }
    }
    
    // 获取随机推荐的练习
    func getRandomPractices(count: Int = 5) -> [ContextualPractice] {
        return Array(practices.shuffled().prefix(count))
    }
    
    // 根据ID获取特定练习
    func getPractice(byId id: String) -> ContextualPractice? {
        return practices.first { $0.id == id }
    }
} 