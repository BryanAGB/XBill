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
    var startButton : SKSpriteNode!
    var targetComputer : Computer!
    var spawnTimer: Timer?
    var computerSpawnLocations = [CGPoint]()
    
    
//    var resetButton : SKLabelNode!
    override func didMove(to view: SKView) {
        loadHUD()
    }
    
    func loadHUD () {
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score : \(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.fontSize = 75
        addChild(scoreLabel)
        
        startButton = SKSpriteNode()
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startButton)
        
        let startButtonLabel = SKLabelNode()
        startButtonLabel.text = "Start Game!"
        startButtonLabel.fontSize = 75
        startButton.addChild(startButtonLabel)
        
//        resetButton = SKLabelNode()
//        resetButton.text = "Reset"
//        resetButton.position = CGPoint(x: frame.midX, y: frame.minY + 75)
//        resetButton.fontSize = 75
//        addChild(resetButton)
        
        
        //TODO: Game Menu
        //TODO: Highscore table & name input
        //TODO:
        
    }
    
    func addBills (billID: Int) {
        bill = Bill(imageNamed: GameConstants.StringConstants.billImageName)
        bill.enemyID = billID
        bill.scale(to: CGSize(width: frame.size.width / 20, height: frame.size.height / 20))
        let xSpawn = UInt32(Int.random(in: 100..<Int((view?.scene?.frame.maxX)! - 250)))
        let ySpawn = UInt32(Int.random(in: 100..<Int((view?.scene?.frame.maxY)! - 100)))
        print("Bill xSpawn = \(xSpawn), ySpawn = \(ySpawn)")
        bill.position = CGPoint(x: CGFloat(xSpawn), y: CGFloat(ySpawn))
        
        //bill.position = CGPoint(x: frame.midX, y: frame.midY)
        bill.name = GameConstants.StringConstants.billName
        bill.loadTextures()
        bill.state = .walkingLeft
        bill.zPosition = 1
        addChild(self.bill)
        print("Bill # \(self.bill.enemyID) created.")
        targetComputers()
    
        //TODO: make Bills carry OS label
        //TODO: Bills swap out OS
        //TODO: Bills escape
        
        
//        let id = SKLabelNode()
//        id.text = ("\(billID)")
//        id.fontSize = 300
//        id.zPosition = 99
//        id.fontColor = UIColor.red
//        bill.addChild(id)
    }
    
    func generateRandomSpawn() -> CGPoint {
        let xComputerSpawn = CGFloat(UInt32(Int.random(in: 200..<Int((view?.scene?.frame.maxX)! - 250))))
        let yComputerSpawn = CGFloat(UInt32(Int.random(in: 200..<Int((view?.scene?.frame.maxY)! - 200))))
        let randomPoint = CGPoint(x: xComputerSpawn, y: yComputerSpawn)
        return randomPoint
    }
    
    func addComputers (compID: Int) {
        computer = Computer(imageNamed: "bsdcpu")
        computer.computerID = compID
        computer.name = GameConstants.StringConstants.computerName
        computer.scale(to: CGSize(width: 70, height: 70))
        var randomPoint = generateRandomSpawn()
        print("Computer Spawn Point = \(randomPoint)")
        computer.position = randomPoint
        
        for i in 0..<computerSpawnLocations.count {
            print("Computer spawn location = \(computerSpawnLocations[i])")
            if computer.frame.contains(computerSpawnLocations[i]) {
                print("Spawn overlap. Generating new spawn....")
                //computer.position = CGPoint(x: computer.position.x + 140, y: computer.position.y + 140)
                randomPoint = generateRandomSpawn()
                computer.position = randomPoint
                }
            }
        let osType = String(self.computer.computerDictionary.randomElement()!.key)
        let cpuType = String(self.computer.computerDictionary[osType]!)
        computer.texture = SKTexture(imageNamed: cpuType)
        addChild(self.computer)
        computerSpawnLocations.append(self.computer.position)
        print("Computer # \(String(describing: self.computer.computerID)) created.")
        
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if startButton.contains(location) {
                print("touched button!")
                startButton.removeFromParent()
                gameLoop()
            }
        }
        
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedBill = nodes(at: position).first(where: { $0 is Bill}) as? Bill
            else { return}
        self.killBill(tappedBill: tappedBill)
    }
    
    func killBill(tappedBill : Bill) {
        
        let randomInt = Int.random(in: 0..<4)
       // let deathsound = SKAction.playSoundFileNamed("ahh\(randomInt)", waitForCompletion: false)
        //run(deathsound)
        
        //gameState = .finished
        
        let deathAnimation : SKAction!
        deathAnimation = SKAction.animate(with: bill.deadFrames, timePerFrame: 0.1, resize: true, restore: true)
        
        tappedBill.run(deathAnimation) {
            tappedBill.removeFromParent()
            self.score += 5
            
        }
    }
    
    func targetComputers () {
      
        let movetoTarget = SKAction.move(to: computer.position, duration: 10)
        bill.run(movetoTarget)
    }
    
    func updateScore () {
        self.scoreLabel.text = "Score : \(score)"
    }
    
    //TODO: Game logic
    
    func gameLoop () {
        for i in 0...6 {
            addComputers(compID: i)
        }
        for i in 0...10 {
        addBills(billID: i)
        }
    }
    //TODO: Network infection
            //Bezier path?
    

    
    override func update(_ currentTime: TimeInterval) {
        updateScore()
    }
}
