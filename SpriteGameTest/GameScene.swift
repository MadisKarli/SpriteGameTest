//
//  GameScene.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 10/08/16.
//  Copyright (c) 2016 Papple Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    // MARK: Properties
    
    
    let bulletCategory:UInt32 = 0x1 << 1
    let bodyCategory:UInt32 = 0x1 << 0
    
    var juku:SKSpriteNode = SKSpriteNode()
    var bodyPart:SKSpriteNode = SKSpriteNode()
    
    var bullet:SKSpriteNode = SKSpriteNode()
    var litter:SKSpriteNode = SKSpriteNode()
    var deleteOnTouch = [SKSpriteNode]()
    var targetPosition = CGPoint()
    
    var touchedPartLabel = SKLabelNode()
    var touchedParts = Set<String>()
    
    override func didMoveToView(view: SKView) {
        touchedPartLabel.text = "Touched bodypart: "
        touchedPartLabel.fontSize = 12
        touchedPartLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 20)
        
        self.addChild(touchedPartLabel)
    }
    
    override init(size:CGSize){
        super.init(size:size)
        //self.backgroundColor = SKColor.yellowColor()
        
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        self.physicsWorld.contactDelegate = self
        
        juku = SKSpriteNode(imageNamed: "juku")
        juku.name = "Juku"
        
        juku.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        juku.physicsBody = SKPhysicsBody(texture: juku.texture!, size: (juku.texture!.size()))
        
        juku.physicsBody?.dynamic = true
        juku.physicsBody?.categoryBitMask = bodyCategory
        juku.physicsBody?.contactTestBitMask = bulletCategory
        juku.physicsBody?.collisionBitMask = 0
        self.addChild(juku)
        
        
    

        createBodyPart("jukuParemKasi")
        createBodyPart("jukuParemKasiSormed")
        createBodyPart("jukuParemKasiKeskmineSorm")
        createBodyPart("jukuPea")
        
        //loome litri, mida saab ringi lohistada
        litter = SKSpriteNode(imageNamed: "litter")
        litter.name = "litter"
        litter.position = CGPointMake(255, 344)
        litter.physicsBody = SKPhysicsBody(texture: litter.texture!, size: (litter.texture!.size()))
        
        litter.physicsBody?.dynamic = true
        litter.physicsBody?.categoryBitMask = bulletCategory
        litter.physicsBody?.contactTestBitMask = bodyCategory
        litter.physicsBody?.collisionBitMask = 0
        //litter.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(litter)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setTouchedLabel(){
        var new:String = "Touched body parts: "
        
        for bodyPart in touchedParts{
            new += bodyPart
            new += "\n"
        }
        
        touchedPartLabel.text = new
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createBodyPart(name:String) -> SKSpriteNode{
        
        bodyPart = SKSpriteNode(imageNamed: name)
        bodyPart.name = name
        bodyPart.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
        bodyPart.physicsBody = SKPhysicsBody(texture: bodyPart.texture!, size: (bodyPart.texture!.size()))
        
        bodyPart.physicsBody?.dynamic = true
        bodyPart.physicsBody?.categoryBitMask = bodyCategory
        bodyPart.physicsBody?.contactTestBitMask = bulletCategory
        bodyPart.physicsBody?.collisionBitMask = 0
 
        self.addChild(bodyPart)
        return bodyPart
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touchedParts = []
        setTouchedLabel()
        
        for touch in touches {
            //self.removeChildrenInArray(deleteOnTouch)
            let location = touch.locationInNode(self)
            
            print("touch", location.x, location.y)
            //touch creates a "bullet" that is used to specify what was touched
            /*
             bullet = SKSpriteNode(imageNamed: "bullet")
             bullet.name = "lehm"
             bullet.position = CGPointMake(location.x, location.y)
             bullet.physicsBody = SKPhysicsBody(circleOfRadius: 3)
             
             bullet.physicsBody?.dynamic = true
             
             bullet.physicsBody?.categoryBitMask = bulletCategory
             bullet.physicsBody?.contactTestBitMask = bodyCategory
             bullet.physicsBody?.collisionBitMask = 0
             bullet.physicsBody?.usesPreciseCollisionDetection = true
             
             deleteOnTouch.append(bullet)
             self.addChild(bullet)
             */
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
         better - http://stackoverflow.com/questions/21597014/ios-sprite-kit-how-to-make-sprite-follow-touches
         */
        for touch in touches{
            let location = touch.locationInNode(self)
            litter.position = location
            /*
             bullet = SKSpriteNode(imageNamed: "bullet")
             bullet.name = "lehm"
             bullet.position = CGPointMake(location.x, location.y)
             bullet.physicsBody = SKPhysicsBody(circleOfRadius: 3)
             
             bullet.physicsBody?.dynamic = true
             
             bullet.physicsBody?.categoryBitMask = bulletCategory
             bullet.physicsBody?.contactTestBitMask = bodyCategory
             bullet.physicsBody?.collisionBitMask = 0
             bullet.physicsBody?.usesPreciseCollisionDetection = true
             
             deleteOnTouch.append(bullet)
             self.addChild(bullet)
             */
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let touchedPart:String = contact.bodyA.valueForKey("representedObject")?.valueForKey("name") as! String
        print("contact", touchedPart)
        
        
        touchedParts.insert(touchedPart)
        setTouchedLabel()
        
        
        switch touchedPart {
        case "jukuParemKasi":
            deleteOnTouch.append(createBodyPart("jukuVasakJalaLaba"))
        case "jukuParemKasiKeskmineSorm":
            deleteOnTouch.append(createBodyPart("jukuParemJalg"))
        default:
            break
        }
        

    }
    
    func didEndContact(contact: SKPhysicsContact) {
        self.removeChildrenInArray(deleteOnTouch)
        touchedParts = []
        setTouchedLabel()
    }
    

    
}
