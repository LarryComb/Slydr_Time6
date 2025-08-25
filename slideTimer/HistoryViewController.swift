//
//  HistoryViewController.swift
//  slideTimer
//
//  Created by LARRY COMBS on 3/3/18.
//  Copyright © 2018 LARRY COMBS. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    let timeEntriesArrayKey = "timeEntriesArrayKey"
    
    var model = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = SlideTimerUserDefaults().getAllEntries()
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = model[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            defaults.set(model, forKey: timeEntriesArrayKey)
        }
    }
    
}
