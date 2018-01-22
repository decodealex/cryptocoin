//
//  SingleCoinViewController.swift
//  CryptoCoin
//
//  Created by admin on 16.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

class SingleCoinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var singleCoinTableView: UITableView! {
            didSet {
                singleCoinTableView.delegate = self
                singleCoinTableView.dataSource = self
            }
    }
    var singleCoinData: [SingleCoin] = []
    var coinName: String = ""
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshData()
        // Do any additional setup after loading the view.
    }
    
    
    // refreshData
    
    @objc func refreshData() {
        self.loadData {
            self.singleCoinTableView.reloadData()
            self.refreshControl.endRefreshing()
            self.singleCoinTableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.singleCoinData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sigleCoinCell") as! SingleCoinTableViewCell
        let coin = self.singleCoinData[indexPath.row]
        cell.configure(withModel: coin)
        
        return cell
    }

    // MARK: - LoadData
    
    func loadData(completion: @escaping(() -> Void)) {
        
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(coinName)/", method: .get).responseData { (response) in
            
            guard let data = response.data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let singleCoinData = try decoder.decode([SingleCoin].self, from: data)
                self.singleCoinData = singleCoinData
                
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                
            }
        }
    }

}

