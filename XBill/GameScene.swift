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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var targetArray = [Int]()
    var computerArray = [Computer]()
    
    
//    var resetButton : SKLabelNode!
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
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
        bill.billID = billID
        bill.targetComputerID = targetArray.randomElement()!
        bill.scale(to: CGSize(width: frame.size.width / 20, height: frame.size.height / 20))
        var xSpawn = 0
        var ySpawn = 0
        let minX = Int((view?.scene?.frame.minX)!)
        let maxX = Int((view?.scene?.frame.maxX)!)
        let minY = Int((view?.scene?.frame.minY)!)
        let maxY = Int((view?.scene?.frame.maxY)!)
        
        xSpawn = Int.random(in: minX - 100 ... maxX + 100)
        
        if xSpawn >= minX && xSpawn <= maxX {
            let y = Int.random(in: 1...2)
            if y == 1 {
                ySpawn = Int.random(in: -100...minY)
            } else{
                ySpawn = Int.random(in: maxY...maxY + 100)
            }
        }
        else{
            ySpawn = Int.random(in: minY - 100...maxY+100)
        }

        //print("Bill xSpawn = \(xSpawn), ySpawn = \(ySpawn)")
        bill.position = CGPoint(x: CGFloat(xSpawn), y: CGFloat(ySpawn))
        bill.zPosition = GameConstants.zPositions.bill
        bill.name = GameConstants.StringConstants.billName
        bill.loadTextures()
        bill.state = .walkingLeft
        addChild(self.bill)
        //print("Bill # \(self.bill.billID) created.")
        
        bill.physicsBody = SKPhysicsBody(rectangleOf: bill.size)
        bill.physicsBody?.isDynamic = true
        bill.physicsBody?.allowsRotation = false
        bill.physicsBody?.affectedByGravity = false
        bill.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.billCategory
        bill.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.computerCategory
        bill.physicsBody?.collisionBitMask = GameConstants.PhysicsCategories.computerCategory

        
        let virus = SKSpriteNode(imageNamed: "wingdows")
        virus.anchorPoint = CGPoint(x: 0.5, y: 0)
        virus.zPosition = GameConstants.zPositions.virus
        bill.addChild(virus)
        
        
        targetComputers(billsTarget: bill.targetComputerID)
    
        //TODO: make Bills carry OS label
        //TODO: Bills swap out OS
        //TODO: Bills escape
        //TODO: Spawn bills at random intervals
        //TODO: Spawn addition bills at higher levels.
    }
    
    func addComputers (compID: Int) {
        computer = Computer(imageNamed: "bsdcpu")
        computer.computerID = compID
        computer.name = GameConstants.StringConstants.computerName
        computer.anchorPoint = CGPoint(x: 0.35, y: 0.66)
        computer.scale(to: CGSize(width: 70, height: 70))
        var randomPoint = generateRandomSpawn()
       // print("Computer Spawn Point = \(randomPoint)")
        computer.zPosition = GameConstants.zPositions.computer
        computer.position = randomPoint
        //TODO: Fix for frame overlap rather than CGPoint
        for i in 0..<computerSpawnLocations.count {
            //print("Computer spawn location = \(computerSpawnLocations[i])")
            if computer.frame.contains(computerSpawnLocations[i]) {
               // print("Spawn overlap. Generating new spawn....")
                //computer.position = CGPoint(x: computer.position.x + 140, y: computer.position.y + 140)
                randomPoint = generateRandomSpawn()
                computer.position = CGPoint(x: randomPoint.x + 100, y: randomPoint.y + 100)
                }
            }
        let osType = String(self.computer.computerDictionary.randomElement()!.key)
        let cpuType = String(self.computer.computerDictionary[osType]!)
        computer.texture = SKTexture(imageNamed: cpuType)
        
        computer.physicsBody = SKPhysicsBody(rectangleOf: computer.size)
        computer.physicsBody?.isDynamic = false
        computer.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.computerCategory
        computer.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.billCategory
        //computer.physicsBody?.collisionBitMask = GameConstants.PhysicsCategories.billCategory
        
        addChild(self.computer)
        computerSpawnLocations.append(self.computer.position)
        
        let os = SKSpriteNode(imageNamed: osType)
        //print(os)
        // os.position = CGPoint(x: , y: computer.position.y - 0)
        os.scale(to: CGSize(width: 99, height: 99))
        os.zPosition = GameConstants.zPositions.os
        computer.addChild(os)
        computerArray.append(computer)
        targetArray.append(compID)
       // print("Computer # \(String(describing: self.computer.computerID)) created.")
        
    }
    
    func generateRandomSpawn() -> CGPoint {
        let xComputerSpawn = CGFloat(UInt32(Int.random(in: 200..<Int((view?.scene?.frame.maxX)! - 250))))
        let yComputerSpawn = CGFloat(UInt32(Int.random(in: 200..<Int((view?.scene?.frame.maxY)! - 200))))
        let randomPoint = CGPoint(x: xComputerSpawn, y: yComputerSpawn)
        return randomPoint
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if startButton.contains(location) && gameState == .ready {
                //print("touched button!")
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
    
    func collision(between bill: SKSpriteNode, computer: SKSpriteNode) {
        let targetBill = bill as! Bill
        let computer = computer as! Computer
        
        if targetBill.targetComputerID == computer.computerID{
            print("Bill collided with target computer")
            installVirus(computer: computer)
        } else {
            print("Bill collided with non-target computer")
        }
        //print("Bill Target ID = \(targetBill.targetComputerID)")
//        if object.name == GameConstants.StringConstants.computerName {
//            print ("Bill with target ID \(bill.targetComputerID) touched a computer with compID \(object.computerID)")
//            installVirus(bill: bill as! Bill, computer: object as! Computer)
//        }
        
    }
    
    func installVirus (computer: Computer) {
        let infectionSound = SKAction.playSoundFileNamed("mssound", waitForCompletion: false)
        run(infectionSound)
        }
    
    func killBill(tappedBill : Bill) {
        
       // let randomInt = Int.random(in: 0..<4)
       // let deathsound = SKAction.playSoundFileNamed("ahh\(randomInt)", waitForCompletion: false)
       // run(deathsound)
        
        //gameState = .finished
        
        let deathAnimation : SKAction!
        deathAnimation = SKAction.animate(with: bill.deadFrames, timePerFrame: 0.1, resize: true, restore: true)
        
        tappedBill.run(deathAnimation) {
            tappedBill.removeFromParent()
            self.score += 5
            
        }
    }
    
    func targetComputers (billsTarget: Int) {
        let billsTarget = billsTarget
        //print("Bill's target = \(String(describing: billsTarget))")
        //targetArray.remove(at: billsTarget!)
        let targetPosition = computerArray[billsTarget].position
        let randomTime = Double.random(in: 5...15)
        let movetoTarget = SKAction.move(to: targetPosition, duration: randomTime)
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
            var counter = 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            self.addBills(billID: counter)
            counter += 1
            if counter == 20 {
                timer.invalidate()
            }
        }
          
    }
    //TODO: Network infection
            //Bezier path?
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("Collision detected")
        if contact.bodyA.node?.name == "Bill" {
            let targetBill = contact.bodyA.node as! Bill
            //print(targetBill.targetComputerID)
            let targetComputer = contact.bodyB.node as! Computer
            //print("ComputerID = \(targetComputer.computerID!)")
            collision(between: targetBill, computer: targetComputer)
        }
        else if contact.bodyB.node?.name == "Bill" {
            let targetBill = contact.bodyB.node as! Bill
           //print("target \(targetBill.targetComputerID)")
            let targetComputer = contact.bodyA.node as! Computer
            //print("ComputerID = \(targetComputer.computerID!)")
            collision(between: targetBill, computer: targetComputer)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateScore()
    }
}
