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
private var pandeiro: SKSpriteNode!
private var rightTrigger: SKSpriteNode!
private var wrongTrigger: SKSpriteNode!

private var scoreLabel: SKLabelNode!
private var timesencond = 0

private var noteCategory: UInt32 = 0x1 << 1
private var circleCategory: UInt32 = 0x1 << 2
private var rightCategory: UInt32 = 0x1 << 3
private var wrongCategory: UInt32 = 0x1 << 4

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        //associando as variaveis com o gameScene
        note = childNode(withName: "nota") as! SKSpriteNode
        circle = childNode(withName: "circulo") as! SKSpriteNode
        pandeiro = childNode(withName: "pandeiro") as! SKSpriteNode
        rightTrigger = childNode(withName: "rightTrigger") as! SKSpriteNode
        wrongTrigger = childNode(withName: "wrongTrigger") as! SKSpriteNode
        
        //criando o caminho da bola caminhante
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -1000, y: 0))
        
        //ligando os sprites com as categorias de colisão
        note.physicsBody?.categoryBitMask = noteCategory
        rightTrigger.physicsBody?.categoryBitMask = rightCategory
        wrongTrigger.physicsBody?.categoryBitMask = wrongCategory
        circle.physicsBody?.categoryBitMask = circleCategory
        
        note.physicsBody?.contactTestBitMask = circleCategory | rightCategory | wrongCategory
        
        note.physicsBody?.collisionBitMask = 0
        circle.physicsBody?.collisionBitMask = 0
        rightTrigger.physicsBody?.collisionBitMask = 0
        wrongTrigger.physicsBody?.collisionBitMask = 0
        
        
        
        //ligando a movimentação da bola caminhante com o caminho
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 60)
        note.run(move)
        
        self.physicsWorld.contactDelegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if(pandeiro.contains(touch.location(in: self))){
            print("pandeiro foi tocado")
        }
        
    }
}
extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA.categoryBitMask
        //let bodyB = contact.bodyB.categoryBitMask
        
        if(bodyA == rightCategory){
            print("BATEU NO CERTO")
        }
        if(bodyA == wrongCategory){
            print("BATEU NO ERRADO")
        }
        
    }
    
}
