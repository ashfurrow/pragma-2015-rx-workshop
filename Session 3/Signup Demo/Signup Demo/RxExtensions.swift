import Foundation
import UIKit
import RxSwift

func isEmail(string: String) -> Bool {
    return string.characters.contains("@")
}

func isPassword(string: String) -> Bool {
    return string.characters.count >= 6
}

func and(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
}


extension UIViewController {
  func presentError(error: ErrorType) -> Observable<UIImage!> {
    let alertController = UIAlertController(title: "Network Error", message: (error as NSError).localizedDescription, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .Default) { [weak self] _ -> Void in
      self?.dismissViewControllerAnimated(true, completion: nil)
      })

    self.presentViewController(alertController, animated: true, completion: nil)

    return just(nil)
  }
}
