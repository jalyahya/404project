import SpriteKit

class FirstPage: SKScene {
    
    private var inventorySlots: [SKShapeNode] = []  // ✅ شريط الأدلة

    override func didMove(to view: SKView) {
        backgroundColor = .white
        setupBackground()
        setupButton()
        setupInventoryBar()  // ✅ نادينا شريط الأدلة
    }

    // الخلفية
    func setupBackground() {
        let bgTexture = SKTexture(imageNamed: "المستودع")
        let bg = SKSpriteNode(texture: bgTexture)
        bg.zPosition = -1
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.aspectFillToSize(size) // الامتداد الخاص بتكبير الصورة
        addChild(bg)
    }

    // الزر المخفي على الكراتين
    func setupButton() {
        let tapArea = SKSpriteNode(color: .clear, size: CGSize(width: 250, height: 300))
        tapArea.position = CGPoint(x: size.width * 0.40, y: size.height * 0.50)
        tapArea.name = "toCrates"
        addChild(tapArea)
    }

    // التفاعل مع الزر
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let tappedNode = atPoint(location)

        if tappedNode.name == "toCrates" {
            let nextScene = CratesPage(size: size)
            nextScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(with: .black, duration: 2.5)
            view?.presentScene(nextScene, transition: transition)
        }
    }

    private func setupInventoryBar() {
        let slotSize = CGSize(width: 65, height: 70) // ✅ نفس قياسات NewspaperScene
        let totalSlots = 5
        let spacing: CGFloat = 20
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let boxHeight: CGFloat = 90 // ✅ تصغير ارتفاع خلفية البار
        let topY: CGFloat = size.height - 130 // يبقى مكانه مرتفع

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
