import SpriteKit

class PhonePage: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .white

        let label = SKLabelNode(text: "📱 صفحة الجوال")
        label.fontSize = 50
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
