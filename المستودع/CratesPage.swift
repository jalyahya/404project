import SpriteKit

class CratesPage: SKScene {

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
}
