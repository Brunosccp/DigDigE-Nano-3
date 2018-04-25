//
//  GameScene.swift
//  Nano3
//
//  Created by Bruno Rocca on 25/04/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import SpriteKit
import GameplayKit

private var note: SKSpriteNode!
private var circle: SKSpriteNode!
private var scoreLabel: SKLabelNode!
private var timesencond = 0

private var noteCategory: UInt32 = 0x1 << 1
private var circleCategory: UInt32 = 0x1 << 2

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        note = childNode(withName: "nota") as! SKSpriteNode
        circle = childNode(withName: "circulo") as! SKSpriteNode
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -1000, y: 0))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 60)
        note.run(move)
        print("to aqui")
        
        self.physicsWorld.contactDelegate = self
    }
    
    
}
extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        if(bodyA == noteCategory || bodyB == noteCategory){
            print("BATEU VIADO")
        }
        if(bodyA == circleCategory || bodyB == circleCategory){
            print("BATEU VIADO")
        }
    }
    
    
}
