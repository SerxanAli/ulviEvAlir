//
//  GameScene.swift
//  ulviEvAlir
//
//  Created by serhan on 25.12.22.
//

import SpriteKit
import GameplayKit

enum CarpismaTipi:UInt32{
    case ulvi = 1
    case qepik = 2
    case over = 3
}


class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var ulvi:SKSpriteNode = SKSpriteNode()
    var qepik:SKSpriteNode = SKSpriteNode()
    var over:SKSpriteNode = SKSpriteNode()
    
    var pul:SKLabelNode = SKLabelNode()
    
    var seifeKecidi:UIViewController?
    
    var dokunmaKontrol:Bool = false
    var oyunBaslasin = false
    
    var saygac:Timer?
    
    var ekranEni:Int?
    var ekranUzunlugu:Int?
    
    var yigilanPul = 0
    
    var oyunBitdi:Int = 1
    
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        ekranEni = Int(self.frame.size.width)
        ekranUzunlugu = Int(self.frame.size.height)
        
        // print("eni-\(ekranEni!) --- uzunu\(ekranUzunlugu!)")
        
        //print(qepik.position.x)
        //print(qepik.position.y)
        
        
        
        if let karakter = self.childNode(withName: "ulvi") as? SKSpriteNode {
            ulvi = karakter
            
            ulvi.physicsBody?.categoryBitMask = CarpismaTipi.ulvi.rawValue
            ulvi.physicsBody?.collisionBitMask = CarpismaTipi.qepik.rawValue
            ulvi.physicsBody?.contactTestBitMask = CarpismaTipi.qepik.rawValue
            
        }
        if let karakter = self.childNode(withName: "qepik") as? SKSpriteNode {
            qepik = karakter
            
            qepik.physicsBody?.categoryBitMask = CarpismaTipi.qepik.rawValue
            qepik.physicsBody?.collisionBitMask = CarpismaTipi.ulvi.rawValue
            qepik.physicsBody?.contactTestBitMask = CarpismaTipi.ulvi.rawValue
            
            qepik.physicsBody?.categoryBitMask = CarpismaTipi.qepik.rawValue
            qepik.physicsBody?.collisionBitMask = CarpismaTipi.over.rawValue
            qepik.physicsBody?.contactTestBitMask = CarpismaTipi.over.rawValue
            
            
        }
        
        if let karakter = self.childNode(withName: "pul") as? SKLabelNode {
            pul = karakter
            
            
            
        }
        
        if let karakter = self.childNode(withName: "over") as? SKSpriteNode {
            over = karakter
            
            over.physicsBody?.categoryBitMask = CarpismaTipi.over.rawValue
            over.physicsBody?.collisionBitMask = CarpismaTipi.qepik.rawValue
            over.physicsBody?.contactTestBitMask = CarpismaTipi.qepik.rawValue
            
        }
        
        saygac = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(haraket), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func haraket(){
        
        if oyunBaslasin {
            
            if dokunmaKontrol {
                
                let saga: SKAction = SKAction.moveBy(x: +20, y: 0, duration: 1)
                ulvi.run(saga)
                
            } else {
                
                let sola: SKAction = SKAction.moveBy(x: -20, y: 0, duration: 1)
                ulvi.run(sola)
                
            }
            
            qepikDusur(cisimAdi: qepik, cisimHizi: -20)
            pul.text = "pul: \(yigilanPul)"
            
            
            //  print(qepik.position.y)
        }
        
    }
    
    
    
    
    
    func qepikDusur(cisimAdi:SKSpriteNode,cisimHizi:CGFloat){
        
        if Int(cisimAdi.position.y) < 0 {
            
            cisimAdi.position.y = CGFloat(ekranUzunlugu!)
            cisimAdi.position.x = CGFloat(arc4random_uniform(UInt32(ekranEni!)))
            
            
            
        } else {
            
            let asagiDusur:SKAction = SKAction.moveBy(x: 0, y: cisimHizi, duration: 6)
            cisimAdi.run(asagiDusur)
        }
        
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        oyunBaslasin = true
        dokunmaKontrol = true
        print("--------")
        print(oyunBitdi)
        print("--------")
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        dokunmaKontrol = false
        print("--------")
        print(oyunBitdi)
        print("--------")
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    
    // capisma
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CarpismaTipi.ulvi.rawValue &&
            contact.bodyB.categoryBitMask == CarpismaTipi.qepik.rawValue {
            
            let yuxariCix:SKAction = SKAction.moveBy(x:CGFloat(arc4random_uniform(UInt32(ekranEni!))), y:CGFloat(ekranUzunlugu!), duration: 0.02)
            qepik.run(yuxariCix)
            
            yigilanPul = yigilanPul + 1
            print("carpti")
            print(yigilanPul)
            
            
        }
        
        
        if contact.bodyB.categoryBitMask == CarpismaTipi.ulvi.rawValue &&
            contact.bodyA.categoryBitMask == CarpismaTipi.qepik.rawValue {
            let yuxariCix:SKAction = SKAction.moveBy(x:CGFloat(arc4random_uniform(UInt32(ekranEni!))), y:CGFloat(ekranUzunlugu!), duration: 0.02)
            qepik.run(yuxariCix)
            
            
            yigilanPul = yigilanPul + 1
            print("carpti")
            print(yigilanPul)
            
            
        }
        
        
        if contact.bodyA.categoryBitMask == CarpismaTipi.qepik.rawValue &&
            contact.bodyB.categoryBitMask == CarpismaTipi.over.rawValue {
            saygac?.invalidate()
            
            let baza = UserDefaults.standard
            baza.set(yigilanPul, forKey: "yigilanPul")
            
            qepik.position = ulvi.position
            
            oyunBitdi = oyunBitdi - 1
            
            if oyunBitdi == 0 {
                self.seifeKecidi?.performSegue(withIdentifier: "son", sender: nil)
            }
            
            
            
            
        }
        
        if contact.bodyB.categoryBitMask == CarpismaTipi.qepik.rawValue &&
            contact.bodyA.categoryBitMask == CarpismaTipi.over.rawValue {
            saygac?.invalidate()
            
            let baza = UserDefaults.standard
            baza.set(yigilanPul, forKey: "yigilanPul")
            
            qepik.position = ulvi.position
            
            oyunBitdi = oyunBitdi - 1
            
            if oyunBitdi == 0 {
                self.seifeKecidi?.performSegue(withIdentifier: "son", sender: nil)
            }
            
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


//    TO BE CONTINUED   ***** 1.2
