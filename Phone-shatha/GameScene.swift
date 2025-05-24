//
//  Untitled.swift
//  404project
//
//  Created by shatha alsawilam on 25/11/1446 AH.
//
import SpriteKit

class GameScene: SKScene {
    
    let correctCode = "1110"
    var enteredCode = ""
    var codeDots: [SKShapeNode] = []
    var phoneImage: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(named: "heavenly") ?? .cyan
        
        setupPhoneImage()
        createCodeDots()
        createNumberButtons()
    }
    
    func setupPhoneImage() {
        phoneImage = SKSpriteNode(imageNamed: "جوال اللعبه")
        phoneImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        phoneImage.size = CGSize(width: size.width * 0.6, height: size.height * 0.72)
        phoneImage.zPosition = -1
        addChild(phoneImage)
    }

    func createCodeDots() {
        let dotSpacing: CGFloat = 50
        let totalWidth = dotSpacing * 3
        let startX = (size.width - totalWidth) / 2
        let yPosition = size.height * 0.6
        
        for i in 0..<4 {
            let dot = SKShapeNode(circleOfRadius: 12)
            dot.strokeColor = .black
            dot.fillColor = .clear
            dot.lineWidth = 2
            dot.position = CGPoint(x: startX + CGFloat(i) * dotSpacing, y: yPosition)
            dot.zPosition = 10
            addChild(dot)
            codeDots.append(dot)
        }
    }
    
    func createNumberButtons() {
        let buttonRadius: CGFloat = 32
        let spacing: CGFloat = 80
        let startX = size.width / 2 - spacing
        let startY = size.height * 0.52
        
        var number = 1
        for row in 0..<3 {
            for col in 0..<3 {
                let x = startX + CGFloat(col) * spacing
                let y = startY - CGFloat(row) * spacing
                createButton(number: "\(number)", x: x, y: y, radius: buttonRadius)
                number += 1
            }
        }
        createButton(number: "0", x: size.width / 2, y: startY - 3 * spacing, radius: buttonRadius)
    }

    func createButton(number: String, x: CGFloat, y: CGFloat, radius: CGFloat) {
        let button = SKShapeNode(circleOfRadius: radius)
        button.position = CGPoint(x: x, y: y)
        button.fillColor = SKColor.black.withAlphaComponent(0.25)
        button.strokeColor = .darkGray
        button.lineWidth = 2
        button.name = number
        button.zPosition = 5

        let shadow = SKShapeNode(circleOfRadius: radius)
        shadow.position = CGPoint(x: 3, y: -3)
        shadow.fillColor = .black
        shadow.alpha = 0.2
        shadow.zPosition = -1
        button.addChild(shadow)

        let label = SKLabelNode(text: number)
        label.fontColor = .white
        label.fontSize = 24
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = number
        button.addChild(label)
        
        addChild(button)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let node = atPoint(location) as? SKNode,
           let name = node.name,
           "0123456789".contains(name) {
            addDigit(name)
        }
    }
    
    func addDigit(_ digit: String) {
        guard enteredCode.count < 4 else { return }
        
        enteredCode.append(digit)
        codeDots[enteredCode.count - 1].fillColor = .black
        
        if enteredCode.count == 4 {
            checkCode()
        }
    }
    
    func checkCode() {
        if enteredCode == correctCode {
            print("✅ كود صحيح")
            
            let secondScene = SecondScene(size: self.size)
            secondScene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 0.6)
            self.view?.presentScene(secondScene, transition: transition)
            
        } else {
            print("❌ كود خطأ")
            shakeDots()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.enteredCode = ""
                self.codeDots.forEach { $0.fillColor = .clear }
            }
        }
    }

    func shakeDots() {
        let moveLeft = SKAction.moveBy(x: -8, y: 0, duration: 0.05)
        let moveRight = SKAction.moveBy(x: 16, y: 0, duration: 0.05)
        let moveBack = SKAction.moveBy(x: -8, y: 0, duration: 0.05)
        let shake = SKAction.sequence([moveLeft, moveRight, moveBack])
        let shakeAll = SKAction.repeat(shake, count: 2)

        codeDots.forEach { $0.run(shakeAll) }
    }
}

