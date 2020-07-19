//
//  GameScene.swift
//  XBill
//
//  Created by Bryan Mansell on 13/07/2020.
//  Copyright © 2020 Bryan Mansell. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreAudio

class GameScene: SKScene {

    enum GameState{
        case ready, ongoing, paused, finished
    }
    
    enum computerState {
        case working, infected
    }
    
    var gameState = GameState.ready
    var bill : Bill!
    var computer : Computer!
    var score = 0
    var matchedBills = Set<Bill>()
    var scoreLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        loadHUD()
        //for _ in 0...6 {
            addComputers()
        //}
        for i in 0...10 {
        addBills(billID: i)
        }
    }
    
    func loadHUD () {
        scoreLabel = SKLabelNode()
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
//        let id = SKLabelNode()
//        id.text = ("\(billID)")
//        id.fontSize = 300
//        id.zPosition = 99
//        id.fontColor = UIColor.red
//        bill.addChild(id)
    }
    
    func addComputers () {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedBill = nodes(at: position).first(where: { $0 is Bill}) as? Bill
            else { return}
        killBill(tappedBill: tappedBill)
    }
    
    func killBill(tappedBill : Bill) {
        
        let randomInt = Int.random(in: 0..<4)
        let deathsound = SKAction.playSoundFileNamed("ahh\(randomInt)", waitForCompletion: false)
        run(deathsound)
        
        //gameState = .finished
        
        let deathAnimation : SKAction!
        deathAnimation = SKAction.animate(with: bill.deadFrames, timePerFrame: 0.1, resize: true, restore: true)
        
        tappedBill.run(deathAnimation) {
            tappedBill.removeFromParent()
            self.score += 5
            
        }
    }
    
    func updateScore () {
        self.scoreLabel.text = "Score : \(score)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateScore()
    }
}
