//
//  ViewController.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var coinFullNames = ["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "Cardano"]
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinFullNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.fullNameLabel.text = coinFullNames[indexPath.row]
        cell.coinImage.image = UIImage(named: coinFullNames[indexPath.row])
        
        return cell
    }

}

