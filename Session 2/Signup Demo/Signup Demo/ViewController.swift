//
//  ViewController.swift
//  Signup Demo
//
//  Created by Ash Furrow on 2015-10-08.
//  Copyright © 2015 Artsy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let validEmail = emailAddressTextField.rx_text.map(isEmail)
        let validPassword = passwordTextField.rx_text.map(isPassword)

        combineLatest(validEmail, validPassword, and)
        .bindTo(submitButton.rx_enabled)

        
        submitButton.rx_tap.map { _ -> Observable<MoyaResponse> in
            return provider.request(.Image)
        }.flatMap() { obs in
            return obs.filterSuccessfulStatusCodes()
                .mapImage()
                .catchError(self.presentError)
                .filter({ (thing) -> Bool in
                    return thing != nil
                })
        }
        .take(1)
        .bindTo(imageView.rx_image)
        .addDisposableTo(disposeBag)
    }

}

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
