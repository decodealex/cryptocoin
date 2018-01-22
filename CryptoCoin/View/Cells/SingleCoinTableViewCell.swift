//
//  SingleCoinTableViewCell.swift
//  CryptoCoin
//
//  Created by admin on 22.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit

class SingleCoinTableViewCell: UITableViewCell {

    
    @IBOutlet weak var singleCoinView: UIView!
    
    @IBOutlet weak var singleCoinImage: UIImageView!
    
    @IBOutlet weak var oneHourChange: UILabel!
    
    @IBOutlet weak var oneDayChange: UILabel!
    
    @IBOutlet weak var sevenDayChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(withModel coin: SingleCoin) {
        
        self.oneHourChange.text = coin.percent_change_1h
        self.oneDayChange.text = coin.percent_change_24h
        self.sevenDayChange.text = coin.percent_change_7d
        self.singleCoinImage.image = UIImage(named: coin.symbol) ?? UIImage(named: "defaultImage")
        
    }
    
}
