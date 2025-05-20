//
//  GroundScene.swift
//  404
//
//  Created by Azhar on 14/05/2025.
//
import SpriteKit

class GroundScene: SKScene {
    var ground: SKSpriteNode!
    var gKey: SKSpriteNode!
    var dsound: SKSpriteNode!
    var draggedNode: SKSpriteNode?
    var originalPosition: CGPoint?

    var inventorySlots: [SKShapeNode] = []

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        ground = SKSpriteNode(imageNamed: "Ground")
        ground.zPosition = 0
        ground.position = .zero
        let scale = max(size.width / ground.size.width, size.height / ground.size.height)
        ground.setScale(scale)
        addChild(ground)

        gKey = SKSpriteNode(imageNamed: "GKey")
        gKey.name = "gKey"
        gKey.setScale(0.4)
        gKey.position = CGPoint(x: -190, y: -200)
        gKey.zPosition = 2
        gKey.isHidden = true
        addChild(gKey)

        dsound = SKSpriteNode(imageNamed: "DSound")
        dsound.name = "dsound"
        dsound.size = CGSize(width: 140, height: 490)
        dsound.position = CGPoint(x: gKey.position.x - 6, y: gKey.position.y - 12)
        dsound.zPosition = gKey.zPosition + 1
        addChild(dsound)

        setupInventoryBar()
        loadCollectedEvidence()
        if !GameState.shared.hasCollected("Knife") {
            GameState.shared.collect("Knife")
        }
        loadCollectedEvidence()
        setupMessageLabel()
        addDirectionButtons()
    }

    func setupInventoryBar() {
        let slotSize = CGSize(width: 80, height: 90)
        let totalSlots = 5
        let spacing: CGFloat = 30
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let boxHeight: CGFloat = 110
        let topY: CGFloat = size.height / 2 - 135

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

    func loadCollectedEvidence() {
        var currentSlotIndex = 0

        for evidenceName in GameState.shared.collectedEvidence {
            // لا تضيف الأدلة اللي تم استخدامها
            if GameState.shared.hasUsed(evidenceName) { continue }
            if currentSlotIndex >= inventorySlots.count { break }

            let node = SKSpriteNode(imageNamed: evidenceName)
            node.name = evidenceName
            node.zPosition = 11
            node.position = inventorySlots[currentSlotIndex].position

            switch evidenceName {
            case "Knife": node.setScale(0.03)
            case "Note1": node.setScale(0.25)
            case "Gear": node.setScale(0.3)
            case "GKey": node.setScale(0.3)
            default: node.setScale(0.3)
            }

            addChild(node)
            currentSlotIndex += 1
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

    func addDirectionButtons() {
        let upButton = SKSpriteNode(imageNamed: "ArrowUp")
        upButton.name = "up"
        upButton.size = CGSize(width: 60, height: 60)
        upButton.position = CGPoint(x: 0, y: -size.height / 2 + 990)
        upButton.zPosition = 100
        addChild(upButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        // التعامل مع السكين
        if touchedNode.name == "Knife" {
            draggedNode = touchedNode as? SKSpriteNode
            originalPosition = draggedNode?.position
            draggedNode?.setScale(0.07)

        // التعامل مع المفتاح
        } else if touchedNode.name == "GKey" {
            draggedNode = touchedNode as? SKSpriteNode
            originalPosition = draggedNode?.position
        }
        else if touchedNode.name == "up" {
            let cafeScene = CafeScene(size: self.size)
            cafeScene.scaleMode = self.scaleMode
            view?.presentScene(cafeScene, transition: .crossFade(withDuration: 0.5))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggedNode else { return }

        let location = touch.location(in: self)
        node.position = location

        if node.name == "GKey", node.xScale < 1.0 {
            let enlarge = SKAction.scale(to: 0.7, duration: 0.1)
            node.run(enlarge)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = draggedNode, let originalPos = originalPosition else { return }

        if node.frame.intersects(dsound.frame) && !GameState.shared.hasUsed("Knife") {
            GameState.shared.markAsUsed("Knife")
            dsound.run(SKAction.moveBy(x: -150, y: 0, duration: 0.5))

            gKey.isHidden = false
            let moveToCenter = SKAction.move(to: CGPoint(x: 0, y: 120), duration: 0.5)
            let scaleUp = SKAction.scale(to: 0.7, duration: 0.5)
            let wait = SKAction.wait(forDuration: 0.5)
            
            let moveToInventory = SKAction.run {
                // البحث عن أول خانة فاضية
                var emptySlot: SKShapeNode?

                for slot in self.inventorySlots {
                    let nodesInSlot = self.nodes(at: slot.position).filter { $0 is SKSpriteNode && $0.name != nil }
                    if nodesInSlot.isEmpty {
                        emptySlot = slot
                        break
                    }
                }

                if let slot = emptySlot {
                    self.gKey.removeAllActions()
                    self.gKey.name = "GKey"
                    self.gKey.isUserInteractionEnabled = false
                    self.gKey.zPosition = 11

                    self.gKey.run(SKAction.group([
                        SKAction.move(to: slot.position, duration: 0.5),
                        SKAction.scale(to: 0.3, duration: 0.5)
                    ]))

                    GameState.shared.collect("GKey")
                } else {
                }
            }

            gKey.run(SKAction.sequence([scaleUp, moveToCenter, wait, moveToInventory]))
            node.removeFromParent()
        } else {
            if node.name == "GKey" {
                let shrink = SKAction.scale(to: 0.3, duration: 0.2)
                node.run(shrink)
            } else if node.name == "Knife" {
                node.setScale(0.03)
            }
            node.run(SKAction.move(to: originalPos, duration: 0.3))
        }

        draggedNode = nil
        originalPosition = nil
    }
}


