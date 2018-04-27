//
//  GameScene.swift
//  Nano3
//
//  Created by Bruno Rocca on 25/04/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import SpriteKit
import GameplayKit

private var circle: SKSpriteNode!
private var pandeiro: SKSpriteNode!
private var rightTrigger: SKSpriteNode!
private var wrongTrigger: SKSpriteNode!

private var isCorrect = false
private var deleteBall = false

private var scoreLabel: SKLabelNode!
private var timesencond = 0

private var noteCategory: UInt32 = 0x1 << 1
private var rightCategory: UInt32 = 0x1 << 3
private var wrongCategory: UInt32 = 0x1 << 4

private var path = UIBezierPath()


class GameScene: SKScene {
    override func didMove(to view: SKView) {
        //pegando as settings definidas no Gamescene
        pandeiro = childNode(withName: "pandeiro") as! SKSpriteNode
        rightTrigger = childNode(withName: "rightTrigger") as! SKSpriteNode
        wrongTrigger = childNode(withName: "wrongTrigger") as! SKSpriteNode
        
        //criando o caminho da bola caminhante
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -1000, y: 0))
        
        //ligando os sprites com as categorias de colisão
        rightTrigger.physicsBody?.categoryBitMask = rightCategory
        wrongTrigger.physicsBody?.categoryBitMask = wrongCategory
        
        rightTrigger.physicsBody?.contactTestBitMask = noteCategory
        wrongTrigger.physicsBody?.contactTestBitMask = noteCategory
        
        rightTrigger.physicsBody?.collisionBitMask = 0
        wrongTrigger.physicsBody?.collisionBitMask = 0
        
        
        
        //ligando a movimentação da bola caminhante com o caminho
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 180)
        
        startMusic()
        
        self.physicsWorld.contactDelegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        //verificando se o toque está certo ou não
        if(pandeiro.contains(touch.location(in: self))){
            if(isCorrect == true){  //caso esteja correto
                print("CORRECT")
                isCorrect = false
                deleteBall = true
                
                
            }else{  //caso não esteja correto
                print("WRONG")
            }
        }
    }
    
    func startMusic(){
        var int : Double = 0
        
        
        int += 1
        createNote(interval: int, type: "note1")
        int += 0.5
        createNote(interval: int, type: "note1")
        int += 1
        createNote(interval: int, type: "note1")
        int += 0.25
        createNote(interval: int, type: "note1")
        int += 0.25
        createNote(interval: int, type: "note1")
        int += 0.25
        createNote(interval: int, type: "note1")
        
    }
    func createNote(interval: Double, type: String){
        var timer = Timer()
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(showNote), userInfo: type, repeats: false)
    }
    
    @objc func showNote(sender: Timer){
        
        let note1 : SKSpriteNode = SKSpriteNode(imageNamed: "png_bolafut")
        note1.name = sender.userInfo! as! String
        note1.size = CGSize(width: 108.308, height: 108.308)
        note1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        note1.position = CGPoint(x: 175.937, y: 81.713)
        note1.zPosition = 0
        
        note1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: note1.size.width, height: note1.size.height))
        note1.physicsBody?.categoryBitMask = noteCategory
        note1.physicsBody?.collisionBitMask = 0
        note1.physicsBody?.isDynamic = true
        note1.physicsBody?.affectedByGravity = false
        note1.physicsBody?.pinned = false
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 180)
        note1.run(move)
        
        self.addChild(note1)
        //print(note1.name)
        
        self.physicsWorld.contactDelegate = self
    }
}
extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        if(bodyA == rightCategory){
            isCorrect = true
        }
        if(bodyA == wrongCategory){
            if(deleteBall == true){ //checando se foi acertado e, se sim, apagando a bola
                contact.bodyB.node?.removeFromParent()
                deleteBall = false
            }
            isCorrect = false
            
        }
    }
}
