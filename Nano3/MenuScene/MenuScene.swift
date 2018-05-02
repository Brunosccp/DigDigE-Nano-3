//
//  MenuScene.swift
//  Nano3
//
//  Created by Bruno Rocca on 02/05/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene{
    
    class chooseScene: SKScene {
        
        override func didMove(to: SKView) {
            self.backgroundColor = .white
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let touchNode = atPoint(location!)
        
        if touchNode == childNode(withName: "start"){
            guard let gameScene = SKScene(fileNamed: "GameScene") else {return}
            gameScene.scaleMode = .aspectFit
            view?.presentScene(gameScene)
        }
    }
    
}
