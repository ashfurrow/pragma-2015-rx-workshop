import Foundation
import Quick
import Nimble
@testable
import Entities_Demo

class MasterViewModelTests: QuickSpec {
    override func spec() {
        var generator: TestObjectGenerator!
        var subject: MasterViewModel!

        beforeEach {
            generator = TestObjectGenerator(date: NSDate())
            subject = MasterViewModel(generator: generator)
        }

        it("begins with no objects") {
            expect(subject.numberOfObjects) == 0
        }

        it("adds one object when addObject() is called") {
            subject.addObject()
            expect(subject.numberOfObjects) == 1
        }

        it("returns an index path representative of an added object") {
            let indexPath = subject.addObject()
            let title = subject.titleForIndexPath(indexPath)

            expect(title) == generator.date.description
        }

        describe("with objects") {
            beforeEach {
                Array(0..<3).forEach { _ in
                    subject.addObject()
                }
            }

            it("has the right number of objects") {
                expect(subject.numberOfObjects) == 3
            }

            it("removes one object when deleteObjectAtIndexPath is called") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                subject.deleteObjectAtIndexPath(indexPath)
                expect(subject.numberOfObjects) == 2
            }

            it("configures the detail item with the object at a given index path") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)

                let detail = TestDetailInterest()
                subject.configureDetailItem(detail, forIndexPath: indexPath)

                // Note the use of the identity expectation
                expect(detail.detailItem) === generator.date
            }
        }
    }
}

class TestDetailInterest : DetailInterestType {
    var detailItem: NSDate! = nil
}

struct TestObjectGenerator: MasterViewModelObjectGenerator {
    let date: NSDate

    func generate() -> NSDate {
        return date
    }
}