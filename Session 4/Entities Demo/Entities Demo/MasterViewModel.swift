//
//  MasterViewModel.swift
//  Entities Demo
//
//  Created by Ash Furrow on 2015-10-08.
//  Copyright © 2015 Artsy. All rights reserved.
//

import Foundation
import RxSwift

protocol MasterViewModelType {
    var numberOfObjects: Int { get }
    func titleForIndexPath(indexPath: NSIndexPath) -> String
    func addObject() -> NSIndexPath
    func deleteObjectAtIndexPath(indexPath: NSIndexPath)
    func configureDetailItem(item: DetailInterestType, forIndexPath indexPath: NSIndexPath)
}

protocol DetailInterestType: class {
    var detailItem: NSDate! { get set }
}

class MasterViewModel: NSObject, MasterViewModelType {

    private class ObjectGenerator: MasterViewModelObjectGenerator {
        func generate() -> NSDate {
            return NSDate()
        }
    }

    private let source = Variable<[NSDate]>([])

    let generator: MasterViewModelObjectGenerator

    init(generator: MasterViewModelObjectGenerator) {
        self.generator = generator
        super.init()
    }

    override convenience init() {
        self.init(generator: ObjectGenerator())
    }

    var numberOfObjects: Int {
        return source.value.count
    }

    func titleForIndexPath(indexPath: NSIndexPath) -> String {
        let object = source.value[indexPath.row]
        return object.description
    }

    func addObject() -> NSIndexPath {
        let newObject = generator.generate()
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

protocol MasterViewModelObjectGenerator {
    func generate() -> NSDate
}
