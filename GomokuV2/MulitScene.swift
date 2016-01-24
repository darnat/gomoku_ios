//
//  SoloScene.swift
//  GomokuV2
//
//  Created by Alexis DARNAT on 18/01/2016.
//  Copyright © 2016 Alexis DARNAT. All rights reserved.
//

import SpriteKit

class MultiScene: SKScene {
    
    var socket : UnsafeMutablePointer<t_socket>?
    
    
    var background : SKSpriteNode?
    var backButton : SKLabelNode?
    var WinLabel : SKLabelNode?
    var readyLabel : SKLabelNode?
    var unity : CGFloat?
    var startPoint: CGPoint?
    var ended : Bool = false
    var pawns : [PawnSpriteNode] = []
    
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
        
        self.backButton = SKLabelNode(fontNamed: "Chalkduster")
        self.backButton!.text = "< Back"
        self.backButton!.fontSize = 40
        self.backButton!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.backButton!.position = CGPoint(x: 100.0, y: CGRectGetMaxY(self.frame) - 50)
        self.backButton!.zPosition = 0.0004
        self.addChild(self.backButton!)
        
        self.readyLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.readyLabel!.text = "Attente d'un joueur"
        self.readyLabel!.fontSize = 80
        self.readyLabel!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.readyLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.readyLabel!.zPosition = 0.0006
        self.readyLabel!.hidden = false
        self.ended = true
        self.addChild(self.readyLabel!)
        
        self.WinLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.WinLabel!.text = "Player Win"
        self.WinLabel!.fontSize = 80
        self.WinLabel!.fontColor = UIColor(red: 0.969, green: 0.949, blue: 0.914, alpha: 1)
        self.WinLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.WinLabel!.zPosition = 0.0006
        self.WinLabel!.zRotation = CGFloat(M_PI_4)
        self.WinLabel!.hidden = true
        self.addChild(self.WinLabel!)
        
        self.socket = create_socket()
        init_socket(self.socket!)
        connect_socket(self.socket!)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            self.socket_manager()
        })
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
            if ended {
                return
            }
            if checkLocation(location) {
                return
            }
            // ARBITRE //////
            var coordinate = getLocation(location)
            coordinate.x = CGFloat(Int(coordinate.x / self.unity!))
            coordinate.y = CGFloat(Int(coordinate.y / self.unity!))
            //print(coordinate)
            let msg = "SETPAWN " + String(Int(coordinate.x)) + " " + String(Int(coordinate.y))
            //print(msg)
            let unsafePointerOfN = (msg as NSString).UTF8String
            let unsafeMutablePointerOfN: UnsafeMutablePointer<Int8> = UnsafeMutablePointer(unsafePointerOfN)
            write_to_serve(self.socket!, unsafeMutablePointerOfN)
        }
    }
    
    private func backToMenu() {
        self.socket?.memory.is_running = CInt(0)
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
    
    private func socket_manager() {
        while (self.socket?.memory.is_running == CInt(1))
        {
            set_client(self.socket!)
            select_socket(self.socket!)
            if (server_write(self.socket!) == CInt(1)) {
                let msg = String.fromCString(read_from_server(self.socket!))
                self.dispatch_command(msg!);
            }
        }
        end_socket(self.socket!)
    }
    
    private func dispatch_command(msg: String)
    {
        let request = msg.componentsSeparatedByString("\n")
        for req in request {
            if req != "" {
                self.commands(req)
            }
        }
    }
    
    private func commands(msg: String)
    {
        var compare = msg as NSString
        if (compare.length >= 4 && compare.substringToIndex(4) == "QUIT") {
            dispatch_async(dispatch_get_main_queue(), {
                //self.socket?.memory.is_running = CInt(0)
                self.backToMenu()
                return
            })
        }
        compare = msg as NSString
        if (compare.length >= 5 && compare.substringToIndex(5) == "READY") {
            dispatch_async(dispatch_get_main_queue(), {
                self.readyLabel!.hidden = true
                self.ended = false
                return
            })
        }
        compare = msg as NSString
        if (compare.length >= 3 && compare.substringToIndex(3) == "WIN") {
            dispatch_async(dispatch_get_main_queue(), {
                let params = compare.componentsSeparatedByString(" ")
                let id = Int(params[1])
                var name = "white"
                if id == 2 {
                    name = "brown"
                }
                self.WinLabel?.text = name + " Player Win"
                self.WinLabel?.hidden = false
                self.ended = true
                return
            })
        }
        compare = msg as NSString
        if (compare.length >= 6 && compare.substringToIndex(6) == "PAWNAT") {
            dispatch_async(dispatch_get_main_queue(), {
                let params = compare.componentsSeparatedByString(" ")
                self.setPawnAt(Int(params[1])!, y: Int(params[2])!, id: Int(params[3])!)
                return
            })
        }
        compare = msg as NSString
        if (compare.length >= 12 && compare.substringToIndex(12) == "REMOVEPAWNAT") {
            dispatch_async(dispatch_get_main_queue(), {
                let params = compare.componentsSeparatedByString(" ")
                if let pawn2 = self.popPawnAt(CGFloat(Int(params[1])!), y: CGFloat(Int(params[2])!)) {
                    //self.background?.runAction(SKAction.playSoundFileNamed("removePawn.mp3", waitForCompletion: false))
                    pawn2.removeFromParent()
                }
                return
            })
        }
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
    
    private func setPawnAt(x: Int, y: Int, id: Int)
    {
        //print("Pawn at %d %d", x, y)
        var imageName = "white-pawn"
        if id == 2 {
            imageName = "brown-pawn"
        }
        let pawn = PawnSpriteNode(imageNamed: imageName)
        pawn.size.height = self.unity!
        pawn.size.width = self.unity!
        pawn.zPosition = 0.0005
        pawn.coordinate.x = CGFloat(x)
        pawn.coordinate.y = CGFloat(y)
        pawn.position.x = (CGFloat(x) * self.unity!) + (self.startPoint?.x)!
        pawn.position.y = (CGFloat(y) * self.unity!) + (self.startPoint?.y)!
        self.pawns.append(pawn)
        self.addChild(pawn)
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
