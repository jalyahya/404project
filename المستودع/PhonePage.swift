//
//  PhonePage.swift
//  404project
//
//  Created by Jumana S on 23/05/2025.
//

import SpriteKit

class PhonePage: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .white

        // عرض صورة الورقة في وسط الشاشة
        let paper = SKSpriteNode(imageNamed: "الورقة")
        paper.position = CGPoint(x: size.width / 2, y: size.height / 2)
        paper.size = size
        paper.zPosition = -1
        addChild(paper)
    }
}
