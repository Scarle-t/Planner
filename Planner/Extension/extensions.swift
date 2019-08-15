//
//  extensions.swift
//  Planner
//
//  Created by Scarlet on A2019/A/14.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

extension String{
    var uiColor: UIColor{
        
        var r = 0.0, g = 0.0, b = 0.0
        let charset = CharacterSet(charactersIn: "abcdefABCDEF1234567890")
        
        if self.count != 6 {
            return UIColor.white
        }
        if self.rangeOfCharacter(from: charset.inverted) != nil{
            return UIColor.white
        }
        
        let rIndex = self.index(self.startIndex, offsetBy: 2)
        let gIndex = self.index(rIndex, offsetBy: 2)
        let bIndex = self.index(gIndex, offsetBy: 2)
        
        r = Double((Int(self[..<rIndex], radix: 16) ?? 0 )) / 255
        g = Double((Int(self[rIndex..<gIndex], radix: 16) ?? 0 )) / 255
        b = Double((Int(self[gIndex..<bIndex], radix: 16) ?? 0 )) / 255
        
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        
    }
}
