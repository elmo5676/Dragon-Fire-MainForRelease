//
//  MarkStoreListTableViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/4/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import KML
import CoreData

class MarkStoreListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        listOfFixes = cdu.getMarkStore(pc: pc)
    }
    
    var listOfFixes: [MarkStoreCD] = []
    let cdu = CoreDataUtilities()
    var markCounter = 0
    var shareCSV = false
    var csvString = ""
    var fillerArray = ["Take a Fix"]
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = tableView.contentSize
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shareCSV = false
        csvString = ""
        print("ShareCSV: \(shareCSV)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        tableView.removeObserver(self, forKeyPath: "contentSize")
        markCounter = cdu.getMarkStore(pc: pc).count
        performSegue(withIdentifier: "markSoreUnwindSegue", sender: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnNumber = 0
        if listOfFixes.count != 0{
            returnNumber =  listOfFixes.count
        } else {
            returnNumber = fillerArray.count
        }
        return returnNumber
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markStoreCell", for: indexPath) as! MarkStoreListTableViewCell
        if listOfFixes.count != 0 {
            let fix = listOfFixes[indexPath.row]
            cell.fixImageView.isHidden = true
            cell.fixNumberLabel.text = "\(indexPath.row + 1)"
            cell.markTimeLabel.text = "\(String(describing: fix.markTime_CD!))"
            cell.refBENameLabel.text = "\(String(describing: fix.markBullseyeRefName_CD!))"
            cell.coordsTakenLabel.text = "\(String(format: "%.4f",fix.markPilotCoords_CD![0]))/\(String(format: "%.4f",fix.markPilotCoords_CD![1]))"
            cell.rangeToBELabel.text = "\(fix.markDistanceofPOItoBullsEye_CD)"
            cell.bearingToBELabel.text = "\(fix.markBearingofPOItoBullsEye_CD)"
            cell.coordsOfPOILabel.text = "\(String(describing: fix.markPOICoords_CD!))"
            cell.utmOfPOILabel.text = "\(String(describing: fix.markPOIUTM_CD!))"
            cell.mgrsOfLabel.text = "\(String(describing: fix.markPOIMGRS_CD!))"
        } else {
            cell.fixNumberLabel.text = "\(fillerArray[indexPath.row])"
            cell.fixImageView.isHidden = false
            tableView.rowHeight = 200
            cell.fixNumberLabel.textColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
            for stack in cell.stackViewCollection {
                stack.isHidden = true
            }
            for label in cell.labelCollection {
                
                label.isHidden = true
                label.isEnabled = false
            }}
        return cell
    }
    @IBOutlet var listOfFixesTableView: UITableView!
    @IBAction func deleteAllMarkStoreButton(_ sender: UIBarButtonItem) {
        listOfFixes.removeAll()
        cdu.deleteAllMarkStoreFromDB(pc: pc)
        listOfFixesTableView.reloadData()
    }
    
    @IBAction func shareCSVListOfMarkStoreButton(_ sender: UIBarButtonItem) {
        shareCSV = true
        var csvString = "TIME STAMP, REF BE, COORDS FIX TAKEN, BEARING OFF BE, DIST OFF BE, POI COORDS, POI UTM, POI MGRS, PILOT MAG HEADING, PILOT TRUE HDG \n"
        for fix in listOfFixes {
            csvString += "\(String(describing: fix.markTime_CD!)),\(String(describing: fix.markBullseyeRefName_CD ?? "")),\(String(format: "%.4f",fix.markPilotCoords_CD![0]))/\(String(format: "%.4f",fix.markPilotCoords_CD![1])),\(String(format: "%.0f",fix.markBearingofPOItoBullsEye_CD)),\(String(format: "%.0f",fix.markDistanceofPOItoBullsEye_CD)),\(String(describing: fix.markPOICoords_CD ?? "")),\(String(describing: fix.markPOIUTM_CD ?? "")),\(String(describing: fix.markPOIMGRS_CD ?? "")),\(String(format: "%.0f",fix.markPilotHeadingMag_CD)),\(String(format: "%.0f",fix.markPilotHeadingTrue_CD))\n"
        }
        UserDefaults.standard.set(csvString, forKey: "csvString")
        performSegue(withIdentifier: "markSoreUnwindSegue", sender: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
        print(csvString)
    }
    
    @IBAction func exportToForeFlightButton(_ sender: UIBarButtonItem) {
        shareKML = true
        markStoreInternalKML = ""
        markStoreCompleteKML = ""
        for fix in listOfFixes {
            let nameLabel = "\(fix.markPOICoords_CD ?? ""): \(String(describing: fix.markTime_CD!))"
            var placeMarkLocation: [Double] = []
            do {
                let placeMarkLocationLatLon = try LatLon.parseLatLon(stringToParse: fix.markPOICoords_CD!)
                let placeMarkLocationLat = LatLon.toDouble(placeMarkLocationLatLon)().lat
                let placeMarkLocationLon = LatLon.toDouble(placeMarkLocationLatLon)().lon
                placeMarkLocation.append(placeMarkLocationLon)
                placeMarkLocation.append(placeMarkLocationLat)
            } catch {
                print(error)
            }
            let internalKml = PlacemarkKML(placeMarkTitle: nameLabel,
                                           placeMarkDescription: "",
                                           placeMarkCoords: placeMarkLocation,
                                           iconType: .bluePin,
                                           withLabel: true,
                                           withIcon: true).iconGenerator()
            markStoreInternalKML += internalKml
        }
        markStoreCompleteKML = OpenCloseKML(kmlItems: markStoreInternalKML).KMLGenerator()
        UserDefaults.standard.set(markStoreCompleteKML, forKey: "markStoreCompleteKML")
        print(markStoreCompleteKML)
//        performSegue(withIdentifier: "exportMarkStoreUnwindSegue", sender: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    var markStoreInternalKML: String = ""
    var markStoreCompleteKML: String = ""
    var shareKML: Bool = false
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let timeStamp = listOfFixes[indexPath.section].markTime_CD {
                
                
                do {
                    cdu.deleteMarkStoreNamed(timeStamp, pc: pc)
                    listOfFixes.remove(at: indexPath.row)
                    
                    try pc.viewContext.save()
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print(error)
                }
                
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
            
            
    
            
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
