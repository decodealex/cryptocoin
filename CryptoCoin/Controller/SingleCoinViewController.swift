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

    
    @IBOutlet weak var singleCoinImage: UIImageView!
    
    @IBOutlet weak var change1hour: UILabel!
    @IBOutlet weak var change24hour: UILabel!
    @IBOutlet weak var change7days: UILabel!
    var coinName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

//    func loadData(completion: @escaping(() -> Void)) {
//        
//        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(coinName)/", method: .get).responseData { (response) in
//            
//            guard let data = response.data else {
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let crypts = try decoder.decode([Crypt].self, from: data)
//                self.crypts = crypts
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    completion()
//                }
//                
//            } catch {
//                
//            }
//        }
//    }

}
