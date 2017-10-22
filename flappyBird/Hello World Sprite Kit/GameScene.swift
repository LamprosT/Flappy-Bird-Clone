//
//  GameScene.swift
//  Hello World Sprite Kit
//
//  Created by Lambros Tzanetos on 25/08/16.
//  Copyright © 2016 Mogul Asterovska. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var backGround = SKSpriteNode()
    
    
    var scoreLable = SKLabelNode()
    var score = 0
    
    var gameOverLabel = SKLabelNode()
    
    var timer = Timer()
    
    enum ColliderType: UInt32 {
        
        case bird = 1
        
        case object = 2
        
        case gap = 4
        
        // If we had more we would double them eg. next would be 4
        
    }
    
    var gameOver = false
    
    
    func makePipes() {
        
        
        ////
        
        
        let gapHeight = bird.size.height * 4
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        
        let pipeOffSet = CGFloat(movementAmount) - self.frame.height / 4
        
        let animatePipe = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        
        let removePipes = SKAction.removeFromParent()
        
        let moveAndRemovePipes = SKAction.sequence([animatePipe, removePipes])
        
        
        
        ///
        
        
        
        //pipe1
        
        let pipe1Texture = SKTexture(imageNamed: "pipe1.png")
        
        let pipe1Sprite = SKSpriteNode(texture: pipe1Texture)
        
        pipe1Sprite.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipe1Texture.size().height / 2 + gapHeight / 2 + pipeOffSet)
        
        pipe1Sprite.run(moveAndRemovePipes)
        
        pipe1Sprite.physicsBody = SKPhysicsBody(rectangleOf: pipe1Texture.size())
        
        pipe1Sprite.physicsBody!.isDynamic = false
        
        pipe1Sprite.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        
        pipe1Sprite.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        
        pipe1Sprite.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        pipe1Sprite.zPosition = -1
        
        self.addChild(pipe1Sprite)
        
        
        
        
        
        //pipe2
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        
        let pipe2Sprite = SKSpriteNode(texture: pipe2Texture)
        
        pipe2Sprite.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipe2Texture.size().height / 2 - gapHeight / 2 + pipeOffSet)
        
        pipe2Sprite.run(moveAndRemovePipes)
        
        pipe2Sprite.physicsBody = SKPhysicsBody(rectangleOf: pipe2Texture.size())
        
        pipe2Sprite.physicsBody!.isDynamic = false

        pipe2Sprite.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        
        pipe2Sprite.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        
        pipe2Sprite.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        pipe2Sprite.zPosition = -1
        
        self.addChild(pipe2Sprite)
        
        
        
        //Gap
    
        let gap = SKNode()
        
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffSet)
     
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1Texture.size().width, height:  gapHeight))
    
        gap.physicsBody!.isDynamic = false
        
        gap.run(moveAndRemovePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.bird.rawValue
        
        gap.physicsBody!.categoryBitMask = ColliderType.gap.rawValue
        
        gap.physicsBody!.collisionBitMask = ColliderType.gap.rawValue
        
        self.addChild(gap)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
        
            if contact.bodyA.categoryBitMask == ColliderType.gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.gap.rawValue {
                
                print("Add 1 to Score")
            
                score += 1
            
                scoreLable.text = String(score)
            
        }
        
        else {
            print("We have Contact")
        
            self.speed = 0
        
            gameOver = true
            
            timer.invalidate()
            
            gameOverLabel.fontName = "Helvetica"
            
            gameOverLabel.fontSize = 50
            
            gameOverLabel.text = "Game Over! Tap to play again!"
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
            
        }
        }
    }

    
    
    
    
    
    override func didMove(to view: SKView) { //like viewDidLoad
    
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
         }
    
    
    func setupGame() {
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true) // since we wont change it we use _ instead of a name
        
        //backGround
        
        let backGroundTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -backGroundTexture.size().width, dy: 0), duration: 5)
        
        let shiftBackGroundAnimation = SKAction.move(by: CGVector(dx: backGroundTexture.size().width, dy: 0), duration: 0)
        
        let infiniteBGMove = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBackGroundAnimation] ))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            backGround = SKSpriteNode(texture: backGroundTexture)
            
            backGround.position = CGPoint(x: backGroundTexture.size().width  * i, y: self.frame.midY)
            
            backGround.size.height = self.frame.height
            
            backGround.run(infiniteBGMove)
            
            backGround.zPosition = -2
            
            self.addChild(backGround)
            
            i += 1
        }
        ////
        
        
        
        //bird
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        
        bird.physicsBody!.categoryBitMask = ColliderType.bird.rawValue
        
        bird.physicsBody!.collisionBitMask = ColliderType.bird.rawValue
        
        
        self.addChild(bird)
        
        ////
        
        
        //ground
        
        let ground = SKNode() //invisible ground barrier
        
        ground.position = CGPoint(x:  self.frame.midX, y: -self.frame.height/2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        
        ground.physicsBody!.categoryBitMask = ColliderType.bird.rawValue
        
        ground.physicsBody!.collisionBitMask = ColliderType.bird.rawValue
        
        self.addChild(ground)
        
        
        // Score Label
        
        scoreLable.fontName = "Helvetica"
        
        scoreLable.fontSize = 100
        
        scoreLable.text = "0"
        
        scoreLable.position = CGPoint(x: self.frame.midX, y: self.frame.height/2 - 115)
        
        self.addChild(scoreLable)
        
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //touches
        
        if gameOver == false {
        
            bird.physicsBody!.isDynamic = true
            
            bird.physicsBody!.velocity = (CGVector(dx: 0, dy: 0))
        
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 70))
        
        }
        
        else {
            
            gameOver = false
            
            score = 0
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
            
        }
        
        
        
        
        
        }
    
    
    
    
    
    
    
        
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
