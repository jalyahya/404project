//
//  Table3Scene.swift
//  404
//
//  Created by Azhar on 20/05/2025.
//

import SpriteKit

class Table3Scene: SKScene {

    private var inventorySlots: [SKShapeNode] = []
    private var draggedItem: SKSpriteNode?
    private var originalPosition: CGPoint?
    private var originalSize: CGSize?
    private var isKeyCollected = false

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let bg = SKSpriteNode(imageNamed: "BGT3")
        bg.zPosition = -1
        bg.position = .zero
        if let tex = bg.texture {
            let scaleX = size.width / tex.size().width
            let scaleY = size.height / tex.size().height
            bg.setScale(max(scaleX, scaleY))
        }
        addChild(bg)

        let closeButton = SKSpriteNode(imageNamed: "Close")
        closeButton.name = "closeButton"
        closeButton.setScale(0.7)
        closeButton.position = CGPoint(x: size.width / 2 - 60, y: size.height / 2 - 60)
        closeButton.zPosition = 100
        addChild(closeButton)

        let salt = SKSpriteNode(imageNamed: "Salt")
        salt.name = "salt"
        salt.zPosition = 1
        salt.size = CGSize(width: 70, height: 130)
        salt.position = CGPoint(x: -60, y: size.height / 2 - 320)
        addChild(salt)

        let key = SKSpriteNode(imageNamed: "Key1")
        key.name = "Key0"
        key.zPosition = 0
        key.size = CGSize(width: 30, height: 90)
        key.position = CGPoint(x: -60, y: size.height / 2 - 330)
        addChild(key)

        let blackpaper = SKSpriteNode(imageNamed: "BlackPaper")
        blackpaper.name = "blackpaper"
        blackpaper.zPosition = 1
        blackpaper.size = CGSize(width: 70, height: 130)
        blackpaper.position = CGPoint(x: 20, y: size.height / 2 - 320)
        addChild(blackpaper)

        let t3 = SKSpriteNode(imageNamed: "T3")
        t3.name = "t3"
        t3.zPosition = 1
        t3.size = CGSize(width: 180, height: 100)
        t3.position = CGPoint(x: 500, y: -300)
        addChild(t3)

        setupInventoryBar()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        if touchedNodes.contains(where: { $0.name == "closeButton" }) {
            let scene = TablesScene(size: self.size)
            scene.scaleMode = self.scaleMode
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            return
        }

        if !isKeyCollected, let saltNode = childNode(withName: "salt"), touchedNodes.contains(saltNode) {
            isKeyCollected = true
            let lift = SKAction.moveBy(x: 0, y: 100, duration: 0.3)
            saltNode.run(lift)

            if let keyNode = childNode(withName: "Key0") as? SKSpriteNode {
                keyNode.zPosition = 99
                let moveToCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.3)
                let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
                let wait = SKAction.wait(forDuration: 0.4)

                if let emptySlot = inventorySlots.first(where: { $0.children.isEmpty }) {
                    let slotPosition = convert(emptySlot.position, from: emptySlot.parent!)
                    let moveToSlot = SKAction.move(to: slotPosition, duration: 0.5)
                    moveToSlot.timingMode = .easeInEaseOut
                    let scaleDown = SKAction.scale(to: 0.3, duration: 0.3)

                    let finish = SKAction.run {
                        keyNode.removeFromParent()
                        GameState.shared.collect("Key0")
                        let keyInBar = SKSpriteNode(imageNamed: "Key1")
                        keyInBar.name = "Key0"
                        keyInBar.size = CGSize(width: 40, height: 70)
                        keyInBar.zPosition = 1
                        keyInBar.position = .zero
                        emptySlot.addChild(keyInBar)
                        self.run(SKAction.playSoundFileNamed("Key.mp3", waitForCompletion: false))

                    }

                    let sequence = SKAction.sequence([moveToCenter, scaleUp, wait, moveToSlot, scaleDown, finish])
                    keyNode.run(sequence)
                }
            }
        }

        if let node = nodes(at: location).first(where: { ["Key0"].contains($0.name) }),
           let slot = node.parent as? SKShapeNode {
            draggedItem = node as? SKSpriteNode
            originalPosition = convert(node.position, from: slot)
            originalSize = node.frame.size
            draggedItem?.removeFromParent()
            draggedItem?.position = originalPosition ?? .zero
            draggedItem?.zPosition = 1000
            addChild(draggedItem!)
            draggedItem?.run(SKAction.scale(to: 0.5, duration: 0.2))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggedItem else { return }
        let location = touch.location(in: self)
        node.position = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let node = draggedItem {
            let moveBack = SKAction.move(to: originalPosition ?? node.position, duration: 0.2)
            let scaleBack = SKAction.scale(to: 0.3, duration: 0.2)
            node.run(SKAction.group([moveBack, scaleBack])) {
                node.removeFromParent()
                if let slot = self.inventorySlots.first(where: { $0.children.isEmpty }) {
                    let keyInBar = SKSpriteNode(imageNamed: "Key1")
                    keyInBar.name = "Key0"
                    keyInBar.setScale(0.3)
                    keyInBar.zPosition = 1
                    keyInBar.position = .zero
                    slot.addChild(keyInBar)
                }
            }
        }

        draggedItem = nil
        originalPosition = nil
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
}
