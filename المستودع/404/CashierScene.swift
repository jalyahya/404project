//
//  ClockScene.swift
//  404
//
//  Created by Azhar on 14/05/2025.
//
import SpriteKit

class CashierScene: SKScene {
    var inventorySlots: [SKShapeNode] = []
    var cashierClose: SKSpriteNode!
    
    var enteredCode: String = ""
    let correctCode: String = "2596"
    
    var rightHand: SKSpriteNode!
    var leftHand: SKSpriteNode!
    var clockCenter: CGPoint = .zero
    var draggedHand: SKSpriteNode?
    var clock: SKSpriteNode!
    var originalPosition: CGPoint?
    var key0: SKSpriteNode?
    var originalClockSize: CGSize = .zero
    var gearActivated: Bool {
        return GameState.shared.hasUsed("Gear")
    }
    let draggableItemNames: Set<String> = ["Gear", "Note1", "Key0", "GKey"]
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let bg2 = SKSpriteNode(imageNamed: "BG2")
        bg2.zPosition = 0
        bg2.position = .zero
        bg2.xScale = size.width / bg2.size.width
        bg2.yScale = size.height / bg2.size.height
        addChild(bg2)
        
        clock = SKSpriteNode(imageNamed: "MainClock")
        clock.zPosition = 2
        clock.size = CGSize(width: 262, height: 577)
        clock.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2 - 420)
        addChild(clock)
        originalClockSize = clock.size
        clockCenter = clock.position
        
        let circle = SKSpriteNode(imageNamed: "Circle")
        circle.zPosition = clock.zPosition + 1
        circle.size = CGSize(width: 15, height: 15)
        circle.position = CGPoint(x: clock.position.x - 5, y: clock.position.y - 5)
        addChild(circle)
        
        rightHand = SKSpriteNode(imageNamed: "RightHand")
        rightHand.name = "RightHand"
        rightHand.anchorPoint = CGPoint(x: 0.5, y: 0)
        rightHand.zPosition = clock.zPosition + 1
        rightHand.size = CGSize(width: 15, height: 60)
        rightHand.position = CGPoint(x: clock.position.x - 5, y: clock.position.y - 5)
        addChild(rightHand)
        
        leftHand = SKSpriteNode(imageNamed: "LeftHand")
        leftHand.name = "LeftHand"
        leftHand.anchorPoint = CGPoint(x: 0.5, y: 0)
        leftHand.zPosition = rightHand.zPosition + 1
        leftHand.size = CGSize(width: 20, height: 60)
        leftHand.position = CGPoint(x: clock.position.x - 5, y: clock.position.y - 5)
        addChild(leftHand)
        
        if GameState.shared.isCashierOpen {
            cashierClose = SKSpriteNode(imageNamed: "CashierOpen")
            cashierClose.size = CGSize(width: 450, height: 500)
            cashierClose.position = CGPoint(x: -size.width / 2 + 300, y: -size.height / 2 + 280)
            addChild(cashierClose)
            
            // ✅ أضيف المفتاح فقط إذا تم كشفه سابقاً
            if GameState.shared.hasRevealedKey0 && !GameState.shared.hasCollected("Key0") {
                key0 = SKSpriteNode(imageNamed: "Key0")
                key0?.name = "Key0"
                key0?.setScale(0.4)
                key0?.zPosition = cashierClose.zPosition + 1
                key0?.position = CGPoint(x: cashierClose.position.x, y: cashierClose.position.y - 120)
                if let key = key0 {
                    addChild(key)
                }
            }
        }  else {
            cashierClose = SKSpriteNode(imageNamed: "CashierClose")
            cashierClose.zPosition = 1
            cashierClose.size = CGSize(width: 459.2, height: 417)
            cashierClose.position = CGPoint(x: -size.width / 2 + 300, y: -size.height / 2 + 330)
            addChild(cashierClose)
        }
        
        let closeButton = SKSpriteNode(imageNamed: "Close")
        closeButton.name = "closeButton"
        closeButton.zPosition = 10
        closeButton.size = CGSize(width: 40, height: 50)
        closeButton.position = CGPoint(x: size.width / 2 - 80, y: size.height / 2 - 80)
        addChild(closeButton)
        
        setupInventoryBar()
        InventoryHelper.loadEvidence(into: self, slots: inventorySlots)
        
        addNumberButtons()
    }
    
    func setupInventoryBar() {
        let slotSize = CGSize(width: 80, height: 90)
        let totalSlots = 5
        let spacing: CGFloat = 30
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let boxHeight: CGFloat = 110
        let topY: CGFloat = size.height / 2 - 170
        
        let backgroundRect = CGSize(width: totalWidth + 60, height: boxHeight)
        let inventoryBackground = SKShapeNode(rectOf: backgroundRect, cornerRadius: 20)
        inventoryBackground.fillColor = UIColor(white: 0.2, alpha: 0.6)
        inventoryBackground.strokeColor = .clear
        inventoryBackground.position = CGPoint(x: 0, y: topY)
        inventoryBackground.zPosition = 9
        addChild(inventoryBackground)
        
        let startX = totalWidth / 2 - slotSize.width / 2
        let softGrayColor = UIColor(white: 0.35, alpha: 0.7)
        
        for i in 0..<totalSlots {
            let slot = SKShapeNode(rectOf: slotSize, cornerRadius: 10)
            slot.fillColor = softGrayColor
            slot.strokeColor = .clear
            slot.position = CGPoint(x: startX - CGFloat(i) * (slotSize.width + spacing), y: topY)
            slot.zPosition = 10
            inventorySlots.append(slot)
            addChild(slot)
        }
    }
    
    func getFirstTrulyEmptySlot() -> SKShapeNode? {
        return inventorySlots.first(where: { slot in
            let activeChildren = slot.children.filter { child in
                guard let sprite = child as? SKSpriteNode else { return false }
                return sprite.alpha > 0.1 && sprite.name != nil
            }
            return activeChildren.isEmpty
        })
    }
    
    func addNumberButtons() {
        let numberSize = CGSize(width: 70, height: 70)
        let spacingX: CGFloat = 90
        let spacingY: CGFloat = 70
        let baseX = cashierClose.position.x
        let baseY = cashierClose.position.y + cashierClose.size.height / 2 - 140
        
        var numberIndex = 1
        
        for row in 0..<3 {
            for col in 0..<3 {
                let numberNode = SKSpriteNode(imageNamed: "Number\(numberIndex)")
                numberNode.name = "Number\(numberIndex)"
                numberNode.size = numberSize
                numberNode.zPosition = 5
                
                let offsetX = CGFloat(col - 1) * spacingX
                let offsetY = CGFloat(-row) * spacingY
                
                numberNode.position = CGPoint(x: baseX + offsetX, y: baseY + offsetY)
                
                addChild(numberNode)
                numberIndex += 1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "closeButton" {
            let scene = CafeScene(size: self.size)
            scene.scaleMode = self.scaleMode
            view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            return
        }
        
        if ["Gear", "Note1", "GKey", "Knife", "Key0"].contains(touchedNode.name ?? "") {
            if let sprite = touchedNode as? SKSpriteNode {
                // نحوله من داخل الخانة إلى المشهد عشان ما يطير
                if let parent = sprite.parent, parent is SKShapeNode {
                    let newPos = parent.convert(sprite.position, to: self)
                    sprite.removeFromParent()
                    sprite.position = newPos
                    sprite.zPosition = 1000
                    addChild(sprite)
                }
                
                draggedHand = sprite
                originalPosition = sprite.position
                sprite.run(SKAction.scale(to: 0.5, duration: 0.2))
            }
            originalPosition = draggedHand?.position
            draggedHand?.run(SKAction.scale(to: 0.5, duration: 0.2))
            return
        }
        
        if let node = touchedNode as? SKSpriteNode, node.name == "Gear" {
            if node.frame.intersects(clock.frame) {
                node.removeFromParent()
                GameState.shared.markAsUsed("Gear")
            }
        }
        
        if gearActivated && (touchedNode == rightHand || touchedNode == leftHand) {
            draggedHand = touchedNode as? SKSpriteNode
            return
        }
        
        if let name = touchedNode.name, name.starts(with: "Number") {
            let number = name.replacingOccurrences(of: "Number", with: "")
            enteredCode.append(number)
            
            if enteredCode.count == 4 {
                if enteredCode == correctCode && !GameState.shared.isCashierOpen {
                    if GameState.shared.hasCollected("Key0") { return }
                    cashierClose.texture = SKTexture(imageNamed: "CashierOpen")
                    cashierClose.size = CGSize(width: 450, height: 500)
                    cashierClose.position.y -= 50
                    GameState.shared.isCashierOpen = true
                    
                    // أنشئ المفتاح
                    key0 = SKSpriteNode(imageNamed: "Key0")
                    key0?.name = "Key0"
                    key0?.setScale(0.4)
                    key0?.zPosition = 1000
                    key0?.position = CGPoint(x: cashierClose.position.x, y: cashierClose.position.y - 120)
                    
                    if let key = key0 {
                        addChild(key)
                        
                        let moveToCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.8)
                        
                        let moveToSlot = SKAction.sequence([
                            SKAction.wait(forDuration: 0.1), // ⏱️ تأخير بسيط يسمح للمشهد يرتب كل شيء
                            SKAction.run {
                                if let firstEmptySlot = self.getFirstTrulyEmptySlot() {
                                    let moveToSlotPosition = SKAction.move(to: firstEmptySlot.position, duration: 0.5)
                                    let scaleDown = SKAction.scale(to: 0.3, duration: 0.5)
                                    let group = SKAction.group([moveToSlotPosition, scaleDown])
                                    let finalize = SKAction.run {
                                        if key.parent is SKShapeNode { return }
                                        let alreadyHasKey = firstEmptySlot.children.contains(where: { $0 === key })
                                        if !alreadyHasKey {
                                            GameState.shared.collect("Key0")
                                            key.removeFromParent()
                                            key.position = .zero
                                            key.zPosition = 1
                                            firstEmptySlot.addChild(key)
                                        }
                                    }
                                    key.run(.sequence([group, finalize]))
                                }
                            }
                        ])
                        
                        key.run(.sequence([moveToCenter, SKAction.wait(forDuration: 0.3), moveToSlot]))
                    }
                    
                    GameState.shared.hasRevealedKey0 = true
                }
                
                enteredCode = "" // إعادة تعيين الكود بعد 4 أرقام
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggedHand else { return }
        
        let location = touch.location(in: self)
        
        if node.name == "Gear", node.frame.intersects(clock.frame), !gearActivated {
            GameState.shared.markAsUsed("Gear")
            
            let moveToCenter = SKAction.move(to: clockCenter, duration: 0.4)
            _ = SKAction.playSoundFileNamed("clock_start.wav", waitForCompletion: false)
            
            // 🎞️ إعداد أنيميشن الساعة
            let customClockSize = CGSize(width: 577, height: 600)
            var clockFrames: [SKAction] = []
            for i in 1...12 {
                let texture = SKTexture(imageNamed: "MoveClock\(i)")
                let action = SKAction.run {
                    self.clock.texture = texture
                    self.clock.size = customClockSize
                }
                let wait = SKAction.wait(forDuration: 0.2)
                clockFrames.append(action)
                clockFrames.append(wait)
            }
            
            let animationSequence = SKAction.sequence(clockFrames)
            let returnToMainClock = SKAction.run {
                self.clock.texture = SKTexture(imageNamed: "MainClock")
                self.clock.size = self.originalClockSize
            }
            
            // ⏰ شغل أنيميشن الساعة
            clock.run(.sequence([
                animationSequence,
                SKAction.wait(forDuration: 0.3),
                returnToMainClock
            ]))
            
            // ⚙️ حركة الترس
            let gearAnimation = SKAction.sequence([
                moveToCenter,
                SKAction.rotate(byAngle: CGFloat.pi * 4, duration: 2.4), // نفس مدة الساعة
                SKAction.run {
                    node.removeAllActions()
                    node.removeFromParent()
                }
            ])
            node.run(gearAnimation)
            
            draggedHand = nil
            originalPosition = nil
            return
        }
        
        if node.name == "Note1" {
            node.position = location
            
            let hourAngle = (rightHand.zRotation.truncatingRemainder(dividingBy: (.pi * 2)) + (.pi * 2)).truncatingRemainder(dividingBy: (.pi * 2))
            let minuteAngle = (leftHand.zRotation.truncatingRemainder(dividingBy: (.pi * 2)) + (.pi * 2)).truncatingRemainder(dividingBy: (.pi * 2))
            
            let hourRange = 1.4835...1.658
            let minuteRange = 4.625...4.799
            
            if hourRange.contains(hourAngle), minuteRange.contains(minuteAngle), node.frame.intersects(clock.frame) {
                node.run(SKAction.fadeOut(withDuration: 0.5)) {
                    node.removeFromParent()
                    GameState.shared.markAsUsed("Note1")
                }
            }
            return
        }
        
        if ["Gear", "GKey", "Knife", "Key0"].contains(node.name ?? "") {
            node.position = location
            return
        }
        
        if gearActivated {
            let previous = touch.previousLocation(in: self)
            let angle1 = atan2(previous.y - clockCenter.y, previous.x - clockCenter.x)
            let angle2 = atan2(location.y - clockCenter.y, location.x - clockCenter.x)
            let delta = angle2 - angle1
            
            node.zRotation += delta
            
            if let dragged = draggedHand, dragged.name == "Note1", dragged.frame.intersects(clock.frame) {
                let hourAngle = (rightHand.zRotation.truncatingRemainder(dividingBy: (.pi * 2)) + (.pi * 2)).truncatingRemainder(dividingBy: (.pi * 2))
                let minuteAngle = (leftHand.zRotation.truncatingRemainder(dividingBy: (.pi * 2)) + (.pi * 2)).truncatingRemainder(dividingBy: (.pi * 2))
                
                let hourRange = 1.4835...1.658
                let minuteRange = 4.625...4.799
                
                if hourRange.contains(hourAngle), minuteRange.contains(minuteAngle) {
                    dragged.run(SKAction.fadeOut(withDuration: 0.5)) {
                        dragged.removeFromParent()
                        GameState.shared.markAsUsed("Note1")
                    }
                }
            }
        }
    }
}
