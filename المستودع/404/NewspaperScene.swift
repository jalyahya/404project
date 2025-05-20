//
//  NewspaperScene.swift
//  404
//
//  Created by Azhar on 17/05/2025.
//

import SpriteKit
import AVFoundation

class NewspaperScene: SKScene {

    private var newspaperNode: SKSpriteNode!
    private var readNewspaperNode: SKSpriteNode?
    private var paperPlayer: AVAudioPlayer?
    private var isReadVisible = false
    private var originalPosition = CGPoint.zero
    private var originalScale: CGFloat = 1.0
    private var inventorySlots: [SKShapeNode] = []

    var readNewspaperScale: CGFloat = 1.147
    var slideDuration: TimeInterval = 1.3
    var fadeDuration: TimeInterval = 0.0
    

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // الخلفية
        let background = SKSpriteNode(imageNamed: "BG3")
        background.zPosition = 0
        background.position = .zero
        let scale = max(size.width / background.size.width, size.height / background.size.height)
        background.setScale(scale)
        addChild(background)

        // الملح
        let salt = SKSpriteNode(imageNamed: "Salt")
        salt.name = "salt"
        salt.zPosition = 1
        salt.size = CGSize(width: 70, height: 130)
        salt.position = CGPoint(x: 520, y: 200)
        addChild(salt)

        // الفلفل الأسود
        let blackpaper = SKSpriteNode(imageNamed: "BlackPaper")
        blackpaper.name = "blackpaper"
        blackpaper.zPosition = 1
        blackpaper.size = CGSize(width: 70, height: 130)
        blackpaper.position = CGPoint(x: 450, y: 200)
        addChild(blackpaper)

        // السلطة في الوسط
        let salad = SKSpriteNode(imageNamed: "Salad1")
        salad.name = "salad"
        salad.zPosition = 1
        salad.setScale(1.1)
        salad.position = CGPoint(x: 150, y: -120)
        addChild(salad)

        // السكين يمين السلطة
        let knife = SKSpriteNode(imageNamed: "Knife")
        knife.name = "knife"
        knife.zPosition = 1
        knife.size = CGSize(width: 60, height: 500)
        knife.position = CGPoint(x: 530, y: -140)
        addChild(knife)

        // الشوكة يسار السلطة
        let fork = SKSpriteNode(imageNamed: "Fork")
        fork.name = "fork"
        fork.zPosition = 1
        fork.size = CGSize(width: 60, height: 500)
        fork.position = CGPoint(x: -230, y: -140)
        addChild(fork)

        // زر السهم (ArrowRight)
        let buttonSize = CGSize(width: 60, height: 60)
        let rightButton = SKSpriteNode(imageNamed: "ArrowRight")
        rightButton.name = "right"
        rightButton.size = buttonSize
        rightButton.position = CGPoint(x: size.width / 2 - 80, y: -size.height / 2 + 500)
        rightButton.zPosition = 100
        addChild(rightButton)

        setupNewspaper()
        setupPaperSound()
        setupInventoryBar()
        
        SoundManager.shared.stopAll()
    }

    private func setupNewspaper() {
        newspaperNode = SKSpriteNode(imageNamed: "newspaper")
        newspaperNode.name = "newspaper"
        newspaperNode.setScale(1.2)

        // تبدأ من خارج الشاشة يسار
        let startX = -size.width / 2 - newspaperNode.size.width
        let targetX = -size.width * 0.38
        let posY = -size.height / 2 + newspaperNode.size.height * 0.4
        newspaperNode.position = CGPoint(x: startX, y: posY)
        
        originalPosition = CGPoint(x: targetX, y: posY)
        originalScale = newspaperNode.xScale
        newspaperNode.zPosition = 999
        addChild(newspaperNode)

        // حركة دخول سلسة
        let moveIn = SKAction.moveTo(x: targetX, duration: 1.2)
        moveIn.timingMode = .easeOut
        newspaperNode.run(moveIn)
    }

    private func setupPaperSound() {
        if let url = Bundle.main.url(forResource: "paper", withExtension: "mp3") {
            paperPlayer = try? AVAudioPlayer(contentsOf: url)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        let tapped = nodes(at: loc)

        if isReadVisible, tapped.contains(where: { $0.name == "read_newspaper" }) {
            collapseReadNewspaper()
            return
        }

        if !isReadVisible, tapped.contains(where: { $0.name == "newspaper" }) {
            showReadNewspaper()
            return
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node.name == "right" {
            let nextScene = TablesScene(size: self.size)
            nextScene.scaleMode = self.scaleMode
            view?.presentScene(nextScene, transition: .crossFade(withDuration: 0.5))
        }
    }

    private func showReadNewspaper() {
        paperPlayer?.play()
        newspaperNode.run(.moveTo(x: -newspaperNode.size.width / 2, duration: slideDuration))
        run(.sequence([
            .wait(forDuration: slideDuration),
            .run { [weak self] in
                guard let s = self else { return }
                s.newspaperNode.isHidden = true
                s.buildReadNewspaper()
            }
        ]))
    }

    
    private func buildReadNewspaper() {
        let tex = SKTexture(imageNamed: "readnewspaper")
        let node = SKSpriteNode(texture: tex)
        node.name = "read_newspaper"
        
        node.setScale(2.7)
        node.alpha = 0
        node.zPosition = 500

        _ = tex.size().width * 2.5
        let scaledHeight = tex.size().height * 2.5

        let targetX = -size.width * 0.02
        let targetY = -size.height * 0.01

        // تبدأ من تحت
        node.position = CGPoint(x: targetX, y: -scaledHeight)
        addChild(node)
        readNewspaperNode = node

        node.run(.group([
            .move(to: CGPoint(x: targetX, y: targetY), duration: slideDuration),
            .fadeIn(withDuration: fadeDuration)
        ])) { [weak self] in
            self?.isReadVisible = true
        }
    }
    
    
    private func collapseReadNewspaper() {
        guard let node = readNewspaperNode else { return }
        node.run(.sequence([
            .moveTo(y: -node.size.height / 2, duration: slideDuration),
            .removeFromParent(),
            .run { [weak self] in
                guard let s = self else { return }
                s.newspaperNode.isHidden = false
                s.newspaperNode.position = CGPoint(x: -s.newspaperNode.size.width / 2, y: s.originalPosition.y)
                s.newspaperNode.setScale(s.originalScale)
                s.newspaperNode.run(.move(to: s.originalPosition, duration: s.slideDuration))
                s.isReadVisible = false
            }
        ]))
        readNewspaperNode = nil
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
