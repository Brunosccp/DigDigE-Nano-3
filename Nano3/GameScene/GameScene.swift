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

private var currentNote : [(SKNode, Bool)] = []

private var score: Int = 0
private var multiplier: Int = 1
private var multiplierCounter = 0

private var scoreLabel: SKLabelNode!
private var multiplierLabel: SKLabelNode!

private var noteCategory: UInt32 = 0x1 << 1
private var rightCategory: UInt32 = 0x1 << 3
private var wrongCategory: UInt32 = 0x1 << 4

private var path = UIBezierPath()


class GameScene: SKScene {
    override func didMove(to view: SKView) {
        //mudando cor de fundo
        self.backgroundColor = hexStringToUIColor(hex: "#ecc21b")
        
        
        //pegando as settings definidas no Gamescene
        pandeiro = childNode(withName: "pandeiro") as! SKSpriteNode
        rightTrigger = childNode(withName: "rightTrigger") as! SKSpriteNode
        wrongTrigger = childNode(withName: "wrongTrigger") as! SKSpriteNode
        scoreLabel = childNode(withName: "score") as! SKLabelNode
        
        //criando o caminho da bola caminhante
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -1000, y: 0))
        
        
        //settando labels
        scoreLabel.text = "\(score)"
        
        //ligando os sprites com as categorias de colisão
        rightTrigger.physicsBody?.categoryBitMask = rightCategory
        wrongTrigger.physicsBody?.categoryBitMask = wrongCategory
        
        rightTrigger.physicsBody?.contactTestBitMask = noteCategory
        wrongTrigger.physicsBody?.contactTestBitMask = noteCategory
        
        rightTrigger.physicsBody?.collisionBitMask = 0
        wrongTrigger.physicsBody?.collisionBitMask = 0
        
        self.physicsWorld.contactDelegate = self
        
        //começa musica
        startMusic()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        //verificando se o toque está certo ou não
        if(pandeiro.contains(touch.location(in: self))){
            let t  = currentNote.first
            if(t != nil && t!.1 == true){  //caso esteja correto
                print("CORRECT")
                t!.0.removeFromParent()
                currentNote.removeFirst()
                
                updateMultiplier(rightNote: true)
                score += 50 * multiplier
                scoreLabel.text = "\(score)"
                
            }else{  //caso não esteja correto
                print("WRONG")
                updateMultiplier(rightNote: false)
            }
        }
    }
    
    func startMusic(){
        var int : Double = 1
        
        createNote(interval: 1, type: "note1", &int)
        createNote(interval: 0.5, type: "note1", &int)
        createNote(interval: 1, type: "note1", &int)
        createNote(interval: 0.25, type: "note1", &int)
        createNote(interval: 0.25, type: "note1", &int)
        createNote(interval: 0.25, type: "note1", &int)
        
        
        //mostrando tela final
        int += 10
        Timer.scheduledTimer(timeInterval: int, target: self, selector: #selector(showEndScene), userInfo: nil, repeats: false)
    }
    func createNote(interval: Double, type: String,_ int: inout Double){
        var timer = Timer()
        int += interval

        timer = Timer.scheduledTimer(timeInterval: int, target: self, selector: #selector(showNote), userInfo: type, repeats: false)
    }
    @objc func showNote(sender: Timer){
        
        let note1 : SKSpriteNode = SKSpriteNode(imageNamed: "nota1")
        note1.name = sender.userInfo! as! String
        note1.size = CGSize(width: 64, height: 64)
        note1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        note1.position = CGPoint(x: 370, y: 37)
        note1.zPosition = 0
        
        note1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: note1.size.width, height: note1.size.height))
        note1.physicsBody?.categoryBitMask = noteCategory
        note1.physicsBody?.collisionBitMask = 0
        note1.physicsBody?.isDynamic = true
        note1.physicsBody?.affectedByGravity = false
        note1.physicsBody?.pinned = false
        
        //ligando a movimentação da nota caminhante com o caminho
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 180)
        note1.run(move)
        
        self.addChild(note1)
        //print(note1.name)
        
        self.physicsWorld.contactDelegate = self
    }
    func updateMultiplier(rightNote: Bool){
        if(rightNote == true){  //a nota tocada foi correta
            if(multiplierCounter < 9){  //se não está na hora de incrementar o multiplier
                multiplierCounter += 1
            }
            else{   //se está na hora de incrementar o multiplayer
                if(multiplier < 4){ //caso o multiplier já não esteja em 4 (o mult máximo no caso)
                    multiplier += 1
                    multiplierCounter = 0
                }
                else{return}
            }
        }
        else{   //a nota tocada nao foi correta
            multiplier = 1
            multiplierCounter = 0
        }
    }
    @objc func showEndScene(){
        guard let endScene = SKScene(fileNamed: "EndScene") else{return}
        endScene.scaleMode = .aspectFit
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(endScene, transition: reveal)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        //retirei da internet pronto
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA.categoryBitMask
        
        if(bodyA == rightCategory){ //quando a bola bate no primeiro retangulo invisivel
            currentNote.append((contact.bodyB.node!, true))
        }
        if(bodyA == wrongCategory){ //quando a bola bate no segundo retangulo invisivel
            currentNote.removeFirst()
            updateMultiplier(rightNote: false)
        }
    }
}
