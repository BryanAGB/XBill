//
//  GameConstants.swift
//  XBill
//
//  Created by Bryan Mansell on 17/07/2020.
//  Copyright © 2020 Bryan Mansell. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
    
    struct StringConstants {
        static let billName = "Bill"
        static let billImageName = "right_0"
        static let billRightAtlas = "right"
        static let billLeftAtlas = "left"
        static let billSwapAtlas = "swap"
        static let billDieAtlas = "die"
        static let computerName = "Computer"
        static let rightPrefixKey = "right_"
        static let leftPrefixKey = "left_"
        static let swapPrefixKey = "swap_"
        static let diePrefixKey = "die_"
        
        static let deathSound = "ahh"
        
    }
    
    struct zPositions {
    static let hud : CGFloat = 10
    static let bill : CGFloat = 4
    static let virus  : CGFloat = -1 //child zPos is additive to parent node,virus with -1 is 3 on the global zPos scale
    static let computer : CGFloat = 1
    static let os : CGFloat = 2
    }
    
    struct PhysicsCategories {
        static let billCategory : UInt32 = 0x1 << 0
        static let computerCategory : UInt32 = 0x1 << 1
    }
}
