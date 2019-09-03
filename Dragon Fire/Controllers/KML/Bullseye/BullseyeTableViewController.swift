//
//  BullseyeTableViewController.swift
//  Dragon Fire
//
//  Created by elmo on 6/18/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData




extension BullseyeTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshView.scrollViewWillBeginDragging(scrollView)
    }}

extension BullseyeTableViewController: BreakOutToRefreshDelegate {
    func refreshViewDidRefresh(_ refreshView: BreakOutToRefreshView) {
        // load stuff from the internet
    }}


class BullseyeTableViewController: UITableViewController {
    var refreshView: BreakOutToRefreshView!
    let cdu = CoreDataUtilities()
    var bullsEyeArray: [BullseyeCD] = []
    var sarDotArray: [BullseyeCD] = []
    var tableSectionCells: [[BullseyeCD]] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    var beOrSd = "BE" {
        didSet {
            print("beOrSd set")
        }}
    var tableSections = ["BULLSEYE:", "SAR/DOT:"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pc = appDelegate.persistentContainer
        tableSectionCells = [bullsEyeArray, sarDotArray]
        refreshView = BreakOutToRefreshView(scrollView: tableView)
        refreshView.delegate = self as? SKViewDelegate
        // configure the colors of the refresh view
        refreshView.scenebackgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        refreshView.paddleColor = UIColor.red
        refreshView.ballColor = UIColor.white
        refreshView.blockColors = [UIColor(hue: 0.17, saturation: 0.9, brightness: 1.0, alpha: 1.0), UIColor(hue: 0.17, saturation: 0.7, brightness: 1.0, alpha: 1.0), UIColor(hue: 0.17, saturation: 0.5, brightness: 1.0, alpha: 1.0)]
        tableView.addSubview(refreshView)
        tableView.rowHeight = 400
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func dismissBarButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //This changes size of the table based on content
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = tableView.contentSize
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableSections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableSectionCells[section] as AnyObject).count
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = #colorLiteral(red: 0.9961829782, green: 1, blue: 0.6791642308, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bullseyeCell", for: indexPath) as! BullseyeTableViewCell
        let sectionArray = tableSectionCells[indexPath.section]
        let item = sectionArray[indexPath.row]
        cell.exportToForeFlightOutlet.standardButtonFormatting(cornerRadius: true)
        cell.nameOfBullseyeLabel.text = item.bullsEyeName_CD!
        cell.nameOfBullseyeLabel.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.nameOfBullseyeLabel.layer.borderWidth = 1
        cell.nameOfBullseyeLabel.layer.cornerRadius = cell.exportToForeFlightOutlet.frame.width/10
        cell.lineWidthLabel.text = String(item.lineThickness_CD)
        cell.centerPointLabel.text = "\(String(format: "%.4f",item.centerPoint_CD![0]))/\(String(format: "%.4f",item.centerPoint_CD![1]))"
        cell.sizeOfBullsEyeLabel.text = "\(item.radiusOfOuterRing_CD) NM"
        cell.magVarLabel.text = "\(String(format: "%.1f", item.magVariation_CD)) °"
        if item.centerpointLabel_CD == true {
            cell.centerPointIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.centerPointIncludedTextLabel.text = "Centerpoint Label Displayed"
        } else {
            cell.centerPointIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
            cell.centerPointIncludedTextLabel.text = "Centerpoint Label Not Displayed"
        }
        if item.rangeLabels_CD == true {
            cell.rangeLabelIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.rangelabelLabel.text = "Range Labels Displayed"
        } else {
            cell.rangeLabelIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
            cell.rangelabelLabel.text = "Range Labels Not Displayed"
        }
        if item.bearingLabels_CD == true {
            cell.bearingLabelIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.bearingLabelIncludedTextLabel.text = "Bearing Labels Displayed"
        } else {
            cell.bearingLabelIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
            cell.bearingLabelIncludedTextLabel.text = "Bearing Labels Not Displayed"
        }
        if item.centerpointIconIncluded_CD == true {
            cell.centerpointIconIncludedIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.centerpointIconIncludedLabel.text = "Centerpoint Icon Displayed"
        } else {
            cell.centerpointIconIncludedIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
            cell.centerpointIconIncludedLabel.text = "Centerpoint Icon Not Displayed"
        }
        if item.rangeIconsIncluded_CD == true {
            cell.rangeBearingIconIncludedIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.rangeBearingIconIncludedLabel.text = "Range/Bearing Icons Displayed"
        } else {
            cell.rangeBearingIconIncludedIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
            cell.rangeBearingIconIncludedLabel.text = "Range/Bearing Icons Not Displayed"
        }
        if item.includedInBL_CD == true {
            cell.includedBEIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        } else {
            cell.includedBEIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
        }
        let colorImageName = item.lineColor_CD!.switchCodeToImage()
        cell.colorImage.image = UIImage(named: colorImageName)
        cell.centerPointIcon.image = UIImage(named: item.centerpointIcon_CD!.switchIcon())
        cell.rangeBearingIcon.image = UIImage(named: item.rangeBearingIconType_CD!.switchIcon())
        cell.exportToForeFlightOutlet.tag = indexPath.section
        
        // MARK: - ROW / SECTION
        ///////Add below to get ROW and SECTION into a button
        cell.exportToForeFlightOutlet.addTarget(self, action: #selector(self.exportToForeFlight(_:)), for: .touchUpInside)
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
    
    // MARK: - Unwind with info (HOLY SHIT!)
    var chosenBE_SARDOT: BullseyeCD?
    @IBAction func exportToForeFlight(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableView as UIView)
        let indexPath: IndexPath! = self.tableView.indexPathForRow(at: point)
        let section = indexPath.section
        let row = indexPath.row
        chosenBE_SARDOT = tableSectionCells[section][row]
        presentingViewController?.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "exportToForeflight", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionOfTable = tableSectionCells[indexPath.section]
            pc.viewContext.delete(sectionOfTable[indexPath.row])
            do {
                //Manipulating the CoreData model
                try pc.viewContext.save()
                //Refreshing the controlling arrays to reflect whats actually in CoreData model
                self.bullsEyeArray.removeAll()
                self.sarDotArray.removeAll()
                self.tableSectionCells.removeAll()
                self.bullsEyeArray = cdu.getBullseye(pc: pc)
                self.sarDotArray = cdu.getSarDot(pc: pc)
                self.tableSectionCells = [bullsEyeArray, sarDotArray]
            } catch {
                print("What the?!!")
            }
            tableView.deleteRows(at: [indexPath], with: .fade) //This line reloads the data automatically
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}










































