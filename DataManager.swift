//
//  DataManager.swift
//  Mobile_App_Two_Project
//
//  Created by Ali Osati on 4/1/23.
//

import Foundation

struct DataManager {
    static let savePath = FileManager.documentDirectory.appendingPathComponent("SaveData")
    
    static func load() -> [Card]{
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data){
                return decoded
            }
        }
        
        return []
    }
    
    static func save(_ cards: [Card]) {
        if let data = try? JSONEncoder().encode(cards) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}
