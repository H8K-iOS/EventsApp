import UIKit

final class TimeRemainingViewModel {
    enum Mode {
        case cell
        case detail
    }
    
    let timeRemainingParts: [String]
    private let mode: Mode
    
    var fontSize: CGFloat {
        switch mode {
        case .cell:
            return 25
        case .detail:
            return 35
        }
    }
    
    var aligment: UIStackView.Alignment {
        switch mode {
        case .cell:
            return .trailing
        case .detail:
            return .center
        }
    }
    
    init(timeRemainingParts: [String], mode: Mode){
        self.timeRemainingParts = timeRemainingParts
        self.mode = mode
    }
    
}
