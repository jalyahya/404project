import SpriteKit

class FirstPage: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .white
        setupBackground()
        setupButton()
    }

    // عرض الصورة الخلفية بالحجم الصحيح
    func setupBackground() {
        let bgTexture = SKTexture(imageNamed: "المستودع")
        let bg = SKSpriteNode(texture: bgTexture)
        bg.zPosition = -1
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.aspectFillToSize(size) // استخدم الامتداد
        addChild(bg)
    }

    // الزر المخفي على الكراتين
    func setupButton() {
        let tapArea = SKSpriteNode(color: .clear, size: CGSize(width: 250, height: 300))
        tapArea.position = CGPoint(x: size.width * 0.40, y: size.height * 0.50)
        tapArea.name = "toCrates"
        addChild(tapArea)
    }

    // التفاعل
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
}
