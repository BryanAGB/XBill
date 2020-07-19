//
//  Computer.swift
//  XBill
//
//  Created by Bryan Mansell on 19/07/2020.
//  Copyright © 2020 Bryan Mansell. All rights reserved.
//

import SpriteKit

class Computer : SKSpriteNode {
    
    var computerDictionary = ["apple" : "maccpu", "beos" : "bsdcpu", "bsd" : "bsdcpu", "linux": "os2cpu", "OS/2" : "os2cpu", "redhat" : "suncpu", "sun" : "suncpu", "hurd" : "bsdcpu", "palm" : "palmcpu", "sgi" : "sgicpu", "next" : "nextcpu" ]
    
    var cpuType : String!
    var osType : String!
    
}
