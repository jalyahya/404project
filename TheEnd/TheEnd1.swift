import SpriteKit

class TheEnd1: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .black

        // صورة الجريدة
        let image = SKSpriteNode(imageNamed: "fn")
        image.size = CGSize(width: size.width * 0.85, height: size.height * 0.8)
        image.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        image.zPosition = 1
        image.isUserInteractionEnabled = false  // <<< مهم جدًا
        addChild(image)

        // زر النهاية
        let button = SKSpriteNode(imageNamed: "s")
        button.name = "endButton"
        button.size = CGSize(width: 200, height: 80)
        button.position = CGPoint(x: size.width / 2, y: size.height * 0.15)
        button.zPosition = 10  // تأكدنا إنه أعلى من الصورة
        addChild(button)

        // النص فوق الزر
        let label = SKLabelNode(text: "النهاية")
        label.fontSize = 30
        label.fontColor = .black
        label.fontName = "Arial-BoldMT"
        label.position = CGPoint(x: 0, y: -10)
        label.zPosition = 11
        button.addChild(label)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node.name == "endButton" {
            let transition = SKTransition.crossFade(withDuration: 0.8)
            let startScene = StartScene(size: self.size)
            startScene.scaleMode = .aspectFill
            view?.presentScene(startScene, transition: transition)
        }
    }
}
