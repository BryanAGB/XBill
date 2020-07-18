//
//  GameScene.swift
//  XBill
//
//  Created by Bryan Mansell on 13/07/2020.
//  Copyright © 2020 Bryan Mansell. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    enum GameState{
        case ready, ongoing, paused, finished
    }
    
    enum computerState {
        case working, infected
    }
    
    var gameState = GameState.ready
    var bill: Bill!
    var score = 0
    
    
    override func didMove(to view: SKView) {
        loadHUD()
        addBills()
    }
    
    func loadHUD () {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "Score : \(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.color = UIColor.red
        scoreLabel.fontSize = 75
        addChild(scoreLabel)
    }
    
    func generateComputers () {
        
        
    }
    
    func addBills () {
        bill = Bill(imageNamed: GameConstants.StringConstants.billImageName)
        bill.scale(to: CGSize(width: frame.size.width / 20, height: frame.size.height / 20))
        bill.position = CGPoint(x: frame.midX, y: frame.midY)
        bill.name = GameConstants.StringConstants.billName
        bill.loadTextures()
        bill.state = .walkingLeft
        self.addChild(bill)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if bill.contains(location) {
                killBill(reason: 0)
            }
        }
    }
    
    func killBill(reason: Int) {
       // run(soundPlayer.deathSound)
        gameState = .finished
        let deathAnimation : SKAction!
        
        switch reason {
        case 0 :
            deathAnimation = SKAction.animate(with: bill.deadFrames, timePerFrame: 0.1, resize: true, restore: true)
        default :
            deathAnimation = SKAction.animate(with: bill.deadFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        
        bill.run(deathAnimation) {
            self.bill.removeFromParent()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
