import SpriteKit

class CratesPage: SKScene {

    private var inventorySlots: [SKShapeNode] = []  // ✅ شريط الأدلة

    override func didMove(to view: SKView) {
        backgroundColor = .white

        // الخلفية: المستودع بعد تحريك الكراتين
        let background = SKSpriteNode(imageNamed: "المستودع٢")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)

        // زر شفاف فوق الزبالة
        let trashButton = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 100))
        trashButton.name = "trash"
        trashButton.position = CGPoint(x: size.width * 0.95, y: size.height * 0.24)
        addChild(trashButton)

        // زر شفاف فوق الجوال الأسود يسار
        let phoneButton = SKSpriteNode(color: .clear, size: CGSize(width: 80, height: 100))
        phoneButton.name = "phone"
        phoneButton.position = CGPoint(x: size.width * 0.06, y: size.height * 0.07)
        addChild(phoneButton)

        // ✅ نادينا شريط الأدلة
        setupInventoryBar()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        if tappedNode.name == "trash" {
            let nextScene = TrashPage(size: size)
            nextScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(with: .black, duration: 2.5)
            view?.presentScene(nextScene, transition: transition)

        } else if tappedNode.name == "phone" {
            let phoneScene = PhonePage(size: size)
            phoneScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(with: .black, duration: 2.5)
            view?.presentScene(phoneScene, transition: transition)
        }
    }

    // ✅ نفس تصميم البار في FirstPage
    private func setupInventoryBar() {
        let slotSize = CGSize(width: 65, height: 70)
        let totalSlots = 5
        let spacing: CGFloat = 20
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let boxHeight: CGFloat = 90
        let topY: CGFloat = size.height - 130

        let inventoryBackground = SKShapeNode(rectOf: CGSize(width: totalWidth + 40, height: boxHeight), cornerRadius: 20)
        inventoryBackground.fillColor = UIColor(white: 0.2, alpha: 0.6)
        inventoryBackground.strokeColor = .clear
        inventoryBackground.position = CGPoint(x: size.width / 2, y: topY)
        inventoryBackground.zPosition = 9
        addChild(inventoryBackground)

        let softGrayColor = UIColor(white: 0.35, alpha: 0.7)
        let startX = (size.width / 2) - (totalWidth / 2) + (slotSize.width / 2)

        for i in 0..<totalSlots {
            let slot = SKShapeNode(rectOf: slotSize, cornerRadius: 10)
            slot.fillColor = softGrayColor
            slot.strokeColor = .clear
            slot.position = CGPoint(x: startX + CGFloat(i) * (slotSize.width + spacing), y: topY)
            slot.zPosition = 10
            inventorySlots.append(slot)
            addChild(slot)
        }
    }
}
