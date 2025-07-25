//
//  Helper Class.swift
//  
//
//  Created by Dip on 26/7/25.
//

import Foundation


struct Directory {
    // MARK: -  Create getDocumentDirectory static method to get the file path to the app's "Documents" directory
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
