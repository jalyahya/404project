//
//  Untitled.swift
//  404project
//
//  Created by shatha alsawilam on 25/11/1446 AH.
//

import SpriteKit

class SecondScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(named: "heavenly") ?? .cyan

        let phoneImage = SKSpriteNode(imageNamed: "background")
        phoneImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        phoneImage.size = CGSize(width: size.width * 0.6, height: size.height * 0.72)
        phoneImage.zPosition = -1
        addChild(phoneImage)

        let apps = [("photo", "الصور"), ("Notes", "الملاحظات"), ("Social", "تواصل")]
        let buttonSize = CGSize(width: 110, height: 110)
        let buttonSpacing: CGFloat = 150
        let totalWidth = buttonSpacing * CGFloat(apps.count - 1)
        let startX = (size.width - totalWidth) / 2
        let yPos = size.height / 2

        for (index, app) in apps.enumerated() {
            let (iconName, labelText) = app

            let button = SKSpriteNode(imageNamed: iconName)
            button.name = iconName
            button.size = buttonSize
            button.position = CGPoint(x: startX + CGFloat(index) * buttonSpacing, y: yPos)
            button.zPosition = 1
            addChild(button)

            let label = SKLabelNode(text: labelText)
            label.fontSize = 20
            label.fontColor = .black
            label.fontName = "AvenirNext-Bold"
            label.position = CGPoint(x: button.position.x, y: button.position.y - 80)
            label.zPosition = 2
            addChild(label)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        guard let name = node.name else { return }

        var nextScene: SKScene?

        switch name {
        case "photo":
            nextScene = PhotoScene(size: self.size)
        case "Notes":
            nextScene = NotesScene(size: self.size)
        case "Social":
            nextScene = SocialScene(size: self.size)
        default:
            return
        }

        guard let button = node as? SKSpriteNode, let scene = nextScene else { return }

        let scaleUp = SKAction.scale(to: 1.4, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleUp, fadeOut])

        button.run(group) { [weak self] in
            scene.scaleMode = .aspectFill
            self?.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.25))
        }
    }
}
