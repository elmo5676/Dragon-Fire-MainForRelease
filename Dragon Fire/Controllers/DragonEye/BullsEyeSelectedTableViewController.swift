//
//  BullsEyeSelectedTableViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/3/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData

class BullsEyeSelectedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        listOfBullseyes = cdu.getBullseye(pc: pc)
        for i in cdu.getSarDot(pc: pc) {
            listOfBullseyes.append(i)
        }
        print(listOfBullseyes.count)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = tableView.contentSize
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    let cdu = CoreDataUtilities()
    var listOfBullseyes: [BullseyeCD] = []
    var selectedBullseye: BullseyeCD?
    var indexPathRowOfSelectedBE: Int?
    let fillerArray = ["Enter BE/SD on KML Tab"]
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if listOfBullseyes.count == 0 {
            number = fillerArray.count
        } else {
            number = listOfBullseyes.count
        }
        return number
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bullsEyeCell", for: indexPath) as! BullsEyeForDragonEyeTableViewCell
        if listOfBullseyes.count == 0 {
            cell.bullsEyeNameLabel.text = fillerArray[indexPath.row]
            cell.coordsLabel.text = ""
        } else {
            if let coords = listOfBullseyes[indexPath.row].centerPoint_CD {
                cell.coordsLabel?.text = "\(coords[0])/\(coords[1])"
            }
            cell.bullsEyeNameLabel?.text = listOfBullseyes[indexPath.row].bullsEyeName_CD
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listOfBullseyes.count != 0 {
            selectedBullseye = listOfBullseyes[indexPath.row]
            indexPathRowOfSelectedBE = indexPath.row
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "chosenBESeque", sender: nil)
    }
 

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
