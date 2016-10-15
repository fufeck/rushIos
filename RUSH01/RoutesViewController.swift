//
//  RoutesViewController.swift
//  RUSH01
//
//  Created by Nicolas CHEVALIER on 10/15/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit
import MapKit

class RoutesViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.dataSource = self
		}
	}

	var steps: [MKRouteStep]!

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Steps"
	}

}

extension RoutesViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return steps.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCellWithIdentifier("stepCell") as? StepTableViewCell {

			cell.step = steps[indexPath.row]

			return cell

		}

		return UITableViewCell()
	}

}
