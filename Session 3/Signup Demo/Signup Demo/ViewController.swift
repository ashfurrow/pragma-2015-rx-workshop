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

class ViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ViewModel(
            email: emailAddressTextField.rx_text.asObservable(),
            password: passwordTextField.rx_text.asObservable(),
            enabled: submitButton.rx_enabled,
            submit: submitButton.rx_tap.asObservable(),
            errorHandler: self.presentError,
            imageHandler: imageView.rx_image)
    }
}
