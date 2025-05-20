//
//  Table4Scene.swift
//  404
//
//  Created by Azhar on 20/05/2025.
//

import SpriteKit

class Table4Scene: SKScene {
    
    private var inventorySlots: [SKShapeNode] = []


    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        
        SoundManager.shared.playCafeAmbience()
        
        // الخلفية
        let bg = SKSpriteNode(imageNamed: "BGT4")
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
        
        let t4 = SKSpriteNode(imageNamed: "T4")
        t4.name = "t4"
        t4.zPosition = 1
        t4.size = CGSize(width: 180, height: 100)
        t4.position = CGPoint(x: 500, y: -300)
        addChild(t4)
        
        
        let coffeeCup = SKSpriteNode(imageNamed: "CoffeCup")
        coffeeCup.name = "coffeeCup"
        coffeeCup.zPosition = 1
        coffeeCup.size = CGSize(width: 422, height: 360) // عدّلي المقاس لو تبين
        coffeeCup.position = CGPoint(x: 220, y: -120) // يمين تحت + مرفوع شوي
        addChild(coffeeCup)
        
        
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
