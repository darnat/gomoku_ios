//
//  GameScene.swift
//  GomokuV2
//
//  Created by Alexis DARNAT on 18/01/2016.
//  Copyright (c) 2016 Alexis DARNAT. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var background : SKSpriteNode?
    var OneVsOne : SKLabelNode?
    var oneVSOrdi : SKLabelNode?
    var multiButton : SKLabelNode?
    var optionsButton : SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        self.size = (self.view?.bounds.size)!
        
        self.background = SKSpriteNode(imageNamed: "background-wood")
        self.background!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        let size = CGSize(width: self.frame.size.width * (self.background?.size.width)! / self.background!.size.height, height: self.frame.height + 1)
        self.background!.size = size
        self.background?.zPosition = 0.0002
        self.addChild(self.background!)
        
        let parchment = SKSpriteNode(imageNamed: "parchment")
        parchment.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        parchment.size = CGSize(width: parchment.size.width * (self.frame.size.height - 140) / parchment.size.height, height: self.frame.size.height - 140)
        parchment.zPosition = 0.0003
        self.addChild(parchment)
        
        let title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = "GOMOKU"
        title.fontSize = 80
        title.fontColor = UIColor(red: 0.22, green: 0.169, blue: 0.024, alpha: 1)
        title.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - 180)
        title.zPosition = 0.0004
        self.addChild(title)
        
        self.OneVsOne = SKLabelNode(fontNamed: "Chalkduster")
        self.OneVsOne!.text = "One vs One"
        self.OneVsOne!.fontSize = 45
        self.OneVsOne!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.OneVsOne!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 70)
        self.OneVsOne!.zPosition = 0.0004
        self.addChild(self.OneVsOne!)
        
        self.oneVSOrdi = SKLabelNode(fontNamed: "Chalkduster")
        self.oneVSOrdi!.text = "Contre l'ordi"
        self.oneVSOrdi!.fontSize = 45
        self.oneVSOrdi!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.oneVSOrdi!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 30)
        self.oneVSOrdi!.zPosition = 0.0004
        self.addChild(self.oneVSOrdi!)
        
        self.multiButton = SKLabelNode(fontNamed: "Chalkduster")
        self.multiButton!.text = "Multiplayer"
        self.multiButton!.fontSize = 45
        self.multiButton!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.multiButton!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 140)
        self.multiButton!.zPosition = 0.0004
        self.addChild(self.multiButton!)
        
        self.optionsButton = SKLabelNode(fontNamed: "Chalkduster")
        self.optionsButton!.text = "Options"
        self.optionsButton!.fontSize = 45
        self.optionsButton!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.optionsButton!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 240)
        self.optionsButton!.zPosition = 0.0004
        self.addChild(self.optionsButton!)
        
        //let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        //self.scene?.view?.addGestureRecognizer(pinchGestureRecognizer)
        
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)*/
    }
    
    /*func handlePinch(sender: UIPinchGestureRecognizer) {
        self.background?.runAction(SKAction.scaleBy(sender.scale, duration: 0))
        sender.scale = 1
    }*/
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node == self.OneVsOne {
                if let view = self.view {
                    let scene = SoloScene(fileNamed: "GameScene")
                    scene?.scaleMode = .AspectFill
                    view.presentScene(scene!, transition: SKTransition.crossFadeWithDuration(0.5))
                }
            } else if node == self.oneVSOrdi {
                if let view = self.view {
                    let scene = IAScene(fileNamed: "GameScene")
                    scene?.scaleMode = .AspectFill
                    view.presentScene(scene!, transition: SKTransition.crossFadeWithDuration(0.5))
                }
            } else if node == self.multiButton {
                if let view = self.view {
                    let scene = MultiScene(fileNamed: "GameScene")
                    scene?.scaleMode = .AspectFill
                    view.presentScene(scene!, transition: SKTransition.crossFadeWithDuration(0.5))
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
