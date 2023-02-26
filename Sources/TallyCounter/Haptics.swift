//
//  Haptics.swift
//  
//
//  Created by  Vladyslav Fil on 26.02.2023.
//

import CoreHaptics
import UIKit

//MARK: - Prepare Haptics
extension TallyCounter {
    func prepareHaptics() {
        guard hapticsEnabled else { return }
        
        createAndStartHapticEngine()
        createContinuousHapticPlayer()
        addObservers()
    }
}

//MARK: - Create and start haptic engine
extension TallyCounter {
    func createAndStartHapticEngine() {
        // Create and configure a haptic engine.
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        // Mute audio to reduce latency for collision haptics.
        engine?.playsHapticsOnly = true
        // The stopped handler alerts you of engine stoppage.
        engine?.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }
        // The reset handler provides an opportunity to restart the engine.
        engine?.resetHandler = {
            print("Reset Handler: Restarting the engine.")
            do {
                // Try restarting the engine.
                try startHapticEngineIfNecessary()
                // Recreate the continuous player.
                self.createContinuousHapticPlayer()
            } catch {
                print("Failed to start the engine")
            }
        }
        // Start the haptic engine for the first time.
        do {
            try self.engine?.start()
        } catch {
            print("Failed to start the engine: \(error)")
        }
    }
}


//MARK: - Create continuous pattern
extension TallyCounter {
    func createContinuousHapticPlayer() {
        // Create an intensity parameter:
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: initialIntensity)
        // Create a sharpness parameter:
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: initialSharpness)
        // Create a continuous event with a long duration from the parameters.
        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                            parameters: [intensity, sharpness],
                                            relativeTime: 0,
                                            duration: 100)
        do {
            // Create a pattern from the continuous haptic event.
            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
            // Create a player from the continuous haptic pattern.
            continuousPlayer = try engine?.makeAdvancedPlayer(with: pattern)
        } catch let error {
            print("Pattern Player Creation Error: \(error)")
        }
    }
}

//MARK: - Add Observers
extension TallyCounter {
    func addObservers() {
        backgroundToken = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            guard hapticsEnabled else { return }
            // Stop the haptic engine.
            self.stopHapticEngine()
        }
        
        foregroundToken = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in
            guard hapticsEnabled else { return }
            // Restart the haptic engine.
            self.restartHapticEngine()
        }
    }
}

//MARK: - Play Haptic Transient
extension TallyCounter {
    /// Play a haptic transient pattern at the given intensity and sharpness.
    func playHapticTransient(intensity: Float, sharpness: Float) {
        guard hapticsEnabled else { return }
        // Create an event (static) parameter to represent the haptic's intensity.
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        // Create an event (static) parameter to represent the haptic's sharpness.
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        // Create an event to represent the transient haptic pattern.
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParameter, sharpnessParameter],
            relativeTime: 0
        )
        // Create a pattern from the haptic event.
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            // Create a player to play the haptic pattern.
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate) // Play now.
        } catch let error {
            print("Error creating a haptic transient pattern: \(error)")
        }
    }
}

//MARK: - Play Haptic Transient
extension TallyCounter {
    /// Play a haptic continuous pattern at the calculated intensity and sharpness.
    /// `labelOffset`, `labelOffsetXLimit` and `labelOffsetYLimit` are used for `dynamicIntensity` calculations
    func playHapticContinuous() {
        guard hapticsEnabled else { return }
        
        let labelOffsetWidth = abs(self.labelOffset.width)
        let dynamicIntensityBasedOnHorizontalOffset: Float = Float(labelOffsetWidth / labelOffsetXLimit)
        let dynamicIntensityBasedOnVerticalOffset: Float = Float(abs(self.labelOffset.height) / labelOffsetYLimit)
        let dynamicIntensity = dynamicIntensityBasedOnHorizontalOffset == 0
            ? dynamicIntensityBasedOnVerticalOffset
            : dynamicIntensityBasedOnHorizontalOffset
        let dynamicSharpness: Float = 0.1
        // Create dynamic parameters for the updated intensity & sharpness.
        let intensityParameter = CHHapticDynamicParameter(
            parameterID: .hapticIntensityControl,
            value: dynamicIntensity,
            relativeTime: 0
        )
        let sharpnessParameter = CHHapticDynamicParameter(
            parameterID: .hapticSharpnessControl,
            value: dynamicSharpness,
            relativeTime: 0
        )
        // Send dynamic parameters to the haptic player.
        do {
            try continuousPlayer?.sendParameters([intensityParameter, sharpnessParameter], atTime: 0)
        } catch let error {
            print("Dynamic Parameter Error: \(error)")
        }
        // Warm engine.
        do {
            // Begin playing continuous pattern.
            try continuousPlayer?.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error starting the continuous haptic player: \(error)")
        }
    }
}

//MARK: - Start, stop engine / player
extension TallyCounter {
    func stopHapticsContinuousPlayer() {
        guard self.hapticsEnabled else { return }
        // Stop playing the haptic pattern.
        do {
            try continuousPlayer?.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
    
    func startHapticEngineIfNecessary() throws {
        if self.engineNeedsStart {
            try engine?.start()
            engineNeedsStart = false
        }
    }

    func restartHapticEngine() {
        self.engine?.start { error in
            if let error = error {
                print("Haptic Engine Startup Error: \(error)")
                return
            }
            self.engineNeedsStart = false
        }
    }

    func stopHapticEngine() {
        self.engine?.stop { error in
            if let error = error {
                print("Haptic Engine Shutdown Error: \(error)")
                return
            }
            self.engineNeedsStart = true
        }
    }
}
