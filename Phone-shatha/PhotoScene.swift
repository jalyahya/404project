//
//  Untitled.swift
//  404project
//
//  Created by shatha alsawilam on 25/11/1446 AH.
//

import SpriteKit

class PhotoScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(named: "heavenly") ?? .cyan

        let photo = SKSpriteNode(imageNamed: "photo1")
        photo.position = CGPoint(x: size.width / 2, y: size.height / 2)
        photo.size = CGSize(width: size.width * 0.6, height: size.height * 0.72)
        addChild(photo)

        let backButton = SKLabelNode(text: "رجوع")
        backButton.fontSize = 24
        backButton.fontColor = .white
        backButton.position = CGPoint(x: 60, y: size.height - 50)
        backButton.name = "backButton"
        addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let node = atPoint(location) as? SKLabelNode, node.name == "backButton", let view = self.view {
            let moveUp = SKAction.moveBy(x: 0, y: size.height, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let group = SKAction.group([moveUp, fadeOut])

            run(group) {
                let secondScene = SecondScene(size: self.size)
                secondScene.scaleMode = .aspectFill
                view.presentScene(secondScene)
            }
        }
    }
}
