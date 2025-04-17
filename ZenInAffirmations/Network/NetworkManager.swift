import Foundation
import Moya
import Alamofire
import SwiftyJSON

// 定义 API 请求类型
enum API {
    // GET请求
    case getQuotes(author: String?, keyword: String?)
    case getRandomQuote
    case getTodayQuote
    
    // POST请求
    case login(username: String, password: String)
    case saveUserRecord(recordData: [String: Any])
    case submitDiary(content: String, mood: String, date: Date)
}

// 实现 TargetType 协议
extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://zenquotes.io/api")!
    }
    
    var path: String {
        switch self {
        // GET请求路径
        case .getQuotes:
            return "/quotes"
        case .getRandomQuote:
            return "/random"
        case .getTodayQuote:
            return "/today"
            
        // POST请求路径
        case .login:
            return "/user/login"
        case .saveUserRecord:
            return "/user/record"
        case .submitDiary:
            return "/user/diary"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuotes, .getRandomQuote, .getTodayQuote:
            return .get
        case .login, .saveUserRecord, .submitDiary:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        // GET请求参数
        case .getQuotes(let author, let keyword):
            var parameters: [String: Any] = [:]
            if let author = author {
                parameters["author"] = author
            }
            if let keyword = keyword {
                parameters["keyword"] = keyword
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getRandomQuote, .getTodayQuote:
            return .requestPlain
            
        // POST请求参数
        case .login(let username, let password):
            let parameters = ["username": username, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .saveUserRecord(let recordData):
            return .requestParameters(parameters: recordData, encoding: JSONEncoding.default)
            
        case .submitDiary(let content, let mood, let date):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let parameters: [String: Any] = [
                "content": content,
                "mood": mood,
                "date": dateFormatter.string(from: date)
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-type": "application/json"]
        
        // 为需要认证的请求添加token
        switch self {
        case .saveUserRecord, .submitDiary:
            if let token = UserDefaults.standard.string(forKey: "userToken") {
                headers["Authorization"] = "Bearer \(token)"
            }
        default:
            break
        }
        
        return headers
    }
}

// 网络请求管理器
class NetworkManager {
    static let shared = NetworkManager()
    private let provider: MoyaProvider<API>
    
    private init() {
        // 配置网络请求
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        provider = MoyaProvider<API>(
            session: Session(configuration: configuration),
            plugins: [NetworkLoggerPlugin()]
        )
    }
    
    // 通用请求方法
    private func request<T: Codable>(_ target: API, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(T.self, from: response.data)
                    completion(.success(data))
                } catch {
                    // 如果解码失败，尝试使用SwiftyJSON解析
                    do {
                        let json = try JSON(data: response.data)
                        print("Response JSON: \(json)")
                        completion(.failure(NSError(domain: "NetworkError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "数据解析失败"])))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // GET请求方法
    // 获取语录列表
    func getQuotes(author: String? = nil, keyword: String? = nil, completion: @escaping (Result<[Quote], Error>) -> Void) {
        request(.getQuotes(author: author, keyword: keyword), completion: completion)
    }
    
    // 获取随机语录
    func getRandomQuote(completion: @escaping (Result<[Quote], Error>) -> Void) {
        request(.getRandomQuote, completion: completion)
    }
    
    // 获取今日语录
    func getTodayQuote(completion: @escaping (Result<[Quote], Error>) -> Void) {
        request(.getTodayQuote, completion: completion)
    }
    
    // POST请求方法
    // 用户登录
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        request(.login(username: username, password: password), completion: completion)
    }
    
    // 保存用户记录
    func saveUserRecord(recordData: [String: Any], completion: @escaping (Result<BaseResponse, Error>) -> Void) {
        request(.saveUserRecord(recordData: recordData), completion: completion)
    }
    
    // 提交情绪日记
    func submitDiary(content: String, mood: String, date: Date = Date(), completion: @escaping (Result<BaseResponse, Error>) -> Void) {
        request(.submitDiary(content: content, mood: mood, date: date), completion: completion)
    }
}

// 模型定义
// 语录模型
struct Quote: Codable {
    let q: String  // 语录内容
    let a: String  // 作者
    let h: String? // HTML格式
    let c: String? // 字符数
    
    enum CodingKeys: String, CodingKey {
        case q = "q"
        case a = "a"
        case h = "h"
        case c = "c"
    }
}

// 登录响应模型
struct LoginResponse: Codable {
    let token: String
    let user: User
}

// 用户模型
struct User: Codable {
    let id: Int
    let username: String
    let nickname: String?
}

// 基础响应模型
struct BaseResponse: Codable {
    let code: Int
    let message: String
    let success: Bool
} 