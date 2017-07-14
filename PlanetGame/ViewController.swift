//
//  ViewController.swift
//  PlanetGame
//
//  Created by Kirsten Bauman on 5/5/17.
//  Copyright © 2017 Kirsten Bauman. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let skView = SKView(frame: view.frame)
        view = skView
        
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

