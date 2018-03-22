//
//  AppStorage.swift
//  MedBook
//
//  Created by Ivan Petrukha on 15.12.2017.
//  Copyright © 2017 Aoza. All rights reserved.
//

import Cache
import Foundation

class AppStorage {
    
    public enum AppStoragePriority {
        case permanent
        case cache
    }
    
    private static var permanentStorage: Storage = try! Storage(
        diskConfig: AppCachePreferences.Permanent.diskConfig,
        memoryConfig: AppCachePreferences.Permanent.memoryConfig
    )
    
    private static var cacheStorage:     Storage = try! Storage(
        diskConfig: AppCachePreferences.Cache.diskConfig,
        memoryConfig: AppCachePreferences.Cache.memoryConfig
    )
    
    static func setObject<T>(_ object: T, forKey key: String, priority: AppStoragePriority) where T: Codable {
        switch priority {
        case .permanent:
            try? permanentStorage.setObject(object, forKey: key)
        case .cache:
            try? cacheStorage.setObject(object, forKey: key)
        }        
    }
    
    static func getObject<T>(ofType type: T.Type, forKey key: String, priority: AppStoragePriority) -> T? where T: Codable {
        switch priority {
        case .permanent:
            return try? permanentStorage.object(ofType: type, forKey: key)
        case .cache:
            return try? cacheStorage.object(ofType: type, forKey: key)
        }
    }
    
    static func removeObject(forKey key: String, priority: AppStoragePriority) {
        switch priority {
        case .permanent:
            try? permanentStorage.removeObject(forKey: key)
        case .cache:
            try? cacheStorage.removeObject(forKey: key)
        }
    }
    
    static func clearPreferences() {
        try? permanentStorage.removeAll()
    }
    
    static func clearCache() {
        try? cacheStorage.removeAll()
    }
}

struct AppCachePreferences {
        
    static var directory: URL {
        return try! FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: true).appendingPathComponent("MedBookStorage")
    }
    
    struct Permanent {
        
        static let diskConfig = DiskConfig(name: "com.aoza.MedBook.permanent",
                                           expiry: .never,
                                           maxSize: (1^20) * 256,
                                           directory: AppCachePreferences.directory.appendingPathComponent("preferences"),
                                           protectionType: .complete)
        
        static let memoryConfig = MemoryConfig(expiry: .never,
                                               countLimit: 25,
                                               totalCostLimit: 5)
    }
    
    struct Cache {
        
        static let diskConfig = DiskConfig(name: "com.aoza.MedBook.cache",
                                           expiry: .date(Date().addingTimeInterval(6*3600)),
                                           maxSize: (1^20) * 128,
                                           directory: AppCachePreferences.directory.appendingPathComponent("cache"),
                                           protectionType: .complete)
        
        static let memoryConfig = MemoryConfig(expiry: .never,
                                               countLimit: 25,
                                               totalCostLimit: 5)
    }
}
