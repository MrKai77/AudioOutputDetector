//
//  AudioOutputDetectorApp.swift
//  AudioOutputDetector
//
//  Created by Kai Azim on 2024-01-17.
//

import SwiftUI
import SimplyCoreAudio
import DynamicNotchKit

@main
struct AudioOutputDetectorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Audio Out", systemImage: "cable.coaxial") {
            Button("Show") {
                appDelegate.updateAudioDevice()
            }
            Button(action: {
                NSApp.terminate(self)
            }, label: {
                Text("Quit")
            })
        }
        .menuBarExtraStyle(.menu)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    private let sca = SimplyCoreAudio()

    func applicationDidFinishLaunching(_ notification: Notification) {
        updateAudioDevice()

        // Add a listener for when the default output device changes
        NotificationCenter.default.addObserver(forName: .defaultOutputDeviceChanged, object: nil, queue: .main) { (_) in
            self.updateAudioDevice()
        }
    }

    func updateAudioDevice() {
        guard let defaultOutputDevice = sca.defaultOutputDevice else { return}

        // This is not perfect, but it's an easy way to guess an icon based on the name of the new default output
        var outputSystemImage = "cable.coaxial"

        if defaultOutputDevice.name.lowercased().contains("buds") {
            outputSystemImage = "earbuds"
        }
        if defaultOutputDevice.name.lowercased().contains("headphones") {
            outputSystemImage = "headphones"
        }

        // Initialize the popup
        let dynamicNotch = DynamicNotchInfo(
            systemImage: "cable.coaxial",
            title: defaultOutputDevice.name,
            description: "CONNECTED"
        )

        // Show the popup for 2 seconds
        dynamicNotch.show(for: 2)
    }
}
