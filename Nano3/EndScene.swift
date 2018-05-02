//
//  EndScene.swift
//  Nano3
//
//  Created by Bruno Rocca on 02/05/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import SpriteKit

class EndScene : SKScene{

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let touchNode = atPoint(location!)
        
        if touchNode == childNode(withName: "restart"){
            guard let gameScene = SKScene(fileNamed: "GameScene") else {return}
            gameScene.scaleMode = .aspectFit
            view?.presentScene(gameScene)
        }
    }
}
