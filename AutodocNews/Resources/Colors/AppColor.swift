import UIKit.UIColor

enum AppColor {
    case primaryBackground
    case cardBackground
    case primaryText
    case activityIndicator 
    
    var color: UIColor {
        switch self {
        case .primaryBackground:
            UIColor(light: "#dddddd", dark: "#121212")
        case .cardBackground:
            UIColor(light: "#FFFFFF", dark: "#1E1E1E")
        case .primaryText:
            UIColor(light: "#1A1A1A", dark: "#EAEAEA")
        case .activityIndicator:
            UIColor(light: "#6B6B6B", dark: "#A8A8A8")
        }
    }
}
