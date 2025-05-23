import SwiftUI

struct LockScreen: View {
    @Environment(\.dismiss) private var dismiss
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
                    // ✅ زر الإغلاق العلوي (✕)
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss() // يرجع للمشهد السابق (CratesPage)
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
                        Image("p1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: phoneWidth)

                        VStack {
                            Spacer()

                            // نقاط الرمز
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

                            // لوحة الأرقام
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
