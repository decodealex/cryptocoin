//
//  CustomTableViewCell.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire


class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var coinImage: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var smallNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var changeLabel: UILabel!
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }

    func configure(withModel crypt: Crypt) {
        
//        let priceInt = Int(crypt.price_usd)
//        let price = priceInt as! NSNumber
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.string(from: price)
        
        var priceLimit = crypt.price_usd as NSString
        
        if priceLimit.length > 8 {
            self.priceLabel.text = priceLimit.substring(with: NSRange(location: 0, length: priceLimit.length > 8 ? 8 : priceLimit.length)) + "$"
        } else {
            self.priceLabel.text = crypt.price_usd + "$"
        }
        
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 2
        self.fullNameLabel.text = crypt.name
        self.changeLabel.text = crypt.percent_change_24h + "%"
        self.smallNameLabel.text = crypt.symbol
        self.coinImage.image = UIImage(named: crypt.symbol) ?? UIImage(named: "defaultImage")
        self.coinImage.layer.cornerRadius = self.coinImage.frame.height / 2
        self.changeLabel.layer.cornerRadius = self.changeLabel.frame.height / 2
//        self.cellView.tintColor = .clear
        
    
        
        
    }
}
