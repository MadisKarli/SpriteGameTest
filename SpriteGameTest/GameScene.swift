//
//  GameScene.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 10/08/16.
//  Copyright (c) 2016 Papple Inc. All rights reserved.
//
/*
 kotid
 bugid:
 pea keskel ei näita collisionit
 collision üldse üsna broken
 
 kiiresti liigutades ei tööta - button to kill children and reset?
 
 optimiseerimine:
 kui laps juba on elus ja järgmisel on ka laps, siis võiks ainult üks sprite olla näiteks sama mis incontact array on
 
 todo:
 pildid xcassetsisse
 
 copyright:
 https://github.com/John-Lluch/SWRevealViewController/blob/master/LICENSE.txt
 multiview:
 https://www.youtube.com/watch?v=8EFfPT3UeWs
 
 
 */

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    // MARK: Properties
    
    
    let bulletCategory:UInt32 = 0x1 << 1
    let bodyCategory:UInt32 = 0x1 << 0
    
    var juku:SKSpriteNode = SKSpriteNode()
    var bodyPart:SKSpriteNode = SKSpriteNode()

    
    var bullet:SKSpriteNode = SKSpriteNode()
    var litter:SKSpriteNode = SKSpriteNode()
    var litterSelected:Bool = false

    var targetPosition:CGPoint = CGPoint()
    var touchedPartLabel = SKLabelNode()
    var touchedParts = Set<String>()
    var deleteOnTouch = [SKSpriteNode]()
    
    var incontact = [(String,Int)]()
    
    var jukuHeight = CGFloat()
    var jukuWidth = CGFloat()
    
    
    
    override func didMoveToView(view: SKView) {
        
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation){
        touchedPartLabel.text = "Touched bodypart: "
        touchedPartLabel.fontSize = 12
        touchedPartLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 20)
        touchedPartLabel.fontColor = SKColor.blackColor()
        self.addChild(touchedPartLabel)
        
        
        //Button that is used to switch between drag and drop | touch
        var litterMoveSwitch:UISwitch  = UISwitch()
    }
    
    override init(size:CGSize){
        super.init(size:size)
        
        self.backgroundColor = SKColor.whiteColor()
        //2048 x 1536
        jukuHeight = self.frame.size.height / 2
        jukuWidth = self.frame.size.width / 2
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        self.physicsWorld.contactDelegate = self
        
        juku = SKSpriteNode(imageNamed: "juku")
        juku.name = "Juku"
        
        juku.position = CGPointMake(jukuWidth, jukuHeight)
        juku.physicsBody = SKPhysicsBody(texture: juku.texture!, size: (juku.texture!.size()))
        
        juku.physicsBody?.categoryBitMask = bodyCategory
        juku.physicsBody?.contactTestBitMask = bulletCategory
        juku.physicsBody?.collisionBitMask = 0
        //self.addChild(juku)
        

        //following reads resources and creates body parts
        /*
         naming convention for sprites without childern:    obj_name@1x.png
         naming convention for sprites with n childern:     obj_name>child1|child2|...|childN@1x.png
         naming convention for childern:                    name@1x.png
        */
        let fm = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        let items = try! fm.contentsOfDirectoryAtPath(path)

        
        for item in items {
            //&& item.hasSuffix("@1x.png")
            if item.hasPrefix("obj_") {
                let name:[String] = item.componentsSeparatedByString("@")
                
                if((name[0].rangeOfString(">")) != nil){
                    let targetsCombined:[String] = name[0].componentsSeparatedByString(">")
                    let targets: [String] = targetsCombined[1].componentsSeparatedByString("|")
                    self.addChild(Bodypart(filename: name[0], targets: targets, width: jukuWidth, height: jukuHeight)!)
                } else{
                    self.addChild(Bodypart(filename: name[0], width: jukuWidth, height: jukuHeight)!)
                }

            }
        }
        
 
        //loome litri, mida saab ringi lohistada
        litter = SKSpriteNode(imageNamed: "litter")
        litter.name = "litter"
        litter.position = CGPoint(x: 25, y: self.size.height - 25)
        
        litter.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        litter.physicsBody?.dynamic = true
        litter.physicsBody?.categoryBitMask = bulletCategory
        litter.physicsBody?.contactTestBitMask = bodyCategory
        litter.physicsBody?.collisionBitMask = 0
        //litter.physicsBody?.usesPreciseCollisionDetection = true
        incontact.append(("litter", 0))
        self.addChild(litter)
        
    }
    

    //MARK: Functions
    
    func setTouchedLabel(){
        var new:String = "Touched body parts: "
        
        for bodyPart in touchedParts{
            new += bodyPart
            new += " | "
        }
        
        touchedPartLabel.text = new
    }
    
    func createBodyPart(name:String) -> SKSpriteNode{
        
        bodyPart = SKSpriteNode(imageNamed: name)
        bodyPart.name = name
        bodyPart.position = CGPointMake(jukuWidth, jukuHeight)
        bodyPart.physicsBody = SKPhysicsBody(texture: bodyPart.texture!, size: (bodyPart.texture!.size()))
        
        bodyPart.physicsBody?.dynamic = true
        bodyPart.physicsBody?.categoryBitMask = bodyCategory
        bodyPart.physicsBody?.contactTestBitMask = bulletCategory
        bodyPart.physicsBody?.collisionBitMask = 0
        
        self.addChild(bodyPart)
        return bodyPart
    }
    
    func createChild(parent: String, name:String) -> SKSpriteNode{
        
        bodyPart = SKSpriteNode(imageNamed: name)
        bodyPart.name = parent + name
        bodyPart.position = CGPointMake(jukuWidth, jukuHeight)
        print(jukuWidth, jukuHeight)
        self.addChild(bodyPart)
        return bodyPart
    }

    
    // MARK: Touch events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touchedParts = []
        setTouchedLabel()        
        for touch in touches {
 
            let location = touch.locationInNode(self)
            if(litter.containsPoint(location)){
                litterSelected = true
            }
            //print("touch", location.x, location.y)

        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
         better - http://stackoverflow.com/questions/21597014/ios-sprite-kit-how-to-make-sprite-follow-touches
         */
        for touch in touches{
            let location = touch.locationInNode(self)
            if(litterSelected){
                litter.position = location
            }
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(litterSelected){
            //not actually needed
            for touch in touches{
                let _ = touch.locationInNode(self)
            }
        }
        litterSelected = false
    }
    
    //MARK: Contact events
    
    func didBeginContact(contact: SKPhysicsContact) {
        let touchedPart:String = contact.bodyA.valueForKey("representedObject")?.valueForKey("name") as! String
        //print("contact", touchedPart)
        

        //if part is not incontact list then add it, else increment it's incontact count
        var partNotIncontact = true
        for part in incontact{
            if part.0 == touchedPart{
                var index = incontact.filter{$0 != part}
                index.append((part.0, part.1+1))
                incontact = index
                partNotIncontact = false
            }
        }
        
        if partNotIncontact{
            incontact.append((touchedPart, 0))
            touchedParts.insert(touchedPart)
            setTouchedLabel()
            
            if let bodyPart = contact.bodyA.node as? Bodypart{
                for part in bodyPart.getTargets(){
                    bodyPart.addChildz(createChild(touchedPart, name: part))
                    //print("created", touchedPart, part)
                }
            }
        }
        //print(incontact)
    }

        // kui liikuda näppude vahel ja seal näpult ära hüpata siis kaotab childi ära
    
    func didEndContact(contact: SKPhysicsContact) {
        let touchedPart:String = contact.bodyA.valueForKey("representedObject")?.valueForKey("name") as! String
        //print("NO contact", touchedPart)
        
        /*
         Checks incontact list
         if there has been more begincontacts than endcontacts with sprite then keeps children
         else it removes them
        */
        var inList = true
        for part in incontact{
            if part.0 == touchedPart{
                inList = false
                if part.1 == 0{
                    let index = incontact.filter{$0 != part}
                    incontact = index
                    
                    touchedParts.remove(contact.bodyA.valueForKey("representedObject")?.valueForKey("name") as! String)
                    
                    if let bodyPart = contact.bodyA.node as? Bodypart{
                        self.removeChildrenInArray(bodyPart.getChildz())
                    }
                    setTouchedLabel()
                    
                }else{
                    var index = incontact.filter{$0 != part}
                    index.append((part.0, part.1-1))
                    incontact = index
                }
            }
        }
        if inList{
            print("okou")
        }
        //print(incontact)
    }
    
    
    //MARK: Not used functions
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

 
}
