//
//  ViewController.swift
//  Sequences
//
//  Created by Ash Furrow on 2015-10-08.
//  Copyright © 2015 Artsy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var container: TextFieldSequenceContainer!

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        container = TextFieldSequenceContainer(textField: textField)
        container.observable.subscribeNext { (value) -> Void in
            print("value is \(value)")
        }.addDisposableTo(disposeBag)


//        textField.rx_text.map { (value) -> Bool in
//            return value.characters.contains("@")
//        }.map { (validEmail) -> UIColor in
//            return validEmail ? .greenColor() : .redColor()
//        }.subscribeNext { [weak self] color in
//            self?.view.backgroundColor = color
//        }.addDisposableTo(disposeBag)


        textField.rx_text.map { (value) -> Bool in
            return value.characters.contains("@")
        }.map { (validEmail) -> UIColor in
            return validEmail ? .greenColor() : .redColor()
        }.bindTo(self.backgroundColor)
        .addDisposableTo(disposeBag)
    }
}

