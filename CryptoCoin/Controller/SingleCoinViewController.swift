//
//  SingleCoinViewController.swift
//  CryptoCoin
//
//  Created by admin on 16.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class SingleCoinViewController: UIViewController {
    
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
    
    
//    @IBAction func addCoin(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Perfecto", message: "U add that shit to favourite", preferredStyle: .alert)
//        //        let saveAction = UIAlertAction(title: "diNahooi", style: .default) {
//        ////            var symbol = coinSymbolLabel.text
//        //////            self.save(coinSymbol: symbol)
//        //        }
//        
//        let saveAction = UIAlertAction(title: "Save", style: .default) {
//            [unowned self] action in
//            
//            let coinToSave = self.coinSymbolLabel.text
//            
////            self.save(coinSymbol: coinToSave!)
//            
//            UserDefaults.standard.set(true, forKey: self.idSingleCoin)
//            
//        }
//        
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
    
    
    
    

    

    
    
    var idSingleCoin = ""
    var addedCoins: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Coin ID is: \(idSingleCoin)")
        
        //        coinImageContraint.constant = 0
        
        
        self.loadData { (singleCoin) in
            self.coinImage.image = UIImage(named: singleCoin.symbol) ?? UIImage(named: "defaultImage")
            self.coinTitlePriceLabel.text = singleCoin.price_usd + " $"
            print(singleCoin.price_usd)
            self.coinPriceLabel.text = singleCoin.price_usd + " $"
            self.coinNameLabel.text = singleCoin.name
            print(singleCoin.name)
            self.coinSymbolLabel.text = singleCoin.symbol
            print(singleCoin.symbol)
            self.coinPriceBtcLabel.text = singleCoin.price_btc + " ฿"
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
            
//            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapButton))
//            let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.tapButton))
//            self.navigationItem.rightBarButtonItem = addButton
//            if UserDefaults.standard.bool(forKey: self.idSingleCoin) != true {
//                self.navigationItem.rightBarButtonItem = addButton
//            } else {
//                self.navigationItem.rightBarButtonItem = removeButton
//            }            
        }
        
        self.addOrRemoveFavouriteButton()
    }
    
//    @objc func tapButton() {
//        let alert = UIAlertController(title: "Perfecto", message: "U add that shit to favourite", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default) {
//            [unowned self] action in
//            //            let coinToSave = self.coinSymbolLabel.text
//            //            //            self.save(coinSymbol: coinToSave!)
//            if UserDefaults.standard.bool(forKey: self.idSingleCoin) != true {
//            UserDefaults.standard.set(true, forKey: self.idSingleCoin)
//            } else {
//                UserDefaults.standard.set(false, forKey: self.idSingleCoin)
//            }
//        }
//
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
    
    @objc func addButtonAction() {
//        let alert = UIAlertController(title: "Perfecto", message: "U add that shit to favourite", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default) {
//            [unowned self] action in
//            //            let coinToSave = self.coinSymbolLabel.text
//            //            //            self.save(coinSymbol: coinToSave!)
//
//            UserDefaults.standard.set(true, forKey: self.idSingleCoin)
//
//            self.addOrRemoveFavouriteButton()
//        }
//
//        alert.addAction(saveAction)
//        present(alert, animated: true)
        UserDefaults.standard.set(true, forKey: self.idSingleCoin)
        self.addOrRemoveFavouriteButton()
    }
    
    @objc func removeButtonAction() {
//        let alert = UIAlertController(title: "oh-oh", message: "Delete this coin from favourites?", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Remove", style: .default) {
//            [unowned self] action in
//            //            let coinToSave = self.coinSymbolLabel.text
//            //            //            self.save(coinSymbol: coinToSave!)
//
//            UserDefaults.standard.set(false, forKey: self.idSingleCoin)
//            self.addOrRemoveFavouriteButton()
//        }
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        alert.addAction(saveAction)
//        present(alert, animated: true)
        UserDefaults.standard.set(false, forKey: self.idSingleCoin)
        self.addOrRemoveFavouriteButton()
    }
    
    func addOrRemoveFavouriteButton() {
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonAction))
        let addButton = UIBarButtonItem(image: UIImage(named: "ic_star")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(addButtonAction))
        
//        let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.removeButtonAction))
        let removeButton = UIBarButtonItem(image: UIImage(named: "ic_star_filled")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(removeButtonAction))
        
        if UserDefaults.standard.bool(forKey: self.idSingleCoin) != true {
            self.navigationItem.rightBarButtonItem = addButton
        } else {
            self.navigationItem.rightBarButtonItem = removeButton
            
        }
        
    }
    

    var coinTitleName = ""
    
    
    
    // MARK: - LoadData
    
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

