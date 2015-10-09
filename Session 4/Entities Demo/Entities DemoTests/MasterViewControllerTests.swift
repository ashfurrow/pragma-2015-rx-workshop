import Foundation
import Quick
import Nimble
import Nimble_Snapshots
@testable
import Entities_Demo

let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

class MasterViewControllerTests: QuickSpec {
    override func spec() {
        var subject: MasterViewController!
        var testViewModel: TestMasterViewModel!

        beforeEach {
            testViewModel = TestMasterViewModel()
            subject = storyboard.instantiateViewControllerWithIdentifier("Main") as! MasterViewController
            subject.viewModel = testViewModel
        }

        it("looks right by default") {
            expect(subject).to( haveValidSnapshot() )
        }

        it("looks right after an added object") {
            subject.addObject(self)
            expect(subject).to( haveValidSnapshot() )
        }

        it("looks right after a deleted object") {
            subject.tableView(subject.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            expect(subject).to( haveValidSnapshot() )
        }
    }
}

class TestMasterViewModel: NSObject, MasterViewModelType {

    var numberOfObjects = 5
    var date = NSDate()

    func titleForIndexPath(indexPath: NSIndexPath) -> String {
        return "Title \(indexPath.row)"
    }

    func addObject() -> NSIndexPath {
        numberOfObjects++
        return NSIndexPath(forRow: 0, inSection: 0)
    }

    func deleteObjectAtIndexPath(indexPath: NSIndexPath) {
        numberOfObjects--
    }

    func configureDetailItem(item: DetailInterestType, forIndexPath indexPath: NSIndexPath) {
        item.detailItem = date
    }
}
