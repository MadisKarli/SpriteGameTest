//
//  Bodypart.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 11/08/16.
//  Copyright © 2016 Papple Inc. All rights reserved.
//

import SpriteKit

class Bodypart{
    var name: String
    var picture: SKSpriteNode
    var causes: [SKSpriteNode]
    
    init(name: String, picture: SKSpriteNode, causes: [SKSpriteNode]){
        self.name = name
        self.picture = picture
        self.causes = causes
        
    }
    
    func addCause(cause: SKSpriteNode){
        self.causes.append(cause)
    }
    
    func addCause(causes: [SKSpriteNode]){
        for node in causes{
            self.causes.append(node)
        }
    }
    
    func setCauses(causes: [SKSpriteNode]){
        self.causes = causes
    }
}