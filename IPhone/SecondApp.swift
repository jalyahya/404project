//
//  SecondAppView.swift
//  11١
//
//  Created by Rahaf ALDossari on 25/11/1446 AH.
//


import SwiftUI

struct SecondApp: View {
    var backAction: () -> Void

    let phoneWidth: CGFloat = 300
    let buttonSize: CGFloat = 50

    var body: some View {
        ZStack {
            Color("2").ignoresSafeArea()

            VStack {
                Spacer()

                ZStack {
                    Image("p3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: phoneWidth)

                    GeometryReader { geo in
                        let imageWidth = geo.size.width
                        let imageHeight = geo.size.height

                        Button(action: backAction) {
                            Color.clear
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        .contentShape(Rectangle())
                        .position(
                            x: imageWidth * 0.5,
                            y: imageHeight * 0.95
                        )
                    }
                    .frame(width: phoneWidth, height: phoneWidth * (16/9))
                }

                Spacer()
            }
        }
    }
}
