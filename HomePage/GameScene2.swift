//
//  GameScene2.swift
//  404project
//
//  Created by Rahaf ALDossari on 22/11/1446 AH.
//

import SpriteKit

class GameScene2: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        showTwoImagesSideBySide()
        addImageButtonWithLabel()
        addMovingClouds()
        addEatingCat()
    }

    func setupBackground() {
        let bgTexture = SKTexture(imageNamed: "background")
        let bg = SKSpriteNode(texture: bgTexture)
        bg.zPosition = -1
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.aspectFillToSize(size)
        addChild(bg)
    }

    func showTwoImagesSideBySide() {
        let yOffset: CGFloat = 135

        let leftTexture = SKTexture(imageNamed: "coffee")
        let leftNode = SKSpriteNode(texture: leftTexture)
        leftNode.anchorPoint = CGPoint(x: 0.638, y: 0)
        leftNode.position = CGPoint(x: size.width * 0.3, y: yOffset)
        leftNode.setScale(1.0)
        leftNode.zPosition = 1
        addChild(leftNode)

        let rightTexture = SKTexture(imageNamed: "bank")
        let rightNode = SKSpriteNode(texture: rightTexture)
        rightNode.anchorPoint = CGPoint(x: 0.6 , y: 0)
        rightNode.position = CGPoint(x: size.width * 0.8, y: yOffset);
        rightNode.setScale(1.0)
        rightNode.zPosition = 0
        addChild(rightNode)
    }

    func addImageButtonWithLabel() {
        let buttonTexture = SKTexture(imageNamed: "B")
        let buttonNode = SKSpriteNode(texture: buttonTexture)
        buttonNode.name = "imageButton"
        buttonNode.setScale(0.9)
        buttonNode.position = .zero
        buttonNode.zPosition = 2

        let labelNode = SKLabelNode(text: "Start")
        labelNode.fontName = "Arial-BoldMT"
        labelNode.fontSize = 24
        labelNode.fontColor = .black
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.position = .zero
        labelNode.zPosition = 3

        let buttonGroup = SKNode()
        buttonGroup.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        buttonGroup.zPosition = 100
        buttonGroup.addChild(buttonNode)
        buttonGroup.addChild(labelNode)

        addChild(buttonGroup)
    }

    func addMovingClouds() {
        let cloudTexture1 = SKTexture(imageNamed: "cloud1")
        let cloudTexture2 = SKTexture(imageNamed: "cloud2")

        for i in 0...1 {
            let cloud1 = SKSpriteNode(texture: cloudTexture1)
            cloud1.setScale(0.1)
            cloud1.position = CGPoint(x: size.width * CGFloat(i), y: size.height * 0.95)
            cloud1.zPosition = -0.5
            addChild(cloud1)

            let moveLeft = SKAction.moveBy(x: -size.width, y: 0, duration: 20)
            let resetPosition = SKAction.moveBy(x: size.width, y: 0, duration: 0)
            let sequence = SKAction.sequence([moveLeft, resetPosition])
            let repeatForever = SKAction.repeatForever(sequence)
            cloud1.run(repeatForever)

            let cloud2 = SKSpriteNode(texture: cloudTexture2)
            cloud2.setScale(0.3)
            cloud2.position = CGPoint(x: size.width * CGFloat(i) + size.width / 2, y: size.height * 0.95)
            cloud2.zPosition = -0.5
            addChild(cloud2)

            let moveLeft2 = SKAction.moveBy(x: -size.width, y: 0, duration: 30)
            let resetPosition2 = SKAction.moveBy(x: size.width, y: 0, duration: 0)
            let sequence2 = SKAction.sequence([moveLeft2, resetPosition2])
            let repeatForever2 = SKAction.repeatForever(sequence2)
            cloud2.run(repeatForever2)
        }
    }

    func addEatingCat() {
        let catFrames = [
            SKTexture(imageNamed: "cat1"),
            SKTexture(imageNamed: "cat2"),
            SKTexture(imageNamed: "cat3"),
            SKTexture(imageNamed: "cat4"),
            SKTexture(imageNamed: "cat3"),
            SKTexture(imageNamed: "cat4"),
            SKTexture(imageNamed: "cat3"),
            SKTexture(imageNamed: "cat4"),
            SKTexture(imageNamed: "cat2")
        ]

        let cat = SKSpriteNode(texture: catFrames[0])
        cat.setScale(0.03)
        cat.position = CGPoint(x: size.width * 0.36, y: size.height * 0.2)
        cat.zPosition = 1.5
        addChild(cat)

        let animation = SKAction.animate(with: catFrames, timePerFrame: 0.2)
        let repeatAnimation = SKAction.repeatForever(animation)
        cat.run(repeatAnimation)
    }
}
