//
//  SingleCoin.swift
//  CryptoCoin
//
//  Created by admin on 22.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import Foundation

class SingleCoin: Codable {
    
    var id: String
    var name: String
    var price_usd: String
    var symbol: String
    var price_btc: String
    var percent_change_1h: String
    var percent_change_24h: String
    var percent_change_7d: String
    var market_cap_usd: String
    var available_supply: String
    var max_supply: String?
    var volume_usd: String
    
//    "id": "bitcoin",
//    "name": "Bitcoin",
//    "symbol": "BTC",
//    "rank": "1",
//    "price_usd": "573.137",
//    "price_btc": "1.0",
//    "24h_volume_usd": "72855700.0",
//    "market_cap_usd": "9080883500.0",
//    "available_supply": "15844176.0",
//    "total_supply": "15844176.0",
//    "max_supply": "21000000.0",
//    "percent_change_1h": "0.04",
//    "percent_change_24h": "-0.3",
//    "percent_change_7d": "-0.57",
//    "last_updated": "1472762067"
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price_usd = try container.decode(String.self, forKey: .price_usd)
        self.price_btc = try container.decode(String.self, forKey: .price_btc)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.percent_change_1h = try container.decode(String.self, forKey: .percent_change_1h)
        self.percent_change_24h = try container.decode(String.self, forKey: .percent_change_24h)
        self.percent_change_7d = try container.decode(String.self, forKey: .percent_change_7d)
        self.market_cap_usd = try container.decode(String.self, forKey: .market_cap_usd)
        self.available_supply = try container.decode(String.self, forKey: .available_supply)
        self.max_supply = try? container.decode(String.self, forKey: .max_supply)
        self.volume_usd = try container.decode(String.self, forKey: .volume_usd)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price_usd
        case symbol
        case price_btc
        case percent_change_1h
        case percent_change_24h
        case percent_change_7d
        case market_cap_usd
        case available_supply
        case max_supply
        case volume_usd = "24h_volume_usd"
    }
}
