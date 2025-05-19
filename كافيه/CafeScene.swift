//
//  CafeScene.swift
//  404
//
//  Created by Azhar on 11/05/2025.
//
// CafeScene.swift

import SpriteKit

class CafeScene: SKScene {
    var plate12: SKSpriteNode!
    var gear: SKSpriteNode!
    var note1: SKSpriteNode!
    var draggedNode: SKSpriteNode?
    var originalPosition: CGPoint?
    var door: SKSpriteNode!

    var inventorySlots: [SKShapeNode] = []
    var gearAdded = false
    var noteAdded = false
    var didRevealEvidence = false

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // الخلفية
        let bg = SKSpriteNode(imageNamed: "BG")
        bg.zPosition = 0
        let bgScale = max(size.width / bg.size.width, size.height / bg.size.height)
        bg.setScale(bgScale)
        bg.position = .zero
        addChild(bg)

        // الباب
        door = SKSpriteNode(imageNamed: "Door")
        door.zPosition = 0.3
        door.size = CGSize(width: 318, height: 435)
        door.position = CGPoint(x: -470, y: -28)
        addChild(door)

        // الخلفية الخضراء
        let green = SKSpriteNode(imageNamed: "Green")
        green.zPosition = 0.5
        let greenScaleX = size.width / green.size.width
        green.xScale = greenScaleX
        green.yScale = greenScaleX * 0.7
        green.position = CGPoint(x: 0, y: -size.height / 2 + (green.size.height * green.yScale) / 2 + 30)
        addChild(green)

        // رف الكيك
        let greenTopY = green.position.y + (green.size.height * green.yScale) / 2
        let shelf = SKSpriteNode(imageNamed: "Cakes")
        shelf.zPosition = 2
        shelf.size = CGSize(width: 575, height: 657)
        shelf.position = CGPoint(x: 280, y: greenTopY + 85)
        addChild(shelf)

        // الكاشير
        let cashier = SKSpriteNode(imageNamed: "Cashier")
        cashier.name = "cashier"
        cashier.zPosition = 1.5
        cashier.setScale(0.8)
        cashier.position = CGPoint(
            x: -size.width / 2 + cashier.size.width / 2 + 150,
            y: green.position.y + (cashier.size.height * 0.3) / 2 + 183
        )
        addChild(cashier)

        // الطبق رقم 12
        plate12 = SKSpriteNode(imageNamed: "Plate12")
        plate12.name = "plate12"
        plate12.zPosition = 2.1
        plate12.size = CGSize(width: 100, height: 35)
        plate12.position = CGPoint(x: 100, y: greenTopY - 5)
        addChild(plate12)

        // الترس
        gear = SKSpriteNode(imageNamed: "Gear")
        gear.setScale(0.25)
        gear.alpha = 0
        gear.zPosition = 2.5
        gear.position = CGPoint(x: plate12.position.x - 20, y: plate12.position.y - 30)
        addChild(gear)

        // النوت
        if !GameState.shared.hasUsed("Note1") {
            note1 = SKSpriteNode(imageNamed: "Note1")
            note1.name = "Note1"
            note1.setScale(0.25)
            note1.alpha = 0
            note1.zPosition = 2.5
            note1.position = CGPoint(x: plate12.position.x + 20, y: plate12.position.y - 30)
            addChild(note1)
        }
        // شريط تجميع الأدلة
        setupInventoryBar()

        // أزرار الاتجاهات
        addDirectionButtons()

        // تحميل الأدلة
        InventoryHelper.loadEvidence(into: self, slots: inventorySlots)
    }

    func setupInventoryBar() {
        let slotSize = CGSize(width: 100, height: 120)
        let totalSlots = 5
        let spacing: CGFloat = 30
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let boxHeight: CGFloat = 150
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
    

    func setupMessageLabel() {
        let topY: CGFloat = size.height / 2 - 130
        let messageBackground = SKShapeNode(rectOf: CGSize(width: 500, height: 70), cornerRadius: 20)
        messageBackground.name = "messageBackground"
        messageBackground.fillColor = UIColor(white: 0.2, alpha: 0.85)
        messageBackground.strokeColor = .clear
        messageBackground.position = CGPoint(x: 0, y: topY - 150)
        messageBackground.alpha = 0
        messageBackground.zPosition = 15

        let messageLabel = SKLabelNode(text: "")
        messageLabel.name = "messageLabel"
        messageLabel.fontName = "Arial-BoldMT"
        messageLabel.fontSize = 30
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: 0, y: -10)
        messageLabel.zPosition = 16
        messageBackground.addChild(messageLabel)
        addChild(messageBackground)
    }

    func addDirectionButtons() {
        let buttonSize = CGSize(width: 60, height: 60)

        let rightButton = SKSpriteNode(imageNamed: "ArrowRight")
        rightButton.name = "right"
        rightButton.size = buttonSize
        rightButton.position = CGPoint(x: size.width / 2 - 80, y: -size.height / 2 + 500)
        rightButton.zPosition = 100
        addChild(rightButton)

        let downButton = SKSpriteNode(imageNamed: "ArrowDown")
        downButton.name = "down"
        downButton.size = buttonSize
        downButton.position = CGPoint(x: 0, y: -size.height / 2 + 50)
        downButton.zPosition = 100
        addChild(downButton)
        
        let leftButton = SKSpriteNode(imageNamed: "ArrowLeft")
          leftButton.name = "left"
          leftButton.size = buttonSize
          leftButton.position = CGPoint(x: -size.width / 2 + 80, y: -size.height / 2 + 500)
          leftButton.zPosition = 100
          addChild(leftButton)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "cashier" {
            if let view = self.view {
                let scene = CashierScene(size: self.size)
                scene.scaleMode = self.scaleMode
                view.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            }
            return
        }

        if touchedNode.name == "plate12" && !didRevealEvidence {
            didRevealEvidence = true

            let moveUp = SKAction.moveBy(x: 0, y: 60, duration: 0.2)
            let wait = SKAction.wait(forDuration: 0.2)
            let moveDown = moveUp.reversed()
            plate12.run(SKAction.sequence([moveUp, wait, moveDown]))

            let gearFade = SKAction.fadeIn(withDuration: 0.3)
            let gearMove = SKAction.move(to: CGPoint(x: 0, y: 120), duration: 0.5)
            let gearScale = SKAction.scale(to: 0.7, duration: 0.10)
            gear.run(SKAction.group([gearFade, gearMove, gearScale]))

            let noteFade = SKAction.fadeIn(withDuration: 0.3)
            let noteMove = SKAction.move(to: CGPoint(x: -200, y: 120), duration: 0.5)
            let noteScale = SKAction.scale(to: 0.7, duration: 0.10)
            note1.run(SKAction.group([noteFade, noteMove, noteScale]))

            run(SKAction.wait(forDuration: 1.2)) {
                if !self.gearAdded && !self.noteAdded {
                    // البحث عن أول خانتين فاضيتين في بار الأدلة
                    let emptySlots = self.inventorySlots.filter { slot in
                        let existing = self.nodes(at: slot.position).filter { $0 is SKSpriteNode && $0.name != nil }
                        return existing.isEmpty
                    }

                    guard emptySlots.count >= 2 else {
                        return
                    }

                    let gearSlotPos = emptySlots[0].position
                    let noteSlotPos = emptySlots[1].position
                    
                    let gearMove = SKAction.move(to: gearSlotPos, duration: 0.8)
                    gearMove.timingMode = .easeInEaseOut
                    let gearScale = SKAction.scale(to: 0.3, duration: 0.8)
                    self.gear.run(SKAction.group([gearMove, gearScale]))
                    self.gear.zPosition = 11

                    let noteMove = SKAction.move(to: noteSlotPos, duration: 0.8)
                    noteMove.timingMode = .easeInEaseOut
                    let noteScale = SKAction.scale(to: 0.25, duration: 0.8)
                    self.note1.run(SKAction.group([noteMove, noteScale]))
                    self.note1.zPosition = 11

                    self.gearAdded = true
                    self.noteAdded = true
                    GameState.shared.collect("Gear")
                    GameState.shared.collect("Note1")

                }
            }
        }
        
        if ["Gear", "Note1", "GKey", "Key0"].contains(touchedNode.name ?? "") {
            if let sprite = touchedNode as? SKSpriteNode {
                // لو العنصر داخل خانة، نفصله منها
                if let parent = sprite.parent, parent is SKShapeNode {
                    let newPos = parent.convert(sprite.position, to: self)
                    sprite.removeFromParent()
                    sprite.position = newPos
                    addChild(sprite)
                }

                draggedNode = sprite
                originalPosition = sprite.position

                // يكبر العنصر للسحب
                let enlarge = SKAction.scale(to: 0.7, duration: 0.2)
                sprite.run(enlarge)
            }
        }
        
        switch touchedNode.name {
            
        case "right":
            if let view = self.view {
                let scene = BoardScene(size: self.size)
                scene.scaleMode = self.scaleMode
                view.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            }
        case "down":
            let groundScene = GroundScene(size: self.size)
            groundScene.scaleMode = self.scaleMode
            view?.presentScene(groundScene, transition: .crossFade(withDuration: 0.5))
        case "left":
            let newspaperScene = NewspaperScene(size: self.size)
            newspaperScene.scaleMode = self.scaleMode
            view?.presentScene(newspaperScene, transition: .crossFade(withDuration: 0.5))

        default:
            break
        }
    }

    func showMessage(_ text: String) {
        if let bg = childNode(withName: "messageBackground") as? SKShapeNode,
           let label = bg.childNode(withName: "messageLabel") as? SKLabelNode {
            label.text = text
            bg.removeAllActions()
            bg.alpha = 1.0

            let wait = SKAction.wait(forDuration: 3.0)
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)
            bg.run(SKAction.sequence([wait, fadeOut]))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggedNode else { return }

        let location = touch.location(in: self)
        node.position = location

        // نتأكد أن العنصر المستهدف هو من العناصر المحددة
        if ["Gear", "Note1", "GKey", "Key0"].contains(node.name ?? "") {
            if node.xScale < 0.7 {
                let enlarge = SKAction.scale(to: 0.7, duration: 0.1)
                node.run(enlarge)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = draggedNode, let originalPos = originalPosition else { return }

        if node.name == "GKey", node.frame.intersects(door.frame) {
            door.texture = SKTexture(imageNamed: "DoorOpen")
            node.removeFromParent()
            GameState.shared.markAsUsed("GKey")
        } else {
            let shrink = SKAction.scale(to: 0.3, duration: 0.2)
            node.run(shrink)
            node.run(SKAction.move(to: originalPos, duration: 0.3))
        }

        draggedNode = nil
        originalPosition = nil
    }
}

