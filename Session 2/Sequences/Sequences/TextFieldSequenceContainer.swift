//
//  TextFieldSequenceContainer.swift
//  Sequences
//
//  Created by Ash Furrow on 2015-10-08.
//  Copyright © 2015 Artsy. All rights reserved.
//

import UIKit
import RxSwift

class TextFieldSequenceContainer: NSObject {

    weak var textField: UITextField!
    private let variable: Variable<String>

    var observable: Observable<String> {
        return self.variable.asObservable().skip(1)
    }

    init(textField: UITextField) {
        self.textField = textField
        self.variable = Variable("")

        super.init()

        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: nil) { [weak self] notification in


            self?.variable.value = self?.textField.text ?? ""

        }
    }
    
}
