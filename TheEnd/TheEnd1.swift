import SpriteKit

class TheEnd1: SKScene {
    private var endButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        backgroundColor = .black

        // صورة الجريدة
        let image = SKSpriteNode(imageNamed: "fn")
        image.size = CGSize(width: 634.1, height: 808)
        image.position = CGPoint(x: size.width / 2, y: size.height / 2 + 20)
        image.zPosition = 1
        image.isUserInteractionEnabled = false
        addChild(image)

        // زر النهاية
        endButton = SKSpriteNode(imageNamed: "s")
        endButton.name = "endButton"
        endButton.size = CGSize(width: 200, height: 80)
        endButton.position = CGPoint(x: size.width / 2, y: size.height * 0.15)
        endButton.zPosition = 10
        addChild(endButton)

        // النص داخل الزر
        let label = SKLabelNode(text: "النهاية")
        label.fontSize = 30
        label.fontColor = .black
        label.fontName = "Arial-BoldMT"
        label.position = CGPoint(x: 0, y: -10)
        label.zPosition = 11
        label.name = "endButton" // <<< مهم: نفس اسم الزر
        endButton.addChild(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        // تأكد إن الضغط على الزر أو على النص داخله
        if node.name == "endButton" {
            let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
            let transitionScene = SKAction.run {
                let transition = SKTransition.fade(withDuration: 1.2)
                let startScene = StartScene(size: self.size)
                startScene.scaleMode = .aspectFill
                self.view?.presentScene(startScene, transition: transition)
            }

            // شغّل الحركة على الزر نفسه فقط (سواء ضغطت على النص أو الصورة)
            endButton.run(SKAction.sequence([scaleDown, scaleUp, transitionScene]))
        }
    }
}
