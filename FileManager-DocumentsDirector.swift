//
//  FileManager-DocumentsDirector.swift
//  Mobile_App_Two_Project
//
//  Created by Ali Osati on 4/1/23.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
