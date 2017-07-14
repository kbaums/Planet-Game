//
//  MenuScene.swift
//  PlanetGame
//
//  Created by Kirsten Bauman on 5/5/17.
//  Copyright © 2017 Kirsten Bauman. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var highScore = 0
    var contentsCreated = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        if contentsCreated == false {
            createSceneContents()
            contentsCreated = true
        }
        
    }
    
    func createSceneContents() {
        let label = SKLabelNode(fontNamed: "Futura Medium")
        label.text = "Save Earth!"
        label.fontSize = 45
        label.fontColor = SKColor.white
        label.position = CGPoint(x: frame.midX, y: frame.midY - 40.0)
        addChild(label)
        
        let highScoreNode = SKLabelNode(fontNamed: "Futura Medium")
        highScoreNode.text = "High Score: \(highScore)"
        highScoreNode.fontSize = 30.0
        highScoreNode.position = CGPoint(x: frame.midX, y: frame.midY + 40.0)
        highScoreNode.name = "HighScore"
        addChild(highScoreNode)
    }
    
    func updateHighScore(value: String) {
        let intValue = (value as NSString).integerValue
        if intValue > highScore {
            highScore = intValue
            if let node = childNode(withName: "HighScore") as! SKLabelNode? {
                node.text = "HighScore: \(highScore)"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // A touch anywhere in this scene will cause a transition to GameScene
        
        let game = SpaceScene(size: size)
        game.menu = self
        let doors = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
        view?.presentScene(game, transition: doors)
        
    }
}

