//
//  DivertFieldsTableViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 7/3/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import KML

class DivertFieldsTableViewController: UITableViewController {
    
    
    // MARK: - Setup
    var airfields: [AirfieldCD] = []
    var chosenAirfield: AirfieldCD?
    let cdu = CoreDataUtilities()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(airfields)
        tableView.rowHeight = 250
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    //This changes size of the table based on content
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize.height = 250//tableView.contentSize
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airfields.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airfieldsCell", for: indexPath) as! DivertFieldTableViewCell
        cell.icaoLabel.text = airfields[indexPath.row].icao_CD!
        cell.nameLabel.text = airfields[indexPath.row].name_CD!
        cell.fieldElevLabel.text = "\(airfields[indexPath.row].elevation_CD)"
        cell.countryLabel.text = airfields[indexPath.row].country_CD
        cell.coordinatesLabel.text = "\(String(format: "%.4f",airfields[indexPath.row].latitude_CD)) \(String(format: "%.4f",airfields[indexPath.row].longitude_CD))"
        cell.mgrsLabel.text = airfields[indexPath.row].mgrs_CD
        cell.timeConvLabel.text = airfields[indexPath.row].timeConversion_CD
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenAirfield = airfields[indexPath.row]
        
        performSegue(withIdentifier: "chosenAirfield", sender: nil)
    }
    
}




















