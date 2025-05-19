import SpriteKit

class TrashPage: SKScene {

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
            view?.presentScene(backScene, transition: SKTransition.fade(withDuration: 2.5))
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
}
