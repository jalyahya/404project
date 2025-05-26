import SpriteKit

class FirstPage: SKScene {

    private var inventorySlots: [SKShapeNode] = []
    private var crateBox: SKSpriteNode!
    private var background: SKSpriteNode!

    override func didMove(to view: SKView) {
        backgroundColor = .white
        self.anchorPoint = CGPoint(x: 0, y: 0)

        setupBackground()
        setupInventoryBar()
        addDirectionButtons()
    }

    func setupBackground() {
        // ✅ الخلفية
        background = SKSpriteNode(imageNamed: "المستودع١")
        background.zPosition = -1
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.aspectFillToSize(size)
        addChild(background)

        // ✅ الكراتين
        crateBox = SKSpriteNode(imageNamed: "الكراتين١")
        crateBox.zPosition = 0
        crateBox.size = CGSize(width: 365.92, height: 484.67)
        crateBox.position = CGPoint(x: 550, y: 330)
        crateBox.name = "crate"
        addChild(crateBox)
    }

    // ✅ زر السهم (down)
    func addDirectionButtons() {
        let buttonSize = CGSize(width: 60, height: 60)
        let downButton = SKSpriteNode(imageNamed: "ArrowDown")
        downButton.name = "down"
        downButton.size = buttonSize
        downButton.position = CGPoint(x: size.width / 2, y: size.height * 0.05)
        downButton.zPosition = 100
        addChild(downButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let tappedNode = atPoint(location)

        if tappedNode.name == "crate" {
            // ✅ 1. حرك الكرتون لليسار
            let moveLeft = SKAction.move(to: CGPoint(x: 127.49, y: 275.65), duration: 0.5)

            // ✅ 2. غير الخلفية والصورة بعد الحركة
            let changeTexture = SKAction.run {
                self.background.texture = SKTexture(imageNamed: "المستودع٢")
                self.crateBox.texture = SKTexture(imageNamed: "الكراتين٢")
                self.crateBox.size = CGSize(width: 365.43, height: 478.88)
                self.crateBox.position = CGPoint(x: 350, y: 275.65)
            }

            // ✅ 3. تأخير خفيف
            let waitBeforeNextScene = SKAction.wait(forDuration: 0.8)

            // ✅ 4. الانتقال لمشهد CratesPage
            let goToCrates = SKAction.run {
                let cratesScene = CratesPage(size: self.size)
                cratesScene.scaleMode = self.scaleMode
                self.view?.presentScene(cratesScene, transition: .fade(withDuration: 1.5))
            }

            // ✅ 5. تنفيذ التسلسل
            let sequence = SKAction.sequence([moveLeft, changeTexture, waitBeforeNextScene, goToCrates])
            crateBox.run(sequence)
        

        } else if tappedNode.name == "down" {
            let cafeScene = CafeScene(size: self.size)
            cafeScene.scaleMode = self.scaleMode
            view?.presentScene(cafeScene, transition: .fade(withDuration: 1.5))
        }
    }

    // ✅ شريط الأدلة
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
