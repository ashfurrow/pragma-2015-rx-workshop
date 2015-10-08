//
//  MasterViewModel.swift
//  Entities Demo
//
//  Created by Ash Furrow on 2015-10-08.
//  Copyright © 2015 Artsy. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailInterestType: class {
    var detailItem: NSDate! { get set }
}

class MasterViewModel: NSObject {

    let source = Variable<[NSDate]>([])

    var numberOfObjects: Int {
        return source.value.count
    }

    func titleForIndexPath(indexPath: NSIndexPath) -> String {
        let object = source.value[indexPath.row]
        return object.description
    }

    func addObject() -> NSIndexPath {
        let newObject = NSDate()
        let newValue = [newObject] + source.value
        source.value = newValue

        return NSIndexPath(forRow: 0, inSection: 0)
    }

    func deleteObjectAtIndexPath(indexPath: NSIndexPath) {
        source.value.removeAtIndex(indexPath.row)
    }

    func configureDetailItem(item: DetailInterestType, forIndexPath indexPath: NSIndexPath) {
        item.detailItem = source.value[indexPath.row]
    }
}
