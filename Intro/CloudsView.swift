//
//  CloudsView.swift
//  404project
//
//  Created by Rahaf ALDossari on 26/11/1446 AH.
//


import SwiftUI

struct CloudsView: View {
    @State private var cloudOffsets: [CGFloat] = []

    let cloudHeights: [CGFloat] = [-300, -70, 250, -600]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                movingCloud(imageName: "IC1", index: 0, moveRight: true, geo: geo)
                movingCloud(imageName: "IC2", index: 1, moveRight: true, geo: geo)
                movingCloud(imageName: "IC3", index: 2, moveRight: false, geo: geo)
                movingCloud(imageName: "IC4", index: 3, moveRight: false, geo: geo)
            }
            .onAppear {
                cloudOffsets = [
                    -geo.size.width * 0.5,
                    -geo.size.width * 0.5,
                    geo.size.width * 0.3,
                    geo.size.width * 0.6
                ]
                startMoving(geo: geo)
            }
        }
        .ignoresSafeArea()
    }

    func movingCloud(imageName: String, index: Int, moveRight: Bool, geo: GeometryProxy) -> some View {
        Image(imageName)
            .resizable()
            .frame(
                width: geo.size.width * 1,
                height: geo.size.height * 6
            )
            .opacity(0.85)
            .offset(
                x: cloudOffsets.count > index ? cloudOffsets[index] : 0,
                y: cloudHeights.count > index ? cloudHeights[index] : 0
            )
            .animation(.linear(duration: 0.01), value: cloudOffsets)
    }

    func startMoving(geo: GeometryProxy) {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            for i in 0..<cloudOffsets.count {
                let speed: CGFloat = (i % 2 == 0) ? 0.3 : 0.2

                if i < 2 {
                    cloudOffsets[i] += speed
                    if cloudOffsets[i] > geo.size.width * 1.5 {
                        cloudOffsets[i] = -geo.size.width * 0.8
                    }
                } else {
                    cloudOffsets[i] -= speed
                    if cloudOffsets[i] < -geo.size.width * 0.8 {
                        cloudOffsets[i] = geo.size.width * 1.5
                    }
                }
            }
        }
    }
}
