//
//  Bill.swift
//  XBill
//
//  Created by Bryan Mansell on 13/07/2020.
//  Copyright © 2020 Bryan Mansell. All rights reserved.
//

import SpriteKit

enum BillState {
    case walkingLeft, walkingRight, swapping, dead
}

class Bill: SKSpriteNode {
    
    var walkingLeftFrames = [SKTexture]()
    var walkingRightFrames = [SKTexture]()
    var swappingFrames = [SKTexture]()
    var deadFrames = [SKTexture]()
    
    var billID = 0
    var targetComputerID = 0
    
    var state = BillState.walkingLeft{
        willSet{
            animate(for: newValue)
        }
    }
        
    func loadTextures() {
            
            walkingLeftFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.billLeftAtlas), withName: GameConstants.StringConstants.leftPrefixKey)
            
            walkingRightFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.billRightAtlas), withName: GameConstants.StringConstants.rightPrefixKey)
        
            swappingFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.billSwapAtlas), withName: GameConstants.StringConstants.swapPrefixKey)
            
            deadFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.billDieAtlas), withName: GameConstants.StringConstants.diePrefixKey)
        }
        
     func animate(for state: BillState) {
            removeAllActions()
            switch state {
            case .walkingLeft:
                self.run(SKAction.repeatForever(SKAction.animate(with: walkingLeftFrames, timePerFrame: 0.05, resize: true, restore: true)))
            case .walkingRight:
                self.run(SKAction.repeatForever(SKAction.animate(with: walkingRightFrames, timePerFrame: 0.05, resize: true, restore: true)))
            case .swapping:
                self.run(SKAction.repeatForever(SKAction.animate(with: swappingFrames, timePerFrame: 0.05, resize: true, restore: true)))
            case .dead:
                self.run(SKAction.repeatForever(SKAction.animate(with: deadFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }

}
