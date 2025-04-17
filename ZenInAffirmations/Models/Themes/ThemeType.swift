import UIKit

// Theme type enum
enum ThemeType: String, CaseIterable {
    // Theme types - Color gradients
    // Gradient variations
    case sunset = "sunset"
    case ocean = "ocean"
    case forest = "forest"
    case lavender = "lavender"
    case cherry = "cherry"
    case aurora = "aurora"
    case fire = "fire"
    case galaxy = "galaxy"
    case rainbow = "rainbow"
    
    // Additional scenes
    case dawn = "dawn"
    case dusk = "dusk"
    case desert = "desert"
    case polar = "polar"
    case rainforest = "rainforest"
    case cityNight = "cityNight"
    case auroraNight = "auroraNight"
    
    // Image background themes
    case wallpaper0 = "wallpaper0"
    case wallpaper1 = "wallpaper1"
    case wallpaper2 = "wallpaper2" 
    case wallpaper3 = "wallpaper3"
    case wallpaper4 = "wallpaper4"
    case wallpaper5 = "wallpaper5"
    case wallpaper6 = "wallpaper6"
    case wallpaper7 = "wallpaper7"
    case wallpaper8 = "wallpaper8"
    case wallpaper9 = "wallpaper9"
    case wallpaper10 = "wallpaper10"
    case wallpaper11 = "wallpaper11"
    case wallpaper12 = "wallpaper12"
    case wallpaper13 = "wallpaper13"
    case wallpaper14 = "wallpaper14"
    case wallpaper15 = "wallpaper15"
    case wallpaper16 = "wallpaper16"
    case wallpaper17 = "wallpaper17"
    case wallpaper18 = "wallpaper18"
    case wallpaper19 = "wallpaper19"
    case wallpaper20 = "wallpaper20"
    case wallpaper21 = "wallpaper21"
    case wallpaper22 = "wallpaper22"
    case wallpaper23 = "wallpaper23"
    case wallpaper24 = "wallpaper24"
    case wallpaper25 = "wallpaper25"
    case wallpaper26 = "wallpaper26"
    case wallpaper27 = "wallpaper27"
    case wallpaper28 = "wallpaper28"
    case wallpaper29 = "wallpaper29"
    case wallpaper30 = "wallpaper30"
    case wallpaper31 = "wallpaper31"
    case wallpaper32 = "wallpaper32"
    case wallpaper33 = "wallpaper33"
    case wallpaper34 = "wallpaper34"
    case wallpaper35 = "wallpaper35"
    case wallpaper36 = "wallpaper36"
    case wallpaper37 = "wallpaper37"
    case wallpaper38 = "wallpaper38"
    case wallpaper39 = "wallpaper39"
    case wallpaper40 = "wallpaper40"
    case wallpaper41 = "wallpaper41"
    case wallpaper42 = "wallpaper42"
    case wallpaper43 = "wallpaper43"
    case wallpaper44 = "wallpaper44"
    case wallpaper45 = "wallpaper45"
    case wallpaper46 = "wallpaper46"
    case wallpaper47 = "wallpaper47"
    case wallpaper48 = "wallpaper48"
    case wallpaper49 = "wallpaper49"
    case wallpaper50 = "wallpaper50"
    case wallpaper51 = "wallpaper51"
    case wallpaper52 = "wallpaper52"
    case wallpaper53 = "wallpaper53"
    case wallpaper54 = "wallpaper54"
    case wallpaper55 = "wallpaper55"
    case wallpaper56 = "wallpaper56"
    case wallpaper57 = "wallpaper57"
    case wallpaper58 = "wallpaper58"
    case wallpaper59 = "wallpaper59"
    case wallpaper60 = "wallpaper60"
    case wallpaper61 = "wallpaper61"
    case wallpaper62 = "wallpaper62"
    case wallpaper63 = "wallpaper63"
    case wallpaper64 = "wallpaper64"
    case wallpaper65 = "wallpaper65"
    
    var displayName: String {
        switch self {
        case .sunset: return "Sunset"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        case .lavender: return "Lavender"
        case .cherry: return "Cherry"
        case .aurora: return "Aurora"
        case .fire: return "Fire"
        case .galaxy: return "Galaxy"
        case .rainbow: return "Rainbow"
        case .dawn: return "Dawn"
        case .dusk: return "Dusk"
        case .desert: return "Desert"
        case .polar: return "Polar"
        case .rainforest: return "Rainforest"
        case .cityNight: return "City Night"
        case .auroraNight: return "Aurora Night"
        case .wallpaper0: return "Wallpaper 1"
        case .wallpaper1: return "Wallpaper 2"
        case .wallpaper2: return "Wallpaper 3"
        case .wallpaper3: return "Wallpaper 4"
        case .wallpaper4: return "Wallpaper 5"
        case .wallpaper5: return "Wallpaper 6"
        case .wallpaper6: return "Wallpaper 7"
        case .wallpaper7: return "Wallpaper 8"
        case .wallpaper8: return "Wallpaper 9"
        case .wallpaper9: return "Wallpaper 10"
        case .wallpaper10: return "Wallpaper 11"
        case .wallpaper11: return "Wallpaper 12"
        case .wallpaper12: return "Wallpaper 13"
        case .wallpaper13: return "Wallpaper 14"
        case .wallpaper14: return "Wallpaper 15"
        case .wallpaper15: return "Wallpaper 16"
        case .wallpaper16: return "Wallpaper 17"
        case .wallpaper17: return "Wallpaper 18"
        case .wallpaper18: return "Wallpaper 19"
        case .wallpaper19: return "Wallpaper 20"
        case .wallpaper20: return "Wallpaper 21"
        case .wallpaper21: return "Wallpaper 22"
        case .wallpaper22: return "Wallpaper 23"
        case .wallpaper23: return "Wallpaper 24"
        case .wallpaper24: return "Wallpaper 25"
        case .wallpaper25: return "Wallpaper 26"
        case .wallpaper26: return "Wallpaper 27"
        case .wallpaper27: return "Wallpaper 28"
        case .wallpaper28: return "Wallpaper 29"
        case .wallpaper29: return "Wallpaper 30"
        case .wallpaper30: return "Wallpaper 31"
        case .wallpaper31: return "Wallpaper 32"
        case .wallpaper32: return "Wallpaper 33"
        case .wallpaper33: return "Wallpaper 34"
        case .wallpaper34: return "Wallpaper 35"
        case .wallpaper35: return "Wallpaper 36"
        case .wallpaper36: return "Wallpaper 37"
        case .wallpaper37: return "Wallpaper 38"
        case .wallpaper38: return "Wallpaper 39"
        case .wallpaper39: return "Wallpaper 40"
        case .wallpaper40: return "Wallpaper 41"
        case .wallpaper41: return "Wallpaper 42"
        case .wallpaper42: return "Wallpaper 43"
        case .wallpaper43: return "Wallpaper 44"
        case .wallpaper44: return "Wallpaper 45"
        case .wallpaper45: return "Wallpaper 46"
        case .wallpaper46: return "Wallpaper 47"
        case .wallpaper47: return "Wallpaper 48"
        case .wallpaper48: return "Wallpaper 49"
        case .wallpaper49: return "Wallpaper 50"
        case .wallpaper50: return "Wallpaper 51"
        case .wallpaper51: return "Wallpaper 52"
        case .wallpaper52: return "Wallpaper 53"
        case .wallpaper53: return "Wallpaper 54"
        case .wallpaper54: return "Wallpaper 55"
        case .wallpaper55: return "Wallpaper 56"
        case .wallpaper56: return "Wallpaper 57"
        case .wallpaper57: return "Wallpaper 58"
        case .wallpaper58: return "Wallpaper 59"
        case .wallpaper59: return "Wallpaper 60"
        case .wallpaper60: return "Wallpaper 61"
        case .wallpaper61: return "Wallpaper 62"
        case .wallpaper62: return "Wallpaper 63"
        case .wallpaper63: return "Wallpaper 64"
        case .wallpaper64: return "Wallpaper 65"
        case .wallpaper65: return "Wallpaper 66"
        }
    }
    
    var imageName: String? {
        switch self {
        case .wallpaper0: return "zen_wall0"
        case .wallpaper1: return "zen_wall1"
        case .wallpaper2: return "zen_wall2"
        case .wallpaper3: return "zen_wall3"
        case .wallpaper4: return "zen_wall4"
        case .wallpaper5: return "zen_wall5"
        case .wallpaper6: return "zen_wall6"
        case .wallpaper7: return "zen_wall7"
        case .wallpaper8: return "zen_wall8"
        case .wallpaper9: return "zen_wall9"
        case .wallpaper10: return "zen_wall10"
        case .wallpaper11: return "zen_wall11"
        case .wallpaper12: return "zen_wall12"
        case .wallpaper13: return "zen_wall13"
        case .wallpaper14: return "zen_wall14"
        case .wallpaper15: return "zen_wall15"
        case .wallpaper16: return "zen_wall16"
        case .wallpaper17: return "zen_wall17"
        case .wallpaper18: return "zen_wall18"
        case .wallpaper19: return "zen_wall19"
        case .wallpaper20: return "zen_wall20"
        case .wallpaper21: return "zen_wall21"
        case .wallpaper22: return "zen_wall22"
        case .wallpaper23: return "zen_wall23"
        case .wallpaper24: return "zen_wall24"
        case .wallpaper25: return "zen_wall25"
        case .wallpaper26: return "zen_wall26"
        case .wallpaper27: return "zen_wall27"
        case .wallpaper28: return "zen_wall28"
        case .wallpaper29: return "zen_wall29"
        case .wallpaper30: return "zen_wall30"
        case .wallpaper31: return "zen_wall31"
        case .wallpaper32: return "zen_wall32"
        case .wallpaper33: return "zen_wall33"
        case .wallpaper34: return "zen_wall34"
        case .wallpaper35: return "zen_wall35"
        case .wallpaper36: return "zen_wall36"
        case .wallpaper37: return "zen_wall37"
        case .wallpaper38: return "zen_wall38"
        case .wallpaper39: return "zen_wall39"
        case .wallpaper40: return "zen_wall40"
        case .wallpaper41: return "zen_wall41"
        case .wallpaper42: return "zen_wall42"
        case .wallpaper43: return "zen_wall43"
        case .wallpaper44: return "zen_wall44"
        case .wallpaper45: return "zen_wall45"
        case .wallpaper46: return "zen_wall46"
        case .wallpaper47: return "zen_wall47"
        case .wallpaper48: return "zen_wall48"
        case .wallpaper49: return "zen_wall49"
        case .wallpaper50: return "zen_wall50"
        case .wallpaper51: return "zen_wall51"
        case .wallpaper52: return "zen_wall52"
        case .wallpaper53: return "zen_wall53"
        case .wallpaper54: return "zen_wall54"
        case .wallpaper55: return "zen_wall55"
        case .wallpaper56: return "zen_wall56"
        case .wallpaper57: return "zen_wall57"
        case .wallpaper58: return "zen_wall58"
        case .wallpaper59: return "zen_wall59"
        case .wallpaper60: return "zen_wall60"
        case .wallpaper61: return "zen_wall61"
        case .wallpaper62: return "zen_wall62"
        case .wallpaper63: return "zen_wall63"
        case .wallpaper64: return "zen_wall64"
        case .wallpaper65: return "zen_wall65"
        default: return nil
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .sunset: return UIColor(red: 0.95, green: 0.55, blue: 0.3, alpha: 1.0)
        case .ocean: return UIColor(red: 0.0, green: 0.5, blue: 0.8, alpha: 1.0)
        case .forest: return UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 1.0)
        case .lavender: return UIColor(red: 0.7, green: 0.6, blue: 0.9, alpha: 1.0)
        case .cherry: return UIColor(red: 0.95, green: 0.5, blue: 0.6, alpha: 1.0)
        case .aurora: return UIColor(red: 0.1, green: 0.8, blue: 0.7, alpha: 1.0)
        case .fire: return UIColor(red: 0.9, green: 0.3, blue: 0.1, alpha: 1.0)
        case .galaxy: return UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        case .rainbow: return UIColor(red: 0.8, green: 0.3, blue: 0.7, alpha: 1.0)
        case .dawn: return UIColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0)
        case .dusk: return UIColor(red: 0.6, green: 0.3, blue: 0.5, alpha: 1.0)
        case .desert: return UIColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0)
        case .polar: return UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
        case .rainforest: return UIColor(red: 0.0, green: 0.5, blue: 0.3, alpha: 1.0)
        case .cityNight: return UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0)
        case .auroraNight: return UIColor(red: 0.0, green: 0.3, blue: 0.4, alpha: 1.0)
        // Image themes use transparent background color
        default: return UIColor.black
        }
    }
    
    var isVideo: Bool {
        return false
    }
    
    var isGradient: Bool {
        // Only gradient themes return true
        switch self {
        case .wallpaper0, .wallpaper1, .wallpaper2, .wallpaper3, .wallpaper4,
             .wallpaper5, .wallpaper6, .wallpaper7, .wallpaper8, .wallpaper9,
             .wallpaper10, .wallpaper11, .wallpaper12, .wallpaper13, .wallpaper14,
             .wallpaper15, .wallpaper16, .wallpaper17, .wallpaper18, .wallpaper19,
             .wallpaper20, .wallpaper21, .wallpaper22, .wallpaper23, .wallpaper24,
             .wallpaper25, .wallpaper26, .wallpaper27, .wallpaper28, .wallpaper29,
             .wallpaper30, .wallpaper31, .wallpaper32, .wallpaper33, .wallpaper34,
             .wallpaper35, .wallpaper36, .wallpaper37, .wallpaper38, .wallpaper39,
             .wallpaper40, .wallpaper41, .wallpaper42, .wallpaper43, .wallpaper44,
             .wallpaper45, .wallpaper46, .wallpaper47, .wallpaper48, .wallpaper49,
             .wallpaper50, .wallpaper51, .wallpaper52, .wallpaper53, .wallpaper54,
             .wallpaper55, .wallpaper56, .wallpaper57, .wallpaper58, .wallpaper59,
             .wallpaper60, .wallpaper61, .wallpaper62, .wallpaper63, .wallpaper64,
             .wallpaper65:
            return false
        default:
            return true
        }
    }
    
    var isWallpaper: Bool {
        return imageName != nil
    }
} 