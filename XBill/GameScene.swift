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
    var bill : Bill!
    var score = 0
    
    
    override func didMove(to view: SKView) {
        loadHUD()
        for i in 0...10 {
        addBills(billID: i)
        }
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
    
    func addBills (billID: Int) {
        bill = Bill(imageNamed: GameConstants.StringConstants.billImageName)
        bill.enemyID = billID
        bill.scale(to: CGSize(width: frame.size.width / 20, height: frame.size.height / 20))
        let xSpawn = UInt32(Int.random(in: 100..<Int((view?.scene?.frame.maxX)! - 100)))
        let ySpawn = UInt32(Int.random(in: 100..<Int((view?.scene?.frame.maxY)! - 100)))
        print("xSpawn = \(xSpawn), ySpawn = \(ySpawn)")
        bill.position = CGPoint(x: CGFloat(xSpawn), y: CGFloat(ySpawn))
        //bill.position = CGPoint(x: frame.midX, y: frame.midY)
        bill.name = GameConstants.StringConstants.billName
        bill.loadTextures()
        bill.state = .walkingLeft
        bill.zPosition = 1 
        self.addChild(bill)
        print("Bill # \(bill.enemyID) created.")
        let id = SKLabelNode()
        id.text = ("\(billID)")
        id.fontSize = 300
        id.zPosition = 99
        id.fontColor = UIColor.red
        bill.addChild(id)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if bill.contains(location) {
                print("You killed bill #\(bill.enemyID)")
                killBill(billID: bill.enemyID)
            }
        }
    }
    
    func killBill(billID: Int) {
       // run(soundPlayer.deathSound)
        //gameState = .finished
        let deathAnimation : SKAction!
        deathAnimation = SKAction.animate(with: bill.deadFrames, timePerFrame: 0.1, resize: true, restore: true)
        
        bill.run(deathAnimation) {
            self.bill.removeFromParent()
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
