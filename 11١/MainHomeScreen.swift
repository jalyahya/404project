//
//  MainHomeScreen.swift
//  11١
//
//  Created by Rahaf ALDossari on 25/11/1446 AH.
//

import SwiftUI

struct HomeScreen: View {
    @Binding var isUnlocked: Bool
    @State private var selectedApp: AppType? = nil
    let phoneWidth: CGFloat = 300

    enum AppType {
        case first, second, third
    }

    var body: some View {
        if let app = selectedApp {
            switch app {
            case .first:
                FirstApp(backAction: { selectedApp = nil })
            case .second:
                SecondApp(backAction: { selectedApp = nil })
            case .third:
                ThirdApp(backAction: { selectedApp = nil })
            }
        } else {
            ZStack {
                Color("2").ignoresSafeArea()

                VStack {
                    Spacer()

                    ZStack {
                        Image("p2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: phoneWidth)

                        HStack(spacing: 30) {
                            Button(action: { selectedApp = .first }) {
                                Image("N")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 5)
                            }
                            Button(action: { selectedApp = .second }) {
                                Image("C")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 5)
                            }
                            Button(action: { selectedApp = .third }) {
                                Image("P")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 5)
                            }
                        }
                        .frame(width: 260, height: 140)
                        .padding(.bottom, 300)
                        .offset(y: 90)
                    }

                    Spacer()
                }
            }
        }
    }
}
