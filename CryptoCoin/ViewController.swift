//
//  ViewController.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Foundation

class Crypt: Codable {
    var id: String
    var name: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var crypts: [Crypt] = []
    
    var coinFullNames = ["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "Cardano"]
    
    var changeValue = ["-9.26",  "-9.26", "-9.26", "-9.26", "-9.26",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.loadData()                        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return coinFullNames.count
        return self.crypts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        let crypt = self.crypts[indexPath.row]
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        cell.fullNameLabel.text = crypt.name
//        cell.coinImage.image = UIImage(named: coinFullNames[indexPath.row])
//        cell.coinImage.layer.cornerRadius = cell.coinImage.frame.height / 2
//        cell.changeLabel.text
//        cell.changeLabel.text = changeValue[indexPath.row]
        
        
        cell.changeLabel.textColor = .red
        
        
        return cell
    }

    func loadData() {
        
        let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/")!
//        var requst = URLRequest(url: url)
//        requst.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print(response)
            
            guard let data = data else {
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let crypts = try decoder.decode([Crypt].self, from: data)
                
                self.crypts = crypts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                
            }
        })
        
    }
    
}

