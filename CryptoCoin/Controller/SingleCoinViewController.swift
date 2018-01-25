//
//  SingleCoinViewController.swift
//  CryptoCoin
//
//  Created by admin on 16.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

class SingleCoinViewController: UIViewController {
   
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
    
    var idSingleCoin = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Coin ID is: \(idSingleCoin)")
       
        
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
            
        }
    }
    
    var coinTitleName = ""

  

    // MARK: - LoadData
    
    func loadData(completion: @escaping((SingleCoin) -> Void)) {
//      var api = "https://api.coinmarketcap.com/v1/ticker/\(self.idSingleCoin)/"
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(self.idSingleCoin)/", method: .get).responseData { (response) in
//            print(api)
            guard let data = response.data else {
                return
            }

            do {
                
                let decoder = JSONDecoder()
                let singleCoinData = try decoder.decode([SingleCoin].self, from: data)
//                print("DATA ------------ \(data)")
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

