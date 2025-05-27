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
        anchorPoint = CGPoint(x: 0, y: 0)

        setupBackground()
        setupInventoryBar()
        addDirectionButtons()
        addKeyToInventory()
        addInteractiveButtons()
    }

    func setupBackground() {
        background = SKSpriteNode(imageNamed: "المستودع١١")
        background.zPosition = -1
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.aspectFillToSize(size)
        addChild(background)

        crateBox = SKSpriteNode(imageNamed: "الكراتين")
        crateBox.name = "crate"
        crateBox.zPosition = 0
        crateBox.size = CGSize(width: 365.43, height: 478.88)
        crateBox.position = CGPoint(x: 500, y: 330)
        addChild(crateBox)

        door = SKSpriteNode(imageNamed: "DoorOpen1")
        door.name = "door"
        door.zPosition = 0.2
        door.size = CGSize(width: 240, height: 270)
        door.position = CGPoint(x: 730, y: 260)
        door.isHidden = true
        addChild(door)
    }

    func setupInventoryBar() {
        let slotSize = CGSize(width: 65, height: 70)
        let spacing: CGFloat = 20
        let totalSlots = 5
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let topY = size.height - 130
        let boxHeight: CGFloat = 90

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

    func addKeyToInventory() {
        keyNode = SKSpriteNode(imageNamed: "Key0")
        keyNode.name = "Key0"
        keyNode.setScale(0.25)
        keyNode.zPosition = 12
        keyNode.position = inventorySlots[0].position
        addChild(keyNode)
    }

    func addDirectionButtons() {
        let buttonSize = CGSize(width: 60, height: 60)

        let downButton = SKSpriteNode(imageNamed: "ArrowDown")
        downButton.name = "down"
        downButton.size = buttonSize
        downButton.position = CGPoint(x: size.width / 2, y: 50) // وضع صحيح
        downButton.zPosition = 100
        addChild(downButton)
    }

    func addInteractiveButtons() {
        let trashButton = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 100))
        trashButton.name = "trash"
        trashButton.position = CGPoint(x: size.width - 60, y: size.height * 0.2)
        trashButton.zPosition = 200
        addChild(trashButton)

        let phoneButton = SKSpriteNode(color: .clear, size: CGSize(width: 80, height: 100))
        phoneButton.name = "phone"
        phoneButton.position = CGPoint(x: size.width * 0.04, y: size.height * 0.05)
        phoneButton.zPosition = 200
        addChild(phoneButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let tappedNode = atPoint(location)
        print("Tapped node: \(tappedNode.name ?? "none")")

        switch tappedNode.name {
        case "crate":
            let moveLeft = SKAction.move(to: CGPoint(x: 420, y: 275), duration: 0.5)
            let revealDoor = SKAction.run { self.door.isHidden = false }
            crateBox.run(SKAction.sequence([moveLeft, revealDoor]))

        case "Key0":
            draggedNode = keyNode
            originalPosition = keyNode.position
            keyNode.run(SKAction.scale(to: 0.4, duration: 0.1))

        case "down":
            print("⬇️ down tapped")
            let cafeScene = CafeScene(size: self.size)
            cafeScene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 1.0)
            self.view?.presentScene(cafeScene, transition: transition)


        case "trash":
            let transition = SKTransition.fade(withDuration: 1.2)
            let trashScene = TrashPage(size: self.size)
            trashScene.scaleMode = .aspectFill
            view?.presentScene(trashScene, transition: transition)

        case "phone":
            if let view = self.view, let rootVC = view.window?.rootViewController {
                let fadeView = UIView(frame: view.bounds)
                fadeView.backgroundColor = .black
                fadeView.alpha = 0
                view.addSubview(fadeView)

                UIView.animate(withDuration: 1.5, animations: {
                    fadeView.alpha = 1
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
                let endScene = TheEnd1(size: self.size)
                endScene.scaleMode = .aspectFill
                self.view?.presentScene(endScene, transition: transition)
            }
            run(SKAction.sequence([wait, changeScene]))
        } else {
            node.run(SKAction.move(to: originalPosition ?? .zero, duration: 0.3))
            node.run(SKAction.scale(to: 0.25, duration: 0.2))
        }

        draggedNode = nil
        originalPosition = nil
    }
}
