//
//  GameViewController.swift
//  404
//
//  Created by Azhar on 11/05/2025.
//
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            let scene = Start(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // نعرضها بشكل أفقي للآيباد
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
