//
//  MasterViewController.swift
//  Entities Demo
//
//  Created by Ash Furrow on 2015-10-08.
//  Copyright © 2015 Artsy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MasterViewController: UITableViewController {

  lazy var viewModel = MasterViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.leftBarButtonItem = self.editButtonItem()

    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addObject:")
    self.navigationItem.rightBarButtonItem = addButton
  }

  func addObject(sender: AnyObject!) {
    let newIndexPath = viewModel.addObject()
    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail",
      let indexPath = self.tableView.indexPathForSelectedRow {

        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController

        viewModel.configureDetailItem(controller, forIndexPath: indexPath)

        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()

        controller.navigationItem.leftItemsSupplementBackButton = true
    }
  }

  // MARK: - Table View

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfObjects
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

    cell.textLabel?.text = viewModel.titleForIndexPath(indexPath)

    return cell
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      viewModel.deleteObjectAtIndexPath(indexPath)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
}
