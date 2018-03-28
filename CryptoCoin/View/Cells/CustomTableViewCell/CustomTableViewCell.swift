//
//  CustomTableViewCell.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

extension UIImage {
    func withSize(_ size: CGSize) -> UIImage? {

        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: .init(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func withSize(_ size: CGSize, identifier: String) -> (UIImage?, String) {
        return (self.withSize(size), identifier)
    }
}

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
        
        self.fullNameLabel.text = nil
        self.smallNameLabel.text = nil
        self.coinImage.image = CustomTableViewCell.imagePlaceholder
        self.changeLabel.text = nil
        self.arrowImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.coinImage.layer.cornerRadius = self.coinImage.frame.height / 2
        self.changeLabel.layer.cornerRadius = self.changeLabel.frame.height / 2
    }
    
    static var images: [String : UIImage] = [:]
    static let imageSize = CGSize(width: 100, height: 100)
    static let imagePlaceholder = UIImage(named: "defaultImage")
    
    func configure(withModel crypt: Crypt) {
        var changes = crypt.percent_change_24h
        print(changes, "test")
        var changesInt = Float(changes)
        //        let priceInt = Int(crypt.price_usd)
        //        let price = priceInt as! NSNumber
        //        let formatter = NumberFormatter()
        //        formatter.numberStyle = .currency
        //        formatter.string(from: price)
        
        var priceLimit = crypt.price_usd as NSString
        
        //        if priceLimit.length > 8 {
        //            self.priceLabel.text = priceLimit.substring(with: NSRange(location: 0, length: priceLimit.length > 8 ? 8 : priceLimit.length)) + "$"
        //        } else {
        //            self.priceLabel.text = crypt.price_usd + "$"
        //        }
        
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 2
        self.fullNameLabel.text = crypt.name
        self.changeLabel.text = crypt.percent_change_24h + "%"
        self.smallNameLabel.text = crypt.symbol
        
        if let cachedImage = CustomTableViewCell.images[crypt.symbol] {
            self.coinImage.image = cachedImage
        } else {
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                if let originalImage = UIImage(named: crypt.symbol) {
                    
                    let (resizedImage, identifier) = originalImage.withSize(CustomTableViewCell.imageSize, identifier: crypt.symbol)
                    
                    DispatchQueue.main.async {
                        
                        if let image = resizedImage, crypt.symbol == identifier {
    
                            self.coinImage.image = image
    
                            CustomTableViewCell.images[crypt.symbol] = image
    
                        }
                    }
                }
            }
        }
        
        
//        self.coinImage.image = UIImage(named: crypt.symbol) ?? CustomTableViewCell.imagePlaceholder
        //        self.coinImage.layer.cornerRadius = self.coinImage.frame.height / 2
        //        self.changeLabel.layer.cornerRadius = self.changeLabel.frame.height / 2
        //        self.cellView.tintColor = .clear
        
        //        let priority = DispatchQueue.GlobalQueuePriority.high
        ////        dispatch_async
        //        DispatchQueue.async(dispatch_get_global_queue(priority, 0)) {
        //
        //        }
        

//        if let cachedImage = CustomTableViewCell.images[crypt.symbol] {
//            self.coinImage.image = cachedImage
//        } else if let cryptImage = UIImage(named: crypt.symbol) {
//            self.coinImage.image = cryptImage
//        }
        
//        DispatchQueue.global(qos: .background).async {
//        
//            let image = UIImage(named: crypt.symbol)?.withSize(CustomTableViewCell.imageSize) ?? CustomTableViewCell.imagePlaceholder
//        
//            DispatchQueue.main.async {
//                
////                image.name == crypt.symbol {
//                    self.coinImage.image = image
////                }
//                
//                
//            }
//        }
    
//        self.coinImage.image = UIImage(named: crypt.symbol)?.withSize(CustomTableViewCell.imageSize)
//        self.coinImage.layer.cornerRadius = self.coinImage.frame.height / 2
//        self.changeLabel.layer.cornerRadius = self.changeLabel.frame.height / 2
        
        if priceLimit.length > 8 {
            self.priceLabel.text = priceLimit.substring(with: NSRange(location: 0, length: priceLimit.length > 8 ? 8 : priceLimit.length)) + "$"
        } else {
            self.priceLabel.text = crypt.price_usd + "$"
            }
            //            if changesInt! > 0.00 {
            //                self.arrowImage.image = UIImage(named: "upArrow")
            //                self.changeLabel.textColor = UIColor(displayP3Red: 82.0/255.0, green: 146.0/255.0, blue: 96.0/255.0, alpha: 1)
            //            }
            //            else {
            //                self.arrowImage.image = UIImage(named: "downArrow")
            //                self.changeLabel.textColor = .red
            //            }
            //            return self
            //        }
        
    }
}
