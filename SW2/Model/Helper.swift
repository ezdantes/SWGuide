//
//  Helper.swift
//  SW2
//
//  Created by Vladislav Barinov on 21.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import Foundation

class Helper {
    static let shered: Helper = Helper() // синг тон
    
    func getLastIndexFromUrl(_ string: String?) -> Int? {
        
        if let string = string {
            
            let newString = NSString.init(string: string)
            
            let arrayOfStrings = newString.components(separatedBy: "/")
            
            let index = Int(arrayOfStrings[5])
            
            return index
            
        }
        
        return nil
    }
}
