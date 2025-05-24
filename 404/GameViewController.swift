//
//  GameViewController.swift
//  404
//
//  Created by Azhar on 11/05/2025.
//







import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            view.ignoresSiblingOrder = true
            
            let scene = TablesScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }
}




