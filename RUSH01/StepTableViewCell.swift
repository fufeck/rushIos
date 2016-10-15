//
//  StepTableViewCell.swift
//  RUSH01
//
//  Created by Nicolas CHEVALIER on 10/15/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit
import MapKit

class StepTableViewCell: UITableViewCell {

	var step: MKRouteStep! {
		didSet {
			instructionLabel.text = step.instructions
			distanceLabel.text = "\(step.distance) meters"
		}
	}

	@IBOutlet weak var instructionLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!

}
