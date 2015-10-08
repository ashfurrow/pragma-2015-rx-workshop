import UIKit
import RxSwift

extension UIViewController {
    var backgroundColor: ObserverOf<UIColor> {
        return ObserverOf<UIColor> { [weak self] event in
            switch event {
            case .Next(let color):
                self?.view.backgroundColor = color
            default: break
            }
        }
    }
}