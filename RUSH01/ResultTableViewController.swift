//
//  ResultTableViewController.swift
//  RUSH01
//
//  Created by Fabien TAFFOREAU on 10/14/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit
import MapKit

class ResultsTableCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var mapItem: MKMapItem! {
        didSet {
            self.nameLabel.text = mapItem.name
            self.locationLabel.text = mapItem.placemark.title
        }
    }

}

class ResultsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var mapItems: [MKMapItem] = []
    var regionMap : MKCoordinateRegion! 
    
    @IBOutlet weak var resultTableView: UITableView! {
        didSet {
            resultTableView.delegate = self
            resultTableView.dataSource = self
        }
    }
    @IBOutlet weak var locationSearchBar: UISearchBar! {
        didSet {
            locationSearchBar.delegate = self
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSegue" {
            if let vc = segue.destinationViewController as? ViewController,
                let index : Int = sender as? Int {
                vc.searchItem = mapItems[index]
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return mapItems.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showSegue", sender: indexPath.row)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultsTableCell
        cell.mapItem = mapItems[indexPath.row]
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.mapItems.removeAll()
            self.resultTableView.reloadData()
        } else {
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchText
            request.region = self.regionMap
            let  search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { (response, error) -> Void in
                
                guard response != nil else {
                    return
                }
                self.mapItems = response!.mapItems
                self.resultTableView.reloadData()
            }
            
        }
    }
    
}