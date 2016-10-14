//
//  ItinaryController.swift
//  RUSH01
//
//  Created by Fabien TAFFOREAU on 10/14/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//


import UIKit
import MapKit


class ItinaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
     var regionMap : MKCoordinateRegion! 
    
    @IBOutlet weak var departSearchBar: UISearchBar! {
        didSet {
            departSearchBar.delegate = self
        }
    }

    @IBOutlet weak var departTableView: UITableView! {
        didSet {
            departTableView.delegate = self
            departTableView.dataSource = self
        }
    }
    var mapItems: [MKMapItem] = []
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "destinationSegue" {
            if let vc = segue.destinationViewController as? DestinationViewController,
            let cell = sender as? ResultsTableCell {
                vc.regionMap = self.regionMap
                vc.departItem = cell.mapItem
            }
        }
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
            self.departTableView.reloadData()
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
                self.departTableView.reloadData()
            }
            
        }
    }
    
    
}