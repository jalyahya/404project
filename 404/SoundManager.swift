//
//  SoundManager.swift
//  404
//
//  Created by Azhar on 20/05/2025.
//
import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var cafePlayer: AVAudioPlayer?
    private var keyPlayer: AVAudioPlayer?
    private var singlePlayer: AVAudioPlayer?

    private init() {}

    // ✅ تشغيل صوت مرة واحدة (mp3 افتراضيًا، أو wav مثلًا)
    func playSoundOnce(named name: String, withExtension fileExtension: String = "mp3", volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            return
        }

        do {
            singlePlayer = try AVAudioPlayer(contentsOf: url)
            singlePlayer?.numberOfLoops = 0
            singlePlayer?.volume = volume
            singlePlayer?.prepareToPlay()
            singlePlayer?.play()
        } catch {
        }
    }

    // ✅ صوت المفتاح (Loop)
    func playKeySound() {
        guard let url = Bundle.main.url(forResource: "Key", withExtension: "wav") else {
            return
        }

        do {
            keyPlayer = try AVAudioPlayer(contentsOf: url)
            keyPlayer?.numberOfLoops = -1
            keyPlayer?.play()
        } catch {
        }
    }

    func stopKeySound() {
        keyPlayer?.stop()
        keyPlayer = nil
    }

    // ✅ صوت الكافيه (Loop)
    func playCafeAmbience() {
        guard cafePlayer == nil || cafePlayer?.isPlaying == false else { return }

        guard let url = Bundle.main.url(forResource: "Tables", withExtension: "mp3") else {
            return
        }

        do {
            cafePlayer = try AVAudioPlayer(contentsOf: url)
            cafePlayer?.numberOfLoops = -1
            cafePlayer?.volume = 0.4
            cafePlayer?.play()
        } catch {
        }
    }

    func stopCafeAmbience() {
        cafePlayer?.stop()
        cafePlayer = nil
    }
    
    func playStreetSound() {
        if let url = Bundle.main.url(forResource: "Street", withExtension: "wav") {
            do {
                singlePlayer = try AVAudioPlayer(contentsOf: url)
                singlePlayer?.numberOfLoops = 0 // تشغيل مرة وحدة فقط
                singlePlayer?.volume = 1.0
                singlePlayer?.play()
            } catch {
            }
        }
    }
    
    func stopAll() {
        cafePlayer?.stop()
        keyPlayer?.stop()
        singlePlayer?.stop()
        cafePlayer = nil
        keyPlayer = nil
        singlePlayer = nil
    }
}
