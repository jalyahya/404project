//
//  Table2Scene.swift
//  404
//
//  Created by Azhar on 20/05/2025.
//

import SpriteKit

class Table2Scene: SKScene {
    
    private var inventorySlots: [SKShapeNode] = []
    private var isKnifeCollected = false


    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        
        SoundManager.shared.playCafeAmbience()

        
        // الخلفية
        let bg = SKSpriteNode(imageNamed: "BGT2")
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
        
        // الملح (يمين)
        let salt = SKSpriteNode(imageNamed: "Salt")
        salt.name = "salt"
        salt.zPosition = 1
        salt.size = CGSize(width: 70, height: 130)
        salt.position = CGPoint(x: -380, y: 180)
        addChild(salt)

        // الفلفل الأسود (جنب الملح يمين شوي)
        let blackpaper = SKSpriteNode(imageNamed: "BlackPaper")
        blackpaper.name = "blackpaper"
        blackpaper.zPosition = 1
        blackpaper.size = CGSize(width: 70, height: 130)
        blackpaper.position = CGPoint(x: -300, y: 210)
        addChild(blackpaper)
        
        
        // الشوكة - جهة اليسار
        let fork = SKSpriteNode(imageNamed: "Fork")
        fork.name = "fork"
        fork.zPosition = 1
        fork.size = CGSize(width: 60, height: 500)
        fork.position = CGPoint(x: -360, y: -140)
        addChild(fork)

        // السكين - جهة اليمين
        let knife = SKSpriteNode(imageNamed: "Knife")
        knife.name = "knife"
        knife.zPosition = 1
        knife.size = CGSize(width: 60, height: 500)
        knife.position = CGPoint(x: 330, y: -140)
        addChild(knife)

        // السلطة في المنتصف
        let salad = SKSpriteNode(imageNamed: "Salad2")
        salad.name = "salad"
        salad.zPosition = 1
        salad.size = CGSize(width: 500, height: 500)
        salad.position = CGPoint(x: -18, y: -140)
        addChild(salad)
        
        let t2 = SKSpriteNode(imageNamed: "T2")
        t2.name = "t2"
        t2.zPosition = 1
        t2.size = CGSize(width: 180, height: 100)
        t2.position = CGPoint(x: 500, y: -300)
        addChild(t2)
        
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
        if !isKnifeCollected, let knifeNode = childNode(withName: "knife"), touchedNodes.contains(knifeNode) {
            isKnifeCollected = true
            knifeNode.zPosition = 99

            let moveToCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.3)
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
            let wait = SKAction.wait(forDuration: 0.4)

            if let emptySlot = inventorySlots.first(where: { $0.children.isEmpty }) {
                let slotPosition = convert(emptySlot.position, from: emptySlot.parent!)
                let moveToSlot = SKAction.move(to: slotPosition, duration: 0.5)
                moveToSlot.timingMode = .easeInEaseOut
                let scaleDown = SKAction.scale(to: 0.3, duration: 0.3)

                let finish = SKAction.run {
                    knifeNode.removeFromParent()

                    let knifeInBar = SKSpriteNode(imageNamed: "Knife")
                    knifeInBar.name = "Knife"
                    knifeInBar.size = CGSize(width: 25, height: 70)
                    knifeInBar.zPosition = 1
                    knifeInBar.position = .zero
                    emptySlot.addChild(knifeInBar)
                }

                let sequence = SKAction.sequence([moveToCenter, scaleUp, wait, moveToSlot, scaleDown, finish])
                knifeNode.run(sequence)
            }
        }
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
