//
//  SpaceScene.swift
//  PlanetGame
//
//  Created by Kirsten Bauman on 5/5/17.
//  Copyright © 2017 Kirsten Bauman. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class SpaceScene: SKScene, SKPhysicsContactDelegate {
    var menu: MenuScene? = nil
    var contentCreated = false
    var randomSource = GKLinearCongruentialRandomSource.sharedRandom()
    var points = "0"
    let hitSound = SKAction.playSoundFileNamed("smw_coin.wav", waitForCompletion: false)
    let crashSound = SKAction.playSoundFileNamed("Glass_and_Metal_Collision.mp3", waitForCompletion: false)
    var selected: SKNode?
    var health = 10.0
    var activeNode: SKNode?
    var lastPoint = CGPoint(x: 0.0, y: 0.0)
    var magnitude: CGFloat = 100.0
    
    var startTime : Date = Date()
    
    override func didMove(to view: SKView) {
        if contentCreated == false {
            createSceneContents()
            contentCreated = true
        }
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (SpaceScene.updatePoints), userInfo: nil, repeats: true)
        
    }
    
    func updatePoints(){
        let current = Date()
        let timeSinceStartUp = current.timeIntervalSince(startTime)
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .none
        points = numberformatter.string(from: NSNumber(value: timeSinceStartUp))!
    }
    
    func createSceneContents() {
        scaleMode = .aspectFit
        let bGTexture = SKTexture(imageNamed: "background.png")
        let bg = SKSpriteNode(texture: bGTexture)
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.zPosition = 5.0
        bg.size = CGSize(width: frame.width, height: frame.height)
        addChild(bg)
        
        let healthBarBG = SKSpriteNode(color: SKColor.black, size: CGSize(width: 100.0, height: 15.0))
        healthBarBG.position = CGPoint(x: frame.width - 100.0, y: frame.height - 50.0)
        healthBarBG.zPosition = 20.0
        addChild(healthBarBG)
        
        let healthBarFG = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100.0, height: 15.0))
        healthBarFG.position = CGPoint(x: frame.width - 100.0, y: frame.height - 50.0)
        healthBarFG.zPosition = 25.0
        healthBarFG.name = "health"
        addChild(healthBarFG)
        
        let scoreNode = SKLabelNode(fontNamed: "Futura Medium")
        scoreNode.text = "0"
        scoreNode.fontSize = 35.0
        scoreNode.position = CGPoint(x: 20.0, y: size.height - 40.0)
        scoreNode.zPosition = 20.0
        scoreNode.name = "Score"
        scoreNode.horizontalAlignmentMode = .left
        addChild(scoreNode)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        
        createBoundaries()
        createEarth()
        
        let makeRed = SKAction.sequence([
            SKAction.perform(#selector(SpaceScene.createRed), onTarget: self),
            SKAction.wait(forDuration: 2.0, withRange: 0.5)])
        run(SKAction.repeatForever(makeRed))
        
        let makeBlue = SKAction.sequence([
            SKAction.perform(#selector(SpaceScene.createBlue), onTarget: self),
            SKAction.wait(forDuration: 2.0, withRange: 1.0)])
        run(SKAction.repeatForever(makeBlue))
        
        let makeBlue2 = SKAction.sequence([
            SKAction.perform(#selector(SpaceScene.createBlue), onTarget: self),
            SKAction.wait(forDuration: 2.0, withRange: 1.0)])
        run(SKAction.repeatForever(makeBlue2))
        
        let makeYellow = SKAction.sequence([
            SKAction.perform(#selector(SpaceScene.createYellow), onTarget: self),
            SKAction.wait(forDuration: 4.0, withRange: 1.0)])
        run(SKAction.repeatForever(makeYellow))
    }
    
    func createBoundaries() {
        let right = SKSpriteNode(color: SKColor.green, size: CGSize(width: 10, height: frame.height))
        right.position = CGPoint(x: frame.width + 50.0, y: frame.midY)
        right.physicsBody = SKPhysicsBody(rectangleOf: right.size)
        right.physicsBody?.isDynamic = false
        right.name = "side"
        addChild(right)
        
        let left = SKSpriteNode(color: SKColor.green, size: CGSize(width: 10, height: frame.height))
        left.position = CGPoint(x: -50.0, y: frame.midY)
        left.physicsBody = SKPhysicsBody(rectangleOf: left.size)
        left.physicsBody?.isDynamic = false
        left.name = "side"
        addChild(left)
    }
    
    func createEarth(){
        let earthTexture = SKTexture(imageNamed: "earth.png")
        let earth = SKSpriteNode(texture: earthTexture)
        earth.position = CGPoint(x: frame.midX, y: frame.midY)
        earth.zPosition = 10.0
        earth.size = CGSize(width: 50.0, height: 50.0)
        earth.name = "earth"
        earth.physicsBody = SKPhysicsBody(rectangleOf: earth.size)
        earth.physicsBody?.usesPreciseCollisionDetection = true
        earth.physicsBody?.friction = 0.3
        earth.physicsBody?.linearDamping = 0.2
        earth.physicsBody?.restitution = 0.5
        earth.physicsBody?.categoryBitMask = 1
        earth.physicsBody?.collisionBitMask = 1
        earth.physicsBody?.contactTestBitMask = 1
        //earth.physicsBody?.isDynamic = false
        earth.physicsBody?.allowsRotation = false
        addChild(earth)
    }
    
    func createRed() {
        let asteroidTexture = SKTexture(imageNamed: "red-asteroid.png")
        let asteroid = SKSpriteNode(texture: asteroidTexture)
        asteroid.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: frame.height)
        asteroid.zPosition = 15.0
        asteroid.size = CGSize(width: asteroidTexture.size().width / 2.5, height: asteroidTexture.size().height / 2.5)
        asteroid.name = "redAsteroid"
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.usesPreciseCollisionDetection = true
        asteroid.physicsBody?.contactTestBitMask = 1
        asteroid.physicsBody?.isDynamic = true
        addChild(asteroid)
    }

    func createBlue() {
        let asteroidTexture = SKTexture(imageNamed: "blue-asteroid.png")
        let asteroid = SKSpriteNode(texture: asteroidTexture)
        asteroid.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: frame.height)
        asteroid.zPosition = 15.0
        asteroid.size = CGSize(width: asteroidTexture.size().width / 4.0, height: asteroidTexture.size().height / 4.0)
        asteroid.name = "blueAsteroid"
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.usesPreciseCollisionDetection = true
        asteroid.physicsBody?.contactTestBitMask = 1
        asteroid.physicsBody?.isDynamic = true
        addChild(asteroid)
    }
    
    func createYellow() {
        let asteroidTexture = SKTexture(imageNamed: "yellow-asteroid.png")
        let asteroid = SKSpriteNode(texture: asteroidTexture)
        asteroid.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: frame.height)
        asteroid.zPosition = 15.0
        asteroid.size = CGSize(width: asteroidTexture.size().width / 1.5, height: asteroidTexture.size().height / 1.5)
        asteroid.name = "yellowAsteroid"
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.usesPreciseCollisionDetection = true
        asteroid.physicsBody?.contactTestBitMask = 1
        asteroid.physicsBody?.isDynamic = true
        addChild(asteroid)
    }
    
    func removeAsteroid(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let score = childNode(withName: "Score") as! SKLabelNode?{
            score.text = points
        }
        
        if health <= 0.0 {
            menu?.updateHighScore(value: points)
            let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
            view?.presentScene(menu!, transition: open)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        if contact.bodyA.node?.name == "earth" && contact.bodyB.node?.name == "redAsteroid" {
            run(crashSound)
            health -= 2.0
            removeAsteroid(node: childNode(withName: "redAsteroid") as! SKSpriteNode)
            if let healthBar = childNode(withName: "health") as! SKSpriteNode? {
                healthBar.size.width -= 20.0
                healthBar.position.x -= 10.0
            }
        }
        if contact.bodyA.node?.name == "redAsteroid" && contact.bodyB.node?.name == "earth" {
            run(crashSound)
            health -= 2.0
            removeAsteroid(node: childNode(withName: "redAsteroid") as! SKSpriteNode)
            if let healthBar = childNode(withName: "health") as! SKSpriteNode? {
                healthBar.size.width -= 20.0
                healthBar.position.x -= 10.0
            }
        }
        if contact.bodyA.node?.name == "earth" && contact.bodyB.node?.name == "blueAsteroid" {
            run(crashSound)
            health -= 1.0
            removeAsteroid(node: childNode(withName: "blueAsteroid") as! SKSpriteNode)
            if let healthBar = childNode(withName: "health") as! SKSpriteNode? {
                healthBar.size.width -= 10.0
                healthBar.position.x -= 5.0
            }
        }
        if contact.bodyA.node?.name == "blueAsteroid" && contact.bodyB.node?.name == "earth" {
            run(crashSound)
            health -= 1.0
            removeAsteroid(node: childNode(withName: "blueAsteroid") as! SKSpriteNode)
            if let healthBar = childNode(withName: "health") as! SKSpriteNode? {
                healthBar.size.width -= 10.0
                healthBar.position.x -= 5.0
            }
        }
        if contact.bodyA.node?.name == "earth" && contact.bodyB.node?.name == "yellowAsteroid" {
            run(crashSound)
            health = 0.0
            removeAsteroid(node: childNode(withName: "yellowAsteroid") as! SKSpriteNode)
            if health <= 0 {
                menu?.updateHighScore(value: points)
                let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
                view?.presentScene(menu!, transition: open)
            }
        }
        if contact.bodyA.node?.name == "yellowAsteroid" && contact.bodyB.node?.name == "earth" {
            run(crashSound)
            health = 0.0
            removeAsteroid(node: childNode(withName: "yellowAsteroid") as! SKSpriteNode)
            if health <= 0 {
                menu?.updateHighScore(value: points)
                let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
                view?.presentScene(menu!, transition: open)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let list = nodes(at: location)
            if list.count > 0 {
                activeNode = list[0]
                if activeNode?.name == "button" {
                    
                }
            }
            else {
                
            }
            lastPoint = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let node = activeNode as? SKSpriteNode {
            if let touch = touches.first {
                let location = touch.location(in: self)
                let v = CGVector(dx: (location.x - lastPoint.x) * magnitude, dy: (location.y - lastPoint.y) * magnitude)
                node.physicsBody?.velocity = v
                lastPoint = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeNode = nil
    }

}
