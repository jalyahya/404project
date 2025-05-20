

import SpriteKit

/// الـ Scene الأساسي بدون شريط الأدلة
class BaseScene: SKScene {

    // ← احتفظنا بهذي فقط لو تبين تستخدمين السحب لعناصر ثانية
    var draggedItem: SKSpriteNode?
    var originalItemPosition: CGPoint?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // ما فيه setupInventoryBar أو refreshInventory
    }

    // MARK: – Drag & Drop (تقدرين تحذفينهم إذا ما تحتاجين السحب)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let loc = t.location(in: self)

        for node in children where node is SKSpriteNode && node.contains(loc) {
            if let sprite = node as? SKSpriteNode {
                draggedItem = SKSpriteNode(texture: sprite.texture)
                draggedItem?.size = sprite.size
                draggedItem?.position = loc
                draggedItem?.zPosition = 2000
                originalItemPosition = sprite.position
                addChild(draggedItem!)
                return
            }
        }

        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first, let drag = draggedItem else { return }
        drag.position = t.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let drag = draggedItem, let orig = originalItemPosition else {
            draggedItem = nil
            originalItemPosition = nil
            return
        }

        let moveBack = SKAction.move(to: orig, duration: 0.2)
        drag.run(moveBack) {
            drag.removeFromParent()
            self.draggedItem = nil
            self.originalItemPosition = nil
        }
    }
}
