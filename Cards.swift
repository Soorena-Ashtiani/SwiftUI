//
//  Cards.swift
//  Mobile_App_Two_Project
//
//  Created by Ali Osati on 3/26/23.
//

import Foundation


struct Card: Codable, Identifiable, Hashable {
    let prompt: String
    let answer: String
    var id = UUID()
    
    static let example = Card(prompt: "Who played the 13th Doctor inn Doctor Who?", answer: "Jodie Whittacker")
}
