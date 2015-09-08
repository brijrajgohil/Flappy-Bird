//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Beetu on 9/8/15.
//  Copyright (c) 2015 Brijrajsinh Gohil. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var score = 0
    var scorelabel = SKLabelNode()
    var gameoverlabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var labelholder = SKSpriteNode()
    
    let birdgroup: UInt32 = 1
    let objectgroup: UInt32 = 2
    let gapgroup: UInt32 = 0 << 3
    
    var gameover = 0
    var movingobjects = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        self.addChild(movingobjects)
        
        makeBackground()
        
        self.addChild(labelholder)
        
        scorelabel.fontName = "Helvetica"
        scorelabel.fontSize  = 60
        scorelabel.text = "0"
        scorelabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        
        self.addChild(scorelabel)
        
        let birdtexture = SKTexture(imageNamed: "img/flappy.png")
        let birdtexture2 = SKTexture(imageNamed:  "img/flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdtexture, birdtexture2], timePerFrame: 0.1)
        let makebirdflap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdtexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makebirdflap)
        bird.size.height = 20
        bird.physicsBody = SKPhysicsBody(circleOfRadius: self.bird.size.height/2)
        
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdgroup
        bird.physicsBody?.contactTestBitMask = objectgroup
        bird.physicsBody?.collisionBitMask = gapgroup
        bird.zPosition = 10
        self.addChild(bird)
        
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.categoryBitMask = objectgroup
        self.addChild(ground)
        
        var timer = NSTimer(timeInterval: 3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
       
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameover == 0 {
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
            
        }
        else {
            score = 0
            scorelabel.text = "0"
            movingobjects.removeAllChildren()
            makeBackground()
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            labelholder.removeAllChildren()
            gameover = 0
            movingobjects.speed = 1
        }
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func makeBackground() {
        
        let bgtexture = SKTexture(imageNamed: "img/bng.png")
        let movebg = SKAction.moveByX(-bgtexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveByX(bgtexture.size().width, y: 0, duration: 0)
        let movebgforever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        for var i: CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgtexture)
            bg.position = CGPoint(x: bgtexture.size().width/2 + bgtexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(movebgforever)
            movingobjects.addChild(bg)
        }
        
    }
    
    
    func makePipes() {
        if gameover == 0 {
            let gapheight = bird.size.height * 4
            let movementAmount = arc4random() % UInt32(self.frame.height/2)
            let pipeoffset = CGFloat(movementAmount) - self.frame.height/4
            let movepipes = SKAction.moveByX(-self.frame.size.width, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
            let removepipes = SKAction.removeFromParent()
            
            let moveandremovepipes = SKAction.sequence([movepipes, removepipes])
            
            var tunnel1 = SKSpriteNode()
            var tunnel2 = SKSpriteNode()
            let pipetexture = SKTexture(imageNamed: "img/pipe1.png")
            let pipe2texture = SKTexture(imageNamed: "img/pipe2.png")
            
            tunnel1.runAction(moveandremovepipes)
            tunnel1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + tunnel1.size.height/2 + gapheight/2 + pipeoffset)
            tunnel1.physicsBody = SKPhysicsBody(rectangleOfSize: tunnel1.size)
            tunnel1.physicsBody?.dynamic = false
            tunnel1.physicsBody?.allowsRotation = false
            tunnel1.physicsBody?.categoryBitMask = objectgroup
            movingobjects.addChild(tunnel1)
            
            
            tunnel2.runAction(moveandremovepipes)
            tunnel2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + tunnel1.size.height/2 + gapheight/2 + pipeoffset)
            tunnel2.physicsBody = SKPhysicsBody(rectangleOfSize: tunnel2.size)
            tunnel2.physicsBody?.dynamic = false
            tunnel2.physicsBody?.allowsRotation = false
            tunnel2.physicsBody?.categoryBitMask = objectgroup
            movingobjects.addChild(tunnel2)
            
            let gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeoffset)
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(tunnel1.size.width, gapheight))
            gap.runAction(moveandremovepipes)
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.allowsRotation = false
            gap.physicsBody?.categoryBitMask = gapgroup
            gap.physicsBody?.collisionBitMask = gapgroup
            gap.physicsBody?.contactTestBitMask = birdgroup
            movingobjects.addChild(gap)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == gapgroup || contact.bodyB.categoryBitMask == gapgroup {
            score++
            scorelabel.text = "\(score)"
        }
        else {
            if gameover == 0 {
                gameover = 1
                movingobjects.speed = 0
                gameoverlabel.fontName = "Helvetica"
                gameoverlabel.text = "Game Over! Tap to play again"
                gameoverlabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelholder.addChild(gameoverlabel)
            }
        }
    }
    
    
    
    
    
    
    
}
