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

extension ViewController {
  var textFieldFrame: ObserverOf<CGRect> {
    return ObserverOf<CGRect> { [weak self] event in
      switch event {
      case .Next(let frame):
        self?.textField.frame = frame
      default: break
      }
    }
  }
}