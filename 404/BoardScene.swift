//
//  BoardScene.swift
//  404
//
//  Created by Azhar on 13/05/2025.
//
import SpriteKit

class BoardScene: SKScene {
    var inventorySlots: [SKShapeNode] = []
    var draggedNode: SKSpriteNode?
    var originalPosition: CGPoint?
    

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // ✅ الخلفية BG1
        let background = SKSpriteNode(imageNamed: "BG1")
        background.zPosition = 0
        background.position = .zero
        let bgScale = max(size.width / background.size.width, size.height / background.size.height)
        background.setScale(bgScale)
        addChild(background)

        // ✅ السبورة
        let board = SKSpriteNode(imageNamed: "Board")
        board.zPosition = 1
        board.position = CGPoint(x: 0, y: -100)
        board.xScale = 1
        board.yScale = 0.85
        addChild(board)

        // ✅ شريط تجميع الأدلة
        setupInventoryBar()

        // ✅ زر الرجوع
        let buttonSize = CGSize(width: 60, height: 60)
        let backButton = SKSpriteNode(imageNamed: "ArrowLeft")
        backButton.name = "backToCashier"
        backButton.size = buttonSize
        backButton.position = CGPoint(x: -size.width / 2 + 80, y: -size.height / 2 + 500)
        backButton.zPosition = 100
        addChild(backButton)
        InventoryHelper.loadEvidence(into: self, slots: inventorySlots)

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        switch touchedNode.name {
        case "backToCashier":
            if let view = self.view {
                let cafeScene = CafeScene(size: self.size)
                cafeScene.scaleMode = self.scaleMode
                view.presentScene(cafeScene, transition: .crossFade(withDuration: 0.4))
            }

        case "Gear", "Note1", "GKey", "Key0":
            if let sprite = touchedNode as? SKSpriteNode {
                // إذا كان داخل خانة الأدلة، ننقله للمشهد
                if let parent = sprite.parent, parent is SKShapeNode {
                    let newPos = parent.convert(sprite.position, to: self)
                    sprite.removeFromParent()
                    sprite.position = newPos
                    sprite.zPosition = 1000
                    addChild(sprite)
                }
                draggedNode = sprite
                originalPosition = sprite.position
                sprite.run(SKAction.scale(to: 0.5, duration: 0.2))
            }

        default:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggedNode else { return }
        let location = touch.location(in: self)
        node.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let node = draggedNode {
            let moveBack = SKAction.move(to: originalPosition ?? node.position, duration: 0.2)
            let scaleBack = SKAction.scale(to: 0.3, duration: 0.2)
            node.run(SKAction.group([moveBack, scaleBack]))
        }

        draggedNode = nil
        originalPosition = nil
    }
}
