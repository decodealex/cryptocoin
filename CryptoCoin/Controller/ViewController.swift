//
//  ViewController.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

//CoinsViewController
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
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.layer.zPosition = -1
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView .register(nib, forCellReuseIdentifier: "customCell")
        
    }
    
    // refreshData
    
    @objc func refreshData() {
        self.loadData {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
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

        cell.configure(withModel: crypt)
        
        // actions when refreshControl.isRefreshing
        
        if refreshControl.isRefreshing {
            cell.changeLabel.layer.borderWidth = 1
            let marginSpace = CGFloat(integerLiteral: 3)
            let insets = UIEdgeInsets(top: marginSpace, left: marginSpace, bottom: marginSpace, right: marginSpace)
            cell.changeLabel.layoutMargins = insets
            
            let when = DispatchTime.now() + 1.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                cell.changeLabel.layer.borderWidth = 0
            }
        }
        
        var changes = crypt.percent_change_24h
        print(changes, "test")
        var changesInt = Float(changes)
        print(changesInt, "floatChange")
        
        // actions when  < 0 changesInt >0
        
        if changesInt! > 0.00 {
            cell.arrowImage.image = UIImage(named: "upArrow")
            cell.changeLabel.textColor = UIColor(displayP3Red: 82.0/255.0, green: 146.0/255.0, blue: 96.0/255.0, alpha: 1)
        }
        else {
            cell.arrowImage.image = UIImage(named: "downArrow")
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
                print(crypts)
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
    
//      var segueToSingleCoinViewController = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let crypt = self.crypts[indexPath.row]        
        self.performSegue(withIdentifier: "toSingleCoinViewController", sender: crypt)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let singleCoinViewController = segue.destination as? SingleCoinViewController, let crypt = sender as? Crypt {
            singleCoinViewController.coinTitleName = crypt.name
            singleCoinViewController.idSingleCoin = crypt.id
            singleCoinViewController.title = crypt.name
        }
    }
}


