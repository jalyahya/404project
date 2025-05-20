//
//  MainPage.swift
//  404project
//
//  Created by Rahaf ALDossari on 22/11/1446 AH.
//

import SwiftUI
import SpriteKit

struct MainPage: View {
    var body: some View {
        GeometryReader { geo in
            SpriteView(scene: GameScene2(size: geo.size))

                .ignoresSafeArea()
        }
    }
}

