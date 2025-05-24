//
//  Keypad.swift
//  11١
//
//  Created by Rahaf ALDossari on 25/11/1446 AH.
//
import SwiftUI

struct Keypad: View {
    @Binding var code: String
    var onCodeEntered: () -> Void

    let buttons: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["","0","⌫"]
    ]

    var body: some View {
        VStack(spacing: 15) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 30) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            buttonTapped(button)
                        }) {
                            if button == "" {
                                Color.clear.frame(width: 60, height: 60)
                            } else {
                                Text(button)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
        }
    }

    private func buttonTapped(_ button: String) {
        switch button {
        case "⌫":
            if !code.isEmpty {
                code.removeLast()
            }
        case "":
            break
        default:
            if code.count < 4 {
                code.append(button)
                if code.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onCodeEntered()
                    }
                }
            }
        }
    }
}

