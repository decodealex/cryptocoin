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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        cell.fullNameLabel.text = coinFullNames[indexPath.row]
        cell.coinImage.image = UIImage(named: coinFullNames[indexPath.row])
        cell.coinImage.layer.cornerRadius = cell.coinImage.frame.height / 2
        
        return cell
    }

}

