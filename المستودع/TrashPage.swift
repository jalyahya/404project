import SpriteKit

class TrashPage: SKScene {

    private var inventorySlots: [SKShapeNode] = [] // ✅ شريط الأدلة

    override func didMove(to view: SKView) {
        backgroundColor = .white

        // الخلفية (الزبالة عن قرب)
        let trashZoom = SKSpriteNode(imageNamed: "الزباله")
        trashZoom.position = CGPoint(x: size.width / 2, y: size.height / 2)
        trashZoom.aspectFillToSize(size)
        trashZoom.zPosition = -1
        addChild(trashZoom)

        // زر تفاعلي شفاف على الورقة بالنص
        let paperTapArea = SKSpriteNode(color: .clear, size: CGSize(width: 300, height: 190))
        paperTapArea.name = "paper"
        paperTapArea.position = CGPoint(x: size.width * 0.49, y: size.height * 0.50)
        addChild(paperTapArea)

        // زر إغلاق عام (يرجع لمشهد Crates)
        let closeButton = SKLabelNode(text: "✕")
        closeButton.fontSize = 70
        closeButton.fontColor = .black
        closeButton.name = "close"
        closeButton.position = CGPoint(x: size.width * 0.93, y: size.height * 0.88)
        closeButton.zPosition = 10
        addChild(closeButton)

        // ✅ شريط الأدلة
        setupInventoryBar()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        if tappedNode.name == "paper" {
            showPaper()
        } else if tappedNode.name == "close" {
            let backScene = CratesPage(size: size)
            backScene.scaleMode = .aspectFill
            view?.presentScene(backScene, transition: SKTransition.fade(withDuration: 2.0))
        } else if tappedNode.name == "paperClose" {
            childNode(withName: "zoomedPaper")?.removeFromParent()
            childNode(withName: "paperClose")?.removeFromParent()
        }
    }

    func showPaper() {
        let paper = SKSpriteNode(imageNamed: "الورقة")
        paper.name = "zoomedPaper"
        paper.position = CGPoint(x: size.width / 2, y: size.height / 2)
        paper.zPosition = 20
        paper.setScale(0.1)
        addChild(paper)

        let zoomIn = SKAction.scale(to: 1.5, duration: 0.5)
        paper.run(zoomIn)

        // زر X لإغلاق الورقة المكبرة
        let closeX = SKLabelNode(text: "✕")
        closeX.fontSize = 60
        closeX.fontColor = .black
        closeX.name = "paperClose"
        closeX.position = CGPoint(x: size.width * 0.87, y: size.height * 0.80)
        closeX.zPosition = 25
        addChild(closeX)
    }

    // ✅ دالة شريط الأدلة
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
