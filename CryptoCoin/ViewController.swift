//
//  ViewController.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

class Crypt: Codable {
    var id: String
    var name: String
    var price_usd: String
    var symbol: String
    var percent_change_24h: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var crypts: [Crypt] = []
    var images = ["defaultImage", "downArrow", "upArrow"]
    var refreshControl = UIRefreshControl()
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshData()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "yeeeeee")
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.layer.zPosition = -1
    }
    
    @objc func refreshData() {
        self.loadData {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = (sender as! CustomTableViewCell)
        let crypt = self.crypts[tableView.indexPath(for: cell)!.row]
        segue.destination.title = crypt.name
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.priceLabel.text = crypt.price_usd + "$"
        cell.changeLabel.text = crypt.percent_change_24h + "%"
        cell.smallNameLabel.text = crypt.symbol
        cell.coinImage.image = UIImage(named: crypt.symbol) ?? UIImage(named: "defaultImage")
        cell.coinImage.layer.cornerRadius = cell.coinImage.frame.height / 2
        
        let changes = crypt.percent_change_24h
        print(changes, "test")
        let changesInt = Float(changes)
        print(changesInt, "floatChange")
        
        if changesInt! > 0.00 {
            cell.arrowImage.image = UIImage(named: images[2])
            cell.changeLabel.textColor = UIColor(displayP3Red: 82.0/255.0, green: 146.0/255.0, blue: 96.0/255.0, alpha: 1)
        }
        else {
            cell.arrowImage.image = UIImage(named: images[1])
            cell.changeLabel.textColor = .red
        }
        return cell
    }
    
    // MARK: - LoadData
    
    func loadData(completion: @escaping(() -> Void)) {
        
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", method: .get).responseData { (response) in
            
            guard let data = response.data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let crypts = try decoder.decode([Crypt].self, from: data)
                self.crypts = crypts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    completion()
                }

            } catch {
                
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

