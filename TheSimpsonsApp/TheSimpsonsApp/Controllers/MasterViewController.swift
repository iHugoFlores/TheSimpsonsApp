//
//  MasterViewController.swift
//  TheSimpsonsApp
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Hugo Flores. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, CharCellDelegate {
    var detailViewController: DetailViewController? = nil

    var objects: [Character] = [Character]()
    
    let cellId = "char_cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        addReDownloadButton()
        
        // tableView.register(CharCell.self, forCellReuseIdentifier: cellId)
        
        SimpsonResponse.getData(onDone: setApiData(data:))
    }
    
    func setApiData(data: [Character]?) -> Void {
        objects = data!
        tableView.reloadData()
    }
    
    func addReDownloadButton() {
        let addButton = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(onRefreshPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func onRefreshPressed() {
        SimpsonResponse.downloadJsonData(fromURL: URL(string: SimpsonResponse.endpoint)!, onDone: setApiData(data:))
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.charInfo = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CharCell
        
        // cell.textLabel!.text = "This is a test: \(indexPath.row)"
        cell.indexPath = indexPath
        cell.delegate = self
        cell.charInfo = objects[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveAllCharData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func setCharImage(indexPath: IndexPath, image: Data?) {
        objects[indexPath.row].imageData = image
        saveAllCharData()
    }
    
    func saveAllCharData() {
        do {
            try objects.writeToPersistence()
        } catch let error {
            NSLog("Error writing to persistence: \(error)")
        }
    }

}

