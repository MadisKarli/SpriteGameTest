//
//  Bodypart.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 11/08/16.
//  Copyright © 2016 Papple Inc. All rights reserved.
//

import SpriteKit
let bulletCategory:UInt32 = 0x1 << 1
let bodyCategory:UInt32 = 0x1 << 0

class Bodypart: SKSpriteNode{
    var targets = [String]()
    var childern = [SKSpriteNode]()
    
    init?(filename: String, width:CGFloat, height:CGFloat, jukuSize:CGSize){
        let texture = SKTexture(imageNamed: filename)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        if(filename.hasPrefix("obj_")){
            let nameWithoutPrefix: String = filename.componentsSeparatedByString("obj_")[1]
            self.name = nameWithoutPrefix.componentsSeparatedByString(">")[0]
            
        }else{
            self.name = filename
        }
        self.size = jukuSize
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: (jukuSize))
        self.position = CGPoint(x: width, y: height)
        self.physicsBody = SKPhysicsBody(texture: texture, size: (jukuSize))
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = bodyCategory
        self.physicsBody?.contactTestBitMask = bulletCategory
        self.physicsBody?.collisionBitMask = 0
        
    }
    
    init?(filename: String, targets: [String], width:CGFloat, height:CGFloat, jukuSize: CGSize){
        let texture = SKTexture(imageNamed: filename)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        if(filename.hasPrefix("obj_")){
            let nameWithoutPrefix: String = filename.componentsSeparatedByString("obj_")[1]
            self.name = nameWithoutPrefix.componentsSeparatedByString(">")[0]
            
        }else{
            self.name = filename
        }
        
        self.size = jukuSize
        self.targets = targets
        self.position = CGPoint(x: width, y: height)
        self.physicsBody = SKPhysicsBody(texture: texture, size: jukuSize)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = bodyCategory
        self.physicsBody?.contactTestBitMask = bulletCategory
        self.physicsBody?.collisionBitMask = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            
            
            print("hei", location.x, location.y)
        }
        
    }

    
    func getTargets() -> [String]{
        return targets
    }
    func addChildz(child: SKSpriteNode){
        childern.append(child)
    }
    
    func getChildz() -> [SKSpriteNode]{
        return childern
    }
}