//
//  InventoryHelper.swift
//  404
//
//  Created by Azhar on 14/05/2025.
//

import SpriteKit

class InventoryHelper {
    static func loadEvidence(into scene: SKScene, slots: [SKShapeNode]) {
        for evidenceName in GameState.shared.collectedEvidence {
            // تجاهل الأدلة المستخدمة
            if GameState.shared.hasUsed(evidenceName) { continue }

            // البحث عن أول خانة فاضية
            var emptySlotIndex: Int?
            for (i, slot) in slots.enumerated() {
                let existingNodes = scene.nodes(at: slot.position).filter { $0 is SKSpriteNode && $0.name != nil }
                if existingNodes.isEmpty {
                    emptySlotIndex = i
                    break
                }
            }

            // إذا ما فيه خانة فاضية، تجاهل هذا الدليل
            guard let index = emptySlotIndex else { continue }

            // إنشاء عقدة الدليل
            let node = SKSpriteNode(imageNamed: evidenceName)
            node.name = evidenceName
            node.zPosition = 11
            node.position = slots[index].position

            // تحديد الحجم حسب نوع الدليل
            switch evidenceName {
            case "Knife": node.setScale(0.03)
            case "Note1": node.setScale(0.25)
            case "Gear": node.setScale(0.3)
            case "GKey": node.setScale(0.3)
            default: node.setScale(0.3)
            }

            // إضافة الدليل للمشهد
            scene.addChild(node)
        }
    }
}
