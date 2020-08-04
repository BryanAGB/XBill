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
    var targetArray = [0,1,2,3,4,5,6]
    var computerArray = [Computer]()
    
    
//    var resetButton : SKLabelNode!
    override func didMove(to view: SKView) {
        loadHUD()
    }
    
    func loadHUD () {
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score : \(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.fontSize = 75
        scoreLabel.zPosition = GameConstants.zPositions.hud
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
        
    }
    
    func addBills (billID: Int) {
        bill = Bill(imageNamed: GameConstants.StringConstants.billImageName)
        bill.enemyID = billID
        bill.scale(to: CGSize(width: frame.size.width / 20, height: frame.size.height / 20))
        let xSpawn = UInt32(Int.random(in: 100..<Int((view?.scene?.frame.maxX)! - 250)))
        let ySpawn = UInt32(Int.random(in: 100..<Int((view?.scene?.frame.maxY)! - 100)))
        print("Bill xSpawn = \(xSpawn), ySpawn = \(ySpawn)")
        bill.position = CGPoint(x: CGFloat(xSpawn), y: CGFloat(ySpawn))
        bill.zPosition = GameConstants.zPositions.bill
        //bill.position = CGPoint(x: frame.midX, y: frame.midY)
        bill.name = GameConstants.StringConstants.billName
        bill.loadTextures()
        bill.state = .walkingLeft
        addChild(self.bill)
        print("Bill # \(self.bill.enemyID) created.")
        
        let virus = SKSpriteNode(imageNamed: "wingdows")
        virus.anchorPoint = CGPoint(x: 0.5, y: 0)
        virus.zPosition = GameConstants.zPositions.virus
        bill.addChild(virus)
        
        
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
        computer.anchorPoint = CGPoint(x: 0.35, y: 0.66)
        computer.scale(to: CGSize(width: 70, height: 70))
        var randomPoint = generateRandomSpawn()
        print("Computer Spawn Point = \(randomPoint)")
        computer.zPosition = GameConstants.zPositions.computer
        computer.position = randomPoint
        //TODO: Fix for frame overlap rather than CGPoint
        for i in 0..<computerSpawnLocations.count {
            //print("Computer spawn location = \(computerSpawnLocations[i])")
            if computer.frame.contains(computerSpawnLocations[i]) {
                print("Spawn overlap. Generating new spawn....")
                //computer.position = CGPoint(x: computer.position.x + 140, y: computer.position.y + 140)
                randomPoint = generateRandomSpawn()
                computer.position = CGPoint(x: randomPoint.x + 100, y: randomPoint.y + 100)
                }
            }
        let osType = String(self.computer.computerDictionary.randomElement()!.key)
        let cpuType = String(self.computer.computerDictionary[osType]!)
        computer.texture = SKTexture(imageNamed: cpuType)
        addChild(self.computer)
        computerSpawnLocations.append(self.computer.position)
        
        var os = SKSpriteNode(imageNamed: osType)
        // os.position = CGPoint(x: , y: computer.position.y - 0)
        os.scale(to: CGSize(width: 99, height: 99))
        os.zPosition = GameConstants.zPositions.os
        computer.addChild(os)
        computerArray.append(computer)
        print("Computer # \(String(describing: self.computer.computerID)) created.")
        
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if startButton.contains(location) && gameState == .ready {
                print("touched button!")
                startButton.removeFromParent()
                gameState = .ongoing
                gameLoop()
            }
        }
        
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedBill = nodes(at: position).first(where: { $0 is Bill}) as? Bill
            else { return}
        self.killBill(tappedBill: tappedBill)
    }
    
    func installVirus () {
        //TODO: Animate OS swapover
        
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
        let billsTarget = targetArray.randomElement()
        print("Bill's target = \(billsTarget)")
        //targetArray.remove(at: billsTarget!)
        let targetPosition = computerArray[billsTarget!].position
        let movetoTarget = SKAction.move(to: targetPosition, duration: 10)
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
