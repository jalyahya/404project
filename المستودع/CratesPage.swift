import SpriteKit
import SwiftUI

class CratesPage: SKScene {

    private var inventorySlots: [SKShapeNode] = []
    private var crateBox: SKSpriteNode!
    private var background: SKSpriteNode!

    override func didMove(to view: SKView) {
        backgroundColor = .white
        self.anchorPoint = CGPoint(x: 0, y: 0)

        // الخلفية
        background = SKSpriteNode(imageNamed: "المستودع٢")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)

        // ✅ صورة الكراتين
        crateBox = SKSpriteNode(imageNamed: "الكراتين٢")
        crateBox.zPosition = 0
        self.crateBox.size = CGSize(width: 365.43, height: 478.88)
        self.crateBox.position = CGPoint(x: 350, y: 275.65)
        crateBox.name = "crate"
        addChild(crateBox)

        // زر شفاف فوق الزبالة
        let trashButton = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 100))
        trashButton.name = "trash"
        trashButton.position = CGPoint(x: size.width * 0.95, y: size.height * 0.24)
        addChild(trashButton)

        // زر شفاف فوق الجوال الأسود
        let phoneButton = SKSpriteNode(color: .clear, size: CGSize(width: 80, height: 100))
        phoneButton.name = "phone"
        phoneButton.position = CGPoint(x: size.width * 0.06, y: size.height * 0.07)
        addChild(phoneButton)

        // زر السهم للأسفل
        addDownArrow()

        // شريط الأدلة
        setupInventoryBar()
    }

    private func addDownArrow() {
        let downButton = SKSpriteNode(imageNamed: "ArrowDown")
        downButton.name = "down"
        downButton.size = CGSize(width: 60, height: 60)
        downButton.position = CGPoint(x: size.width / 2, y: size.height * 0.05)
        downButton.zPosition = 100
        addChild(downButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        if tappedNode.name == "trash" {
            let nextScene = TrashPage(size: size)
            nextScene.scaleMode = .aspectFill
            view?.presentScene(nextScene, transition: .fade(withDuration: 1.5))

        } else if tappedNode.name == "phone" {
            if let view = self.view, let rootVC = view.window?.rootViewController {
                let fadeView = UIView(frame: view.bounds)
                fadeView.backgroundColor = UIColor.black
                fadeView.alpha = 0.0
                view.addSubview(fadeView)

                UIView.animate(withDuration: 1.5, animations: {
                    fadeView.alpha = 1.0
                }, completion: { _ in
                    let lockScreen = UIHostingController(rootView: LockScreen())
                    lockScreen.modalPresentationStyle = .fullScreen
                    rootVC.present(lockScreen, animated: false) {
                        fadeView.removeFromSuperview()
                    }
                })
            }

        } else if tappedNode.name == "down" {
            let nextScene = CafeScene(size: size)
            nextScene.scaleMode = .aspectFill
            view?.presentScene(nextScene, transition: .fade(withDuration: 1.5))
        }
    }

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
