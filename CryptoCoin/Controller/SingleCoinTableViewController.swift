//
//  SingleCoinTableViewController.swift
//  CryptoCoin
//
//  Created by admin on 23.03.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

class SingleCoinTableViewController: UITableViewController {
    
    var idSingleCoin = ""
    var coinTitleName = ""
    
    @IBOutlet weak var coinImageContraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var coinTitlePriceLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinPriceBtcLabel: UILabel!
    @IBOutlet weak var coin24hVolumeLabel: UILabel!
    @IBOutlet weak var coinMarketCapLabel: UILabel!
    @IBOutlet weak var coinAvailableSupplyLabel: UILabel!
    @IBOutlet weak var coinTotalSupplyLabel: UILabel!
    @IBOutlet weak var coin1hChangeLabel: UILabel!
    @IBOutlet weak var coin24hChangeLabel: UILabel!
    @IBOutlet weak var coin7dChangeLabel: UILabel!
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.loadData { (singleCoin) in
            self.coinImage.image = UIImage(named: singleCoin.symbol) ?? UIImage(named: "defaultImage")
            self.coinTitlePriceLabel.text = singleCoin.price_usd + " $"
            print(singleCoin.price_usd)
            self.coinPriceLabel.text = singleCoin.price_usd + " $"
            self.coinNameLabel.text = singleCoin.name
            print(singleCoin.name)
            self.coinSymbolLabel.text = singleCoin.symbol
            print(singleCoin.symbol)
            self.coinPriceBtcLabel.text = singleCoin.price_btc + " BTC"
            print(self.coinPriceBtcLabel.text)
            self.coin24hVolumeLabel.text = singleCoin.volume_usd + " $"
            print(self.coin24hVolumeLabel.text)
            self.coinMarketCapLabel.text = singleCoin.market_cap_usd + " $"
            print(self.coinMarketCapLabel.text)
            self.coinAvailableSupplyLabel.text = singleCoin.available_supply
            print(self.coinAvailableSupplyLabel.text)
            self.coinTotalSupplyLabel.text = singleCoin.max_supply
            print(self.coinTotalSupplyLabel.text)
            self.coin1hChangeLabel.text = singleCoin.percent_change_1h + " %"
            print(self.coin1hChangeLabel.text)
            self.coin24hChangeLabel.text = singleCoin.percent_change_24h + " %"
            print(self.coin24hChangeLabel.text)
            self.coin7dChangeLabel.text = singleCoin.percent_change_7d + " %"
            print(self.coin7dChangeLabel.text)
            print(singleCoin.percent_change_7d)
            
            self.coinImage.clipsToBounds = true
            self.coinImage.layer.cornerRadius = self.coinImage.frame.height / 2
        }
        
        self.addOrRemoveFavouriteButton()
    }
    
    
    
    @objc func addButtonAction() {
        UserDefaults.standard.set(true, forKey: self.idSingleCoin)
        self.addOrRemoveFavouriteButton()
    }
    
    @objc func removeButtonAction() {
        UserDefaults.standard.set(false, forKey: self.idSingleCoin)
        self.addOrRemoveFavouriteButton()
    }
    
    func addOrRemoveFavouriteButton() {
        
//                let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonAction))
        let addButton = UIBarButtonItem(image: UIImage(named: "ic_star")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(addButtonAction))
        
        //        let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.removeButtonAction))
        let removeButton = UIBarButtonItem(image: UIImage(named: "ic_star_filled")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(removeButtonAction))
        
        if UserDefaults.standard.bool(forKey: self.idSingleCoin) != true {
            self.navigationItem.rightBarButtonItem = addButton
        } else {
            self.navigationItem.rightBarButtonItem = removeButton
            
        }
        
    }
    
    func loadData(completion: @escaping((SingleCoin) -> Void)) {
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(self.idSingleCoin)/", method: .get).responseData { (response) in
            guard let data = response.data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let singleCoinData = try decoder.decode([SingleCoin].self, from: data)
                if let singleCoin = singleCoinData.first {
                    DispatchQueue.main.async {
                        completion(singleCoin)
                    }
                }
            } catch {
            }
        }
    }
}




