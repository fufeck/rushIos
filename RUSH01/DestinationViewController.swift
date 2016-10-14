//
//  DestinationViewController.swift
//  RUSH01
//
//  Created by Fabien TAFFOREAU on 10/14/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit
import MapKit


class DestinationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var regionMap : MKCoordinateRegion!
    var departItem: MKMapItem!
    
    @IBOutlet weak var destinationSearchBar: UISearchBar! {
        didSet {
            destinationSearchBar.delegate = self
        }
    }

    @IBOutlet weak var destinationTableView: UITableView! {
        didSet {
            destinationTableView.delegate = self
            destinationTableView.dataSource = self
        }
    }
    
    var mapItems: [MKMapItem] = []
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnSegue" {
            if let vc = segue.destinationViewController as? ViewController,
            let index : Int = sender as? Int {
                vc.itinary = (departItem, self.mapItems[index])
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("returnSegue", sender: indexPath.row)
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return mapItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultsTableCell
        cell.mapItem = mapItems[indexPath.row]
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.mapItems.removeAll()
            self.destinationTableView.reloadData()
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
                self.destinationTableView.reloadData()
            }
            
        }
    }

}