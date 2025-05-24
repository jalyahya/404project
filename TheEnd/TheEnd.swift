//
//  ContentView.swift
//  11
//
//  Created by Rahaf ALDossari on 24/11/1446 AH.
//

import SwiftUI

struct TheEnd: View {
    var body: some View{
        GeometryReader { geo in
            ZStack{
                
                Color.black
                    .ignoresSafeArea()
                VStack{
                Image("fn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.9)
                    .fixedSize()
                
                Button(action: {
                }) {
                    ZStack {
                        Image("s")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 80)
                        
                        Text("النهاية")
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                    }
                }
                }
            }
        }
    }
}
