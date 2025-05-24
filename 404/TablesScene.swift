//
//  TablesScene.swift
//  404
//
//  Created by Azhar on 19/05/2025.
//


import SpriteKit

class TablesScene: SKScene {
    
    private var inventorySlots: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        SoundManager.shared.playCafeAmbience()
        
        
        // الخلفية
        let bg = SKSpriteNode(imageNamed: "BG4")
        bg.zPosition = -2
        bg.position = .zero
        if let tex = bg.texture {
            let scaleX = size.width / tex.size().width
            let scaleY = size.height / tex.size().height
            bg.setScale(max(scaleX, scaleY))
        }
        addChild(bg)
        
        // الطبقة الثانية (تصغير الحجم شوية)
        let layer = SKSpriteNode(imageNamed: "BG4-Layer1")
        layer.zPosition = -1
        layer.position = CGPoint(x: 0, y: -80)
        if let tex = layer.texture {
            let scaleX = size.width / tex.size().width
            let scaleY = size.height / tex.size().height
            layer.setScale(max(scaleX, scaleY) * 0.8)
        }
        addChild(layer)
        
        // زر الرجوع
        let buttonSize = CGSize(width: 60, height: 60)
        let leftButton = SKSpriteNode(imageNamed: "ArrowLeft")
        leftButton.name = "backButton"
        leftButton.size = buttonSize
        leftButton.position = CGPoint(x: -size.width / 2 + 80, y: -size.height / 2 + 500)
        leftButton.zPosition = 100
        addChild(leftButton)
        
        // زر السهم اليمين
        let rightButton = SKSpriteNode(imageNamed: "ArrowRight")
        rightButton.name = "rightButton"
        rightButton.size = buttonSize
        rightButton.position = CGPoint(x: size.width / 2 - 80, y: -size.height / 2 + 500)
        rightButton.zPosition = 100
        addChild(rightButton)
        
        setupInventoryBar()
        addTables()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let location = t.location(in: self)
        let touchedNodes = nodes(at: location)
        
        if touchedNodes.contains(where: { $0.name == "backButton" }) {
            let scene = NewspaperScene(size: self.size)
            scene.scaleMode = self.scaleMode
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            return
        }
        
        if touchedNodes.contains(where: { $0.name == "rightButton" }) {
            let scene = CafeScene(size: self.size)
            scene.scaleMode = self.scaleMode
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            return
        }
        
        for node in touchedNodes {
            switch node.name {
            case "table_1":
                let scene = Table1Scene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            case "table_2":
                let scene = Table2Scene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            case "table_3":
                let scene = Table3Scene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            case "table_4":
                let scene = Table4Scene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            default:
                break
            }
        }
    }
    
    func setupInventoryBar() {
        let slotSize = CGSize(width: 80, height: 90)
        let totalSlots = 5
        let spacing: CGFloat = 30
        let totalWidth = CGFloat(totalSlots) * slotSize.width + CGFloat(totalSlots - 1) * spacing
        let boxHeight: CGFloat = 110
        let topY: CGFloat = size.height / 2 - 135
        
        let backgroundRect = CGSize(width: totalWidth + 60, height: boxHeight)
        let inventoryBackground = SKShapeNode(rectOf: backgroundRect, cornerRadius: 20)
        inventoryBackground.fillColor = UIColor(white: 0.2, alpha: 0.6)
        inventoryBackground.strokeColor = .clear
        inventoryBackground.position = CGPoint(x: 0, y: topY)
        inventoryBackground.zPosition = 9
        addChild(inventoryBackground)
        
        let startX = totalWidth / 2 - slotSize.width / 2
        let softGrayColor = UIColor(white: 0.35, alpha: 0.7)
        
        for i in 0..<totalSlots {
            let slot = SKShapeNode(rectOf: slotSize, cornerRadius: 10)
            slot.fillColor = softGrayColor
            slot.strokeColor = .clear
            slot.position = CGPoint(x: startX - CGFloat(i) * (slotSize.width + spacing), y: topY)
            slot.zPosition = 10
            inventorySlots.append(slot)
            addChild(slot)
        }
    }
    
    func addTables() {
        let tableImages = ["Table1", "Table2", "Table3", "Table4"]
        let labelImages = ["T1Tables", "T2Tables", "T3Tables", "T4Tables"]
        
        let positions: [CGPoint] = [
            CGPoint(x: -295, y: 100),
            CGPoint(x: 250, y: 100),
            CGPoint(x: -295, y: -285),
            CGPoint(x: 250, y: -285)
        ]
        
        let scales: [(x: CGFloat, y: CGFloat)] = Array(repeating: (1.01, 1.03), count: 4)
        
        for index in 0..<4 {
            let table = SKSpriteNode(imageNamed: tableImages[index])
            table.name = "table_\(index + 1)"
            table.position = positions[index]
            table.xScale = scales[index].x
            table.yScale = scales[index].y
            table.zPosition = 5
            addChild(table)
            
            if index == 3 {
                let coffee = SKSpriteNode(imageNamed: "CoffeeCupTables")
                coffee.setScale(0.5)
                coffee.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                coffee.position = CGPoint(
                    x: table.position.x + 60,
                    y: table.position.y - 20
                )
                coffee.zPosition = 6
                addChild(coffee)
            }
            
            if index == 0 {
                let notebook = SKSpriteNode(imageNamed: "NoteBookTables")
                notebook.setScale(0.5)
                notebook.anchorPoint = CGPoint(x: 0.5, y: 0.5) // الوسط
                notebook.position = CGPoint(
                    x: table.position.x - 60, // ميلان لليسار
                    y: table.position.y + 10  // ارتفاع فوق الطاولة
                )
                notebook.zPosition = 6
                addChild(notebook)
                
                let salt = SKSpriteNode(imageNamed: "SaltTables")
                salt.setScale(0.5)
                salt.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                salt.position = CGPoint(
                    x: notebook.position.x + 80, // يمين
                    y: notebook.position.y + 60  // أعلى
                )
                salt.zPosition = 7
                addChild(salt)
                
                // BlackPaperTables (يسار فوق)
                let blackpaper = SKSpriteNode(imageNamed: "BlackPaperTables")
                blackpaper.setScale(0.5)
                blackpaper.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                blackpaper.position = CGPoint(
                    x: notebook.position.x + 50, // يسار
                    y: notebook.position.y + 60  // أعلى
                )
                blackpaper.zPosition = 7
                addChild(blackpaper)
                
                // KnifeTables
                let knife = SKSpriteNode(imageNamed: "KnifeTables")
                knife.setScale(0.5)
                knife.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                knife.position = CGPoint(
                    x: table.position.x + 570,
                    y: table.position.y + 10
                )
                knife.zPosition = 6
                addChild(knife)
                
                // Salad2Tables
                let salad = SKSpriteNode(imageNamed: "Salad2Tables")
                salad.setScale(0.5)
                salad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                salad.position = CGPoint(
                    x: table.position.x + 500,
                    y: table.position.y + 10
                )
                salad.zPosition = 6
                addChild(salad)
                
                // FonkTables
                let fork = SKSpriteNode(imageNamed: "ForkTables")
                fork.setScale(0.5)
                fork.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                fork.position = CGPoint(
                    x: table.position.x + 430,
                    y: table.position.y + 10
                )
                fork.zPosition = 6
                addChild(fork)
                
                // SaltTables فوق الشوكة
                let saltAboveFork = SKSpriteNode(imageNamed: "SaltTables")
                saltAboveFork.setScale(0.5)
                saltAboveFork.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                saltAboveFork.position = CGPoint(
                    x: fork.position.x,
                    y: fork.position.y + 60
                )
                saltAboveFork.zPosition = 7
                addChild(saltAboveFork)
                
                // BlackPaperTables فوق الشوكة
                let blackPaperAboveFork = SKSpriteNode(imageNamed: "BlackPaperTables")
                blackPaperAboveFork.setScale(0.5)
                blackPaperAboveFork.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                blackPaperAboveFork.position = CGPoint(
                    x: fork.position.x + 30,
                    y: fork.position.y + 70
                )
                blackPaperAboveFork.zPosition = 7
                addChild(blackPaperAboveFork)
                
            }
            
            
            if index == 2 {
                let saltT3 = SKSpriteNode(imageNamed: "SaltTables")
                saltT3.setScale(0.5)
                saltT3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                saltT3.position = CGPoint(
                    x: table.position.x - 20,
                    y: table.position.y + 70
                )
                saltT3.zPosition = 6
                addChild(saltT3)
                
                let blackPaperT3 = SKSpriteNode(imageNamed: "BlackPaperTables")
                blackPaperT3.setScale(0.5)
                blackPaperT3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                blackPaperT3.position = CGPoint(
                    x: table.position.x + 10,
                    y: table.position.y + 70
                )
                blackPaperT3.zPosition = 6
                addChild(blackPaperT3)
            }
            
            
            // ✅ تسمية T1-T4 في الزاوية اليمنى السفلية لكل طاولة
            let label = SKSpriteNode(imageNamed: labelImages[index])
            label.setScale(0.5)
            label.anchorPoint = CGPoint(x: 1, y: 0)
            let offsetX: CGFloat = 10
            let offsetY: CGFloat = 10
            label.position = CGPoint(x: table.frame.maxX - offsetX, y: table.frame.minY + offsetY)
            label.zPosition = 6
            addChild(label)
        }
    }
    
}

