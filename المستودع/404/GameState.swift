//
//  GameState.swift
//  404
//
//  Created by Azhar on 14/05/2025.
//

import Foundation

class GameState {
    static let shared = GameState()

    private(set) var collectedEvidence: [String] = []
    private(set) var usedEvidence: [String] = []

    var isCashierOpen: Bool = false
    var isClockActivated: Bool = false
    var hasRevealedKey0: Bool = false

    private init() {}

    // جمع دليل
    func collect(_ evidenceName: String) {
        if !collectedEvidence.contains(evidenceName) {
            collectedEvidence.append(evidenceName)
        }
    }

    // تحقق إذا تم جمع دليل
    func hasCollected(_ evidenceName: String) -> Bool {
        return collectedEvidence.contains(evidenceName)
    }

    // تحديد دليل كمستخدم (مثل الترس بعد ما ينحط في الساعة)
    func markAsUsed(_ evidenceName: String) {
        if hasCollected(evidenceName), !usedEvidence.contains(evidenceName) {
            usedEvidence.append(evidenceName)
        }
    }

    // تحقق إذا تم استخدام دليل
    func hasUsed(_ evidenceName: String) -> Bool {
        return usedEvidence.contains(evidenceName)
    }

    // تحقق إذا الدليل متوفر (تم جمعه ولكن لم يُستخدم)
    func isAvailable(_ evidenceName: String) -> Bool {
        return hasCollected(evidenceName) && !hasUsed(evidenceName)
    }

    // خاصية جاهزة للتحقق من Key0 (جمُع ولم يُستخدم)
    var hasCollectedKey0: Bool {
        return isAvailable("Key0")
    }

    // كشف Key0 (لو تبين تظهره لاحقاً حسب الأحداث)
    func revealKey0() {
        hasRevealedKey0 = true
    }

    // إعادة تعيين كل شي (للاختبار أو إعادة اللعبة)
    func reset() {
        collectedEvidence.removeAll()
        usedEvidence.removeAll()
        isCashierOpen = false
        isClockActivated = false
        hasRevealedKey0 = false
    }
    
    
}
