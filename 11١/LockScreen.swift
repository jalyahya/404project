//
//  ContentView.swift
//  11١
//
//  Created by Rahaf ALDossari on 25/11/1446 AH.
//

import SwiftUI

struct LockScreen: View {
    @State private var enteredCode = ""
    @State private var isUnlocked = false
    let correctCode = "1110"
    let phoneWidth: CGFloat = 300

    var body: some View {
        if isUnlocked {
            HomeScreen(isUnlocked: $isUnlocked)
        } else {
            ZStack {
                Color("2").ignoresSafeArea()

                VStack {
                    Spacer()

                    ZStack {
                        Image("p1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: phoneWidth)

                        VStack {
                            Spacer()

                            HStack(spacing: 20) {
                                ForEach(0..<4, id: \.self) { index in
                                    Circle()
                                        .fill(index < enteredCode.count ? Color.white : Color.white.opacity(0.3))
                                        .frame(width: 15, height: 15)
                                        .scaleEffect(index < enteredCode.count ? 1.2 : 1)
                                        .animation(.easeInOut, value: enteredCode)
                                }
                            }
                            .padding(.bottom, 50)

                            Keypad(code: $enteredCode, onCodeEntered: checkCode)
                                .frame(width: 260, height: 320)

                            Spacer()
                        }
                        .frame(width: 260, height: 460)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }

    func checkCode() {
        if enteredCode == correctCode {
            withAnimation {
                isUnlocked = true
            }
        } else {
            enteredCode = ""
        }
    }
}

