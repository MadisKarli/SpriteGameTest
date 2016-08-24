//
//  Puck.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 19/08/16.
//  Copyright © 2016 Papple Inc. All rights reserved.
//

//
//  Bodypart.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 11/08/16.
//  Copyright © 2016 Papple Inc. All rights reserved.c
//

import SpriteKit


class Puck: SKSpriteNode{
    var litterSelected: Bool = false
    
    init?(filename: String){
        let texture = SKTexture(imageNamed: filename)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "litter"
        self.position = CGPoint(x: 25, y: self.size.height - 25)
        
        
        //litter.physicsBody = SKPhysicsBody(texture: litter.texture!, size: (litter.texture!.size()))
        self.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = bulletCategory
        self.physicsBody?.contactTestBitMask = bodyCategory
        self.physicsBody?.collisionBitMask = 0
        //litter.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.locationInNode(self)
            litterSelected = true
            print("litter touch", location.x, location.y, litterSelected )
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
         better - http://stackoverflow.com/questions/21597014/ios-sprite-kit-how-to-make-sprite-follow-touches
         */
        for touch in touches{
            let location = touch.locationInNode(self)
            if(litterSelected){
                self.position = location
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        litterSelected = false
    }
    

 }