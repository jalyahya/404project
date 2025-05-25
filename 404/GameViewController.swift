//
//  GameViewController.swift
//  404
//
//  Created by Azhar on 11/05/2025.
//






import UIKit
import SpriteKit
import SwiftUI

class GameViewController: UIViewController {
    static var shared: GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.shared = self
        
        if let view = self.view as? SKView {
            let scene = StartScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        }
    }
    
    func showCloudIntro() {
        let cloudIntroVC = UIHostingController(rootView: CloudIntroView())
        
        // نعرضه داخل نفس الـ GameViewController بدون تغطية كاملة
        addChild(cloudIntroVC)
        cloudIntroVC.view.frame = view.bounds
        view.addSubview(cloudIntroVC.view)
        cloudIntroVC.didMove(toParent: self)
    }
    
    func showNewspaperScene() {
        // نحذف كل الـ SwiftUI views قبل ما نرجع للـ SpriteKit
        for child in children {
            if child is UIHostingController<CloudIntroView> {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
        
        if let view = self.view as? SKView {
            let scene = NewspaperScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene, transition: .crossFade(withDuration: 1.0))
        }
    }
}
