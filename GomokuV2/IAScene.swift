//
//  SoloScene.swift
//  GomokuV2
//
//  Created by Alexis DARNAT on 18/01/2016.
//  Copyright © 2016 Alexis DARNAT. All rights reserved.
//

import SpriteKit

class IAScene: SKScene {
    
    var background : SKSpriteNode?
    var playerOneLabel : SKLabelNode?
    var playerTwoLabel : SKLabelNode?
    var backButton : SKLabelNode?
    var WinLabel : SKLabelNode?
    var unity : CGFloat?
    var startPoint: CGPoint?
    var ended : Bool = false
    var pawns : [PawnSpriteNode] = []
    var board : UnsafeMutablePointer<t_board>?
    var playing: Int = 2 {
        didSet {
            if playing == 2 {
                self.playerTwoLabel?.alpha = 0.4
                self.playerOneLabel?.alpha = 1
            } else {
                self.playerOneLabel?.alpha = 0.4
                self.playerTwoLabel?.alpha = 1
            }
        }
    }
    
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
        
        self.unity = (self.frame.size.height - 180.0) / 18.0
        self.startPoint = CGPoint(x: CGRectGetMidX(self.frame) - 9.0 * self.unity!, y: 90)
        self.drawGrid(self.unity!, startpoint: self.startPoint!)
        
        let whitePawn = SKSpriteNode(imageNamed: "white-pawn")
        whitePawn.position = CGPointMake(CGRectGetMidX(self.frame) + self.unity! * 10.5 , CGRectGetMaxY(self.frame) - 150)
        whitePawn.size = CGSize(width: 50, height: 50)
        whitePawn.zPosition = 0.0004
        self.addChild(whitePawn)
        
        let brownPawn = SKSpriteNode(imageNamed: "brown-pawn")
        brownPawn.position = CGPointMake(CGRectGetMidX(self.frame) - self.unity! * 10.5 , 150)
        brownPawn.size = CGSize(width: 50, height: 50)
        brownPawn.zPosition = 0.0004
        self.addChild(brownPawn)
        
        self.playerOneLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.playerOneLabel!.text = "Player 1"
        self.playerOneLabel!.fontSize = 60
        self.playerOneLabel!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.playerOneLabel!.position = CGPoint(x: CGRectGetMidX(self.frame) + self.unity! * 11.0, y: CGRectGetMidY(self.frame))
        self.playerOneLabel!.zPosition = 0.0004
        self.playerOneLabel!.zRotation = CGFloat(M_PI_2)
        self.addChild(self.playerOneLabel!)
        
        self.playerTwoLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.playerTwoLabel!.text = "ORDI"
        self.playerTwoLabel!.fontSize = 60
        self.playerTwoLabel!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.playerTwoLabel!.position = CGPoint(x: CGRectGetMidX(self.frame) - self.unity! * 11.0, y: CGRectGetMidY(self.frame))
        self.playerTwoLabel!.zPosition = 0.0004
        self.playerTwoLabel!.alpha = 0.4
        self.playerTwoLabel!.zRotation = CGFloat(-M_PI_2)
        self.addChild(self.playerTwoLabel!)
        
        self.backButton = SKLabelNode(fontNamed: "Chalkduster")
        self.backButton!.text = "< Back"
        self.backButton!.fontSize = 40
        self.backButton!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.backButton!.position = CGPoint(x: 100.0, y: CGRectGetMaxY(self.frame) - 50)
        self.backButton!.zPosition = 0.0004
        self.addChild(self.backButton!)
        
        self.WinLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.WinLabel!.text = "Player 1 Win"
        self.WinLabel!.fontSize = 120
        self.WinLabel!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.WinLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.WinLabel!.zPosition = 0.0006
        self.WinLabel!.zRotation = CGFloat(M_PI_4)
        self.WinLabel!.hidden = true
        self.addChild(self.WinLabel!)
        
        self.board = newBoard()
    }
    
    private func drawGrid(unity : CGFloat, startpoint: CGPoint) {
        let pathToDraw = CGPathCreateMutable()
        for index in 0...18 {
            CGPathMoveToPoint(pathToDraw, nil, startpoint.x + unity * CGFloat(index), startpoint.y)
            CGPathAddLineToPoint(pathToDraw, nil, startpoint.x + unity * CGFloat(index), startpoint.y + unity * 18.0)
            
            CGPathMoveToPoint(pathToDraw, nil, startpoint.x, startpoint.y + unity * CGFloat(index))
            CGPathAddLineToPoint(pathToDraw, nil, startpoint.x + unity * 18.0, startpoint.y + unity * CGFloat(index))
        }
        let line = SKShapeNode(path: pathToDraw)
        line.strokeColor = UIColor(red: 0.22, green: 0.169, blue: 0.024, alpha: 0.5)
        line.zPosition = 0.0004
        line.lineWidth = 2
        self.addChild(line)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node == self.backButton {
                self.backToMenu()
                return
            }
            if ended || self.playing == 1{
                return
            }
            if checkLocation(location) {
                return
            }
            // ARBITRE //////
            let coordinate = getLocation(location)
            if (setPawn(self.board!, CInt(coordinate.x / self.unity!), CInt(coordinate.y / self.unity!), CInt(self.playing)) == CInt(1)) {
                print("Impossible to set the pawn at this coordinate")
                break
            }
            //self.background?.runAction(SKAction.playSoundFileNamed("setPawn.mp3", waitForCompletion: false))
            self.checkAfter(coordinate)
            
            self.playing = self.playing == 1 ? 2 : 1
            /*if self.playing == 1 {
            }*/
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                self.playIA();
            })
            //self.playIA()
        }
    }
    
    private func checkAfter(coordinate : CGPoint) {
        var pawnsDelete : UnsafeMutablePointer<t_pawn> = checkEaten(self.board!)
        while pawnsDelete != nil {
            if let pawn2 = self.popPawnAt(CGFloat(pawnsDelete.memory.x), y: CGFloat(pawnsDelete.memory.y)) {
                //self.background?.runAction(SKAction.playSoundFileNamed("removePawn.mp3", waitForCompletion: false))
                pawn2.removeFromParent()
            }
            pawnsDelete = pawnsDelete.memory.next
        }
        // ARBITRE //
        if ((self.getPawnAt(coordinate.x, y: coordinate.y)) != nil) {
            return
        }
        var imageName = "brown-pawn"
        if self.playing == 2 {
            imageName = "white-pawn"
        }
        let pawn = PawnSpriteNode(imageNamed: imageName)
        pawn.size.height = self.unity!
        pawn.size.width = self.unity!
        pawn.zPosition = 0.0005
        pawn.coordinate.x = CGFloat(Int(coordinate.x / self.unity!))
        pawn.coordinate.y = CGFloat(Int(coordinate.y / self.unity!))
        pawn.position.x = coordinate.x + (self.startPoint?.x)!
        pawn.position.y = coordinate.y + (self.startPoint?.y)!
        pawn.id = self.playing
        self.pawns.append(pawn)
        self.addChild(pawn)
        
        if (checkWin(self.board!) == CInt(1)) {
            self.WinLabel!.text = "You Win"
            if self.playing == 1 {
                self.WinLabel!.text = "Ordi Win"
            }
            self.WinLabel?.hidden = false
            self.ended = true
            //self.background?.runAction(SKAction.playSoundFileNamed("removePawn.mp3", waitForCompletion: false))
            return
        }
    }
    
    private func playIA() {
        if let pawnIA : UnsafeMutablePointer<t_pawn>? = setPawnAI(self.board!) {
            let coordinate = CGPoint(x: CGFloat(Int((pawnIA?.memory.x)!)) * self.unity!, y: CGFloat(Int((pawnIA?.memory.y)!)) * self.unity!)
            dispatch_async(dispatch_get_main_queue(), {
                self.checkAfter(coordinate)
                self.playing = self.playing == 1 ? 2 : 1
            })
        }
    }
    
    private func getPawnAt(x: CGFloat, y: CGFloat) -> PawnSpriteNode? {
        for pawn in self.pawns {
            if (pawn.coordinate.x == x && pawn.coordinate.y == y) {
                return pawn
            }
        }
        return nil
    }
    
    private func popPawnAt(x: CGFloat, y: CGFloat) -> PawnSpriteNode? {
        var i = 0
        for pawn in self.pawns {
            if (pawn.coordinate.x == x && pawn.coordinate.y == y) {
                let rpawn = pawn
                self.pawns.removeAtIndex(i)
                return rpawn
            }
            ++i
        }
        return nil
    }
    
    private func backToMenu() {
        if let view = self.view {
            let scene = GameScene(fileNamed: "GameScene")
            scene?.scaleMode = .AspectFill
            view.presentScene(scene!, transition: SKTransition.crossFadeWithDuration(0.5))
        }
    }
    
    private func getLocation(location: CGPoint) -> CGPoint {
        var pawnLocation = CGPoint(x: location.x - self.startPoint!.x, y: location.y - self.startPoint!.y)
        
        pawnLocation.x = CGFloat(Int((pawnLocation.x + self.unity! / 2.0) / self.unity!)) * self.unity!
        pawnLocation.y = CGFloat(Int((pawnLocation.y + self.unity! / 2.0) / self.unity!)) * self.unity!
        return pawnLocation
    }
    
    private func checkLocation(location: CGPoint) -> Bool {
        if ((location.x - self.startPoint!.x) < self.unity! / -2.0 || (location.x > self.startPoint!.x + self.unity! / 2.0 + 18.0 * self.unity!)) {
            return true
        }
        if ((location.y - self.startPoint!.y) < self.unity! / -2.0 || (location.y > self.startPoint!.y + self.unity! / 2.0 + 18.0 * self.unity!)) {
            return true
        }
        return false;
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
