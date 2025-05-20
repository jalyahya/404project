import SpriteKit

extension SKSpriteNode {
    func aspectFillToSize(_ fillSize: CGSize) {
        let textureSize = texture?.size() ?? CGSize(width: 1, height: 1)
        let widthRatio = fillSize.width / textureSize.width
        let heightRatio = fillSize.height / textureSize.height
        let scaleRatio = max(widthRatio, heightRatio)
        self.size = CGSize(
            width: textureSize.width * scaleRatio,
            height: textureSize.height * scaleRatio
        )
    }
}
