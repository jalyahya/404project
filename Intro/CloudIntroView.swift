//
//  CloudIntroView.swift
//  404project
//
//  Created by Rahaf ALDossari on 26/11/1446 AH.
//

import SwiftUI

struct CloudIntroView: View {
    @State private var currentLine = 0
    
    let lines = [
        "في 23 اغسطس 2010",
        "راح سيكيورتي للمقهى الي يشتغل فيه خويه الكاشير",
        "علشان يحتفل بوظيفته الجديدة في البنك الي جنب المقهى",
        "لكن..."
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("1").ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    CloudsView()
                        .frame(height: geo.size.height * 0.2)
                    
                    Spacer()
                    
                    TextLinesView(currentLine: $currentLine, lines: lines)
                    
                    Spacer()
                    
                    Button(action: {
                        GameViewController.shared?.showNewspaperScene()
                    }) {
                        Image("B")
                            .resizable()
                            .frame(width: geo.size.width * 0.12, height: geo.size.width * 0.12)
                            .padding()
                    }
                }
                .onAppear {
                    showLinesSequentially()
                }
            }
        }
    }
    
    func showLinesSequentially() {
        for i in 1..<lines.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 2.0) {
                withAnimation {
                    currentLine = i
                }
            }
        }
    }
}
