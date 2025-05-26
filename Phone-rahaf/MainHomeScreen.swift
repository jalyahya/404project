import SwiftUI
import SpriteKit

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
                    // ✅ زر X بنفس ستايل LockScreen
                    HStack {
                        Spacer()
                        Button(action: {
                            presentCratesPage()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                    }

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

    // ✅ ينقل مباشرة إلى CratesPage
    func presentCratesPage() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let skView = SKView(frame: window.bounds)
        let cratesScene = FirstPage(size: skView.bounds.size)
        cratesScene.scaleMode = .aspectFill
        skView.presentScene(cratesScene)

        let vc = UIViewController()
        vc.view = skView
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
