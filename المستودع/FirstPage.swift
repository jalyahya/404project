import SpriteKit
import SwiftUI

class FirstPage: SKScene {
    private var inventorySlots: [SKShapeNode] = []
    private var crateBox: SKSpriteNode!
    private var background: SKSpriteNode!
    private var door: SKSpriteNode!
    private var keyNode: SKSpriteNode!
    private var draggedNode: SKSpriteNode?
    private var originalPosition: CGPoint?

    override func didMove(to view: SKView) {
        backgroundColor = .white
        self.anchorPoint = CGPoint(x: 0, y: 0)

        setupBackground()
        setupInventoryBar()
        addDirectionButtons()
        addKeyToInventory()
        addInteractiveButtons() // ✅ أزرار الزبالة والجوال
    }

    func setupBackground() {
        background = SKSpriteNode(imageNamed: "المستودع١١")
        background.zPosition = -1
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.aspectFillToSize(size)
        addChild(background)

        crateBox = SKSpriteNode(imageNamed: "الكراتين")
        crateBox.zPosition = 0
        crateBox.size = CGSize(width: 365.43, height: 478.88)
        crateBox.position = CGPoint(x: 550, y: 330)
        crateBox.name = "crate"
        addChild(crateBox)

        door = SKSpriteNode(imageNamed: "DoorOpen1")
        door.zPosition = 0.2
        door.size = CGSize(width: 239, height: 263)
        door.position = CGPoint(x: 493, y: 470)
        door.isHidden = true
        door.name = "door"
        addChild(door)
    }

    func addKeyToInventory() {
        keyNode = SKSpriteNode(imageNamed: "Key0")
        keyNode.name = "Key0"
        keyNode.setScale(0.25)
        keyNode.zPosition = 12
        keyNode.position = inventorySlots[0].position
        addChild(keyNode)
    }

    func addDirectionButtons() {
        let downButton = SKSpriteNode(imageNamed: "ArrowDown")
        downButton.name = "down"
        downButton.size = CGSize(width: 60, height: 60)
        downButton.position = CGPoint(x: size.width / 2, y: size.height * 0.05)
        downButton.zPosition = 100
        addChild(downButton)
    }

    func addInteractiveButtons() {
        // زر الزبالة (موقع تقديري، غيره حسب التصميم)
        let trashButton = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 100))
        trashButton.name = "trash"
        trashButton.position = CGPoint(x: size.width - 60, y: size.height * 0.2)
        trashButton.zPosition = 200
        addChild(trashButton)

        // زر الجوال (موقع تقديري، غيره حسب التصميم)
        let phoneButton = SKSpriteNode(color: .clear, size: CGSize(width: 80, height: 100))
        phoneButton.name = "phone"
        phoneButton.position = CGPoint(x: size.width * 0.04, y: size.height * 0.05)
        phoneButton.zPosition = 200
        addChild(phoneButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let tappedNode = atPoint(location)

        switch tappedNode.name {
        case "crate":
            let moveLeft = SKAction.move(to: CGPoint(x: 150, y: 275), duration: 0.5)
            let revealDoor = SKAction.run { self.door.isHidden = false }
            crateBox.run(SKAction.sequence([moveLeft, revealDoor]))

        case "Key0":
            draggedNode = keyNode
            originalPosition = keyNode.position
            keyNode.run(SKAction.scale(to: 0.4, duration: 0.1))

        case "down":
            let transition = SKTransition.push(with: .down, duration: 0.8)
            let cafeScene = CafeScene(size: self.size)
            cafeScene.scaleMode = .aspectFill
            self.view?.presentScene(cafeScene, transition: transition)

        case "trash":
            let transition = SKTransition.fade(withDuration: 1.2)
            let nextScene = TrashPage(size: self.size)
            nextScene.scaleMode = .aspectFill
            view?.presentScene(nextScene, transition: transition)

        case "phone":
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

        default:
            break
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggedNode else { return }
        node.position = touch.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = draggedNode else { return }

        if node.name == "Key0", node.frame.intersects(door.frame) {
            door.texture = SKTexture(imageNamed: "DoorClosed1")
            node.removeFromParent()

            let wait = SKAction.wait(forDuration: 0.1)
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let changeScene = SKAction.run {
                if let view = self.view {
                    let endScene = TheEnd1(size: self.size)
                    endScene.scaleMode = .aspectFill
                    view.presentScene(endScene, transition: transition)
                }
            }
            run(SKAction.sequence([wait, changeScene]))
        } else {
            node.run(SKAction.move(to: originalPosition ?? .zero, duration: 0.3))
            node.run(SKAction.scale(to: 0.25, duration: 0.2))
        }

        draggedNode = nil
        originalPosition = nil
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
