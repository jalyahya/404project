//
//  Table1Scene.swift
//  404
//
//  Created by Azhar on 20/05/2025.
//

import SpriteKit

class Table1Scene: SKScene {
    
    private var inventorySlots: [SKShapeNode] = []
    private var draggedItem: SKSpriteNode?
    private var originalPosition: CGPoint?
    private var originalSize: CGSize?
    private var notebookNode: SKSpriteNode!


    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        SoundManager.shared.playCafeAmbience()

        // الخلفية
        let bg = SKSpriteNode(imageNamed: "BGT1")
        bg.zPosition = -1
        bg.position = .zero
        if let tex = bg.texture {
            let scaleX = size.width / tex.size().width
            let scaleY = size.height / tex.size().height
            bg.setScale(max(scaleX, scaleY))
        }
        addChild(bg)
        
        

        // زر الإغلاق في أعلى اليمين
        let closeButton = SKSpriteNode(imageNamed: "Close")
        closeButton.name = "closeButton"
        closeButton.setScale(0.7)
        closeButton.position = CGPoint(x: size.width / 2 - 60, y: size.height / 2 - 60)
        closeButton.zPosition = 100
        addChild(closeButton)
        
        // الملح
        let salt = SKSpriteNode(imageNamed: "Salt")
        salt.name = "salt"
        salt.zPosition = 1
        salt.size = CGSize(width: 70, height: 130)
        salt.position = CGPoint(x: 80, y: size.height / 2 - 280)
        addChild(salt)

        // الفلفل الأسود
        let blackpaper = SKSpriteNode(imageNamed: "BlackPaper")
        blackpaper.name = "blackpaper"
        blackpaper.zPosition = 1
        blackpaper.size = CGSize(width: 70, height: 130)
        blackpaper.position = CGPoint(x: -10, y: size.height / 2 - 280)
        addChild(blackpaper)
        
        notebookNode = SKSpriteNode(imageNamed: "NoteBook")
        notebookNode.name = "notebook"
        notebookNode.zPosition = 2
        notebookNode.size = CGSize(width: 436, height: 536)
        notebookNode.position = CGPoint(x: -size.width / 2 + 400, y: -120)
        addChild(notebookNode)
        
        let t1 = SKSpriteNode(imageNamed: "T1")
        t1.name = "t1"
        t1.zPosition = 1
        t1.size = CGSize(width: 180, height: 100) // تقدرين تغيرين المقاس حسب اللي تبينه
        t1.position = CGPoint(x: 500, y: -300)
        addChild(t1)
        
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
        }
        if let node = touchedNodes.first(where: { $0.name == "Key0" }),
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
        node.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = draggedItem else { return }

        // إذا لمس الـ Notebook
        if node.frame.intersects(notebookNode.frame) {
            run(SKAction.playSoundFileNamed("Note.mp3", waitForCompletion: false))
            notebookNode.texture = SKTexture(imageNamed: "NoteBookOpen")
            notebookNode.size = CGSize(width: 722, height: 536)
            node.removeFromParent()
        } else {
            // يرجع مكانه في البار
            let moveBack = SKAction.move(to: originalPosition ?? .zero, duration: 0.2)
            let scaleBack = SKAction.scale(to: 0.3, duration: 0.2)
            node.run(SKAction.group([moveBack, scaleBack])) {
                node.removeFromParent()
                if GameState.shared.hasCollectedKey0, let firstSlot = self.inventorySlots.first {
                    let keyInBar = SKSpriteNode(imageNamed: "Key1")
                    keyInBar.name = "Key0"
                    keyInBar.setScale(0.3)
                    keyInBar.position = .zero
                    keyInBar.zPosition = 1
                    firstSlot.addChild(keyInBar)
                }
            }
        }

        draggedItem = nil
        originalPosition = nil
        originalSize = nil
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
        
        // ✅ إضافة المفتاح فقط إذا تم جمعه سابقًا
        if GameState.shared.isAvailable("Key0"),
           let firstSlot = inventorySlots.first {
            
            let keyInBar = SKSpriteNode(imageNamed: "Key1")
            keyInBar.name = "Key0"
            keyInBar.setScale(0.7) // أو غيريها لحجم يناسبك
            keyInBar.position = .zero
            keyInBar.zPosition = 11
            firstSlot.addChild(keyInBar)
        }
    }
    
}
