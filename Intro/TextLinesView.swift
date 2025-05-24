//
//  TextLinesView.swift
//  404project
//
//  Created by Rahaf ALDossari on 26/11/1446 AH.
//


import SwiftUI

struct TextLinesView: View {
    @Binding var currentLine: Int
    let lines: [String]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: geo.size.height * 0.03) {
                    ForEach(0..<lines.count, id: \.self) { index in
                        Text(index <= currentLine ? lines[index] : " ")
                            .font(.system(size: geo.size.width * 0.04, weight: .bold)) // ← مرن
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .opacity(index <= currentLine ? 1 : 0)
                            .animation(.easeInOut(duration: 1.0), value: currentLine)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, geo.size.height * -0.4) // ← مرن
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}




