import Foundation

enum ImageFlipup: String, CaseIterable {

    
    case Flipup6 = "itemfdsdf6" 
    case Flipup7 = "itemfdsdf7" //
    case Flipup8 = "itemfdsdf8" //
    case Flipup9 = "itemfdsdf9" //
    case Flipup10 = "itemfdsdf10" //
    case Flipup11 = "itemfdsdf11" //
    case Flipup13 = "itemfdsdf13" //
    case Flipup17 = "itemfdsdf17" //
    case Flipup18 = "itemfdsdf18" //
    
    var clearItem: String {
        switch self {
        case .Flipup6:
            return "itemfdsdf6c"
        case .Flipup7:
            return "itemfdsdf7c"
        case .Flipup8:
            return "itemfdsdf8c"
        case .Flipup9:
            return "itemfdsdf9c"
        case .Flipup10:
            return "itemfdsdf10c"
        case .Flipup11:
            return "itemfdsdf11c"
        case .Flipup13:
            return "itemfdsdf13c"
        case .Flipup17:
            return "itemfdsdf17c"
        case .Flipup18:
            return "itemfdsdf18c"
        }
    }
    
    var imageName: String {
        return self.rawValue
    }
    
    var subItem: String {
        switch self {
            
        case .Flipup6:
            return "itemfdsdf2"
        case .Flipup7:
            return "itemfdsdf3"
        case .Flipup8:
            return "itemfdsdf15"
        case .Flipup9:
            return "itemfdsdf4"
        case .Flipup10:
            return "itemfdsdf5"
        case .Flipup11:
            return "itemfdsdf1"
        case .Flipup13:
            return "itemfdsdf14"
        case .Flipup17:
            return "itemfdsdf12"
        case .Flipup18:
            return "itemfdsdf16"
        }
    }

}
