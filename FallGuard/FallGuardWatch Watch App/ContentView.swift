//
//  ContentView.swift
//  FallGuardWatch Watch App
//
//  Created by abdul wasay on 18/02/2026.
//
// ContentView.swift (Watch App)
import SwiftUI
import CoreMotion

struct ContentView: View {
    let motionManager = CMMotionManager()
    @State private var x = 0.0
    @State private var y = 0.0
    @State private var z = 0.0
    @State private var isRecording = false
    @State private var recordedData: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("FallGuard Tracker")
                    .font(.headline)
                    .foregroundColor(.orange)

                VStack(alignment: .leading) {
                    Text("X: \(String(format: "%.2f", x))")
                    Text("Y: \(String(format: "%.2f", y))")
                    Text("Z: \(String(format: "%.2f", z))")
                }
                .font(.system(.body, design: .monospaced))
                .padding(.vertical, 5)

                if isRecording {
                    Text("● Recording...")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: {
                    if isRecording { stopRecording() }
                    else { startRecording() }
                }) {
                    Text(isRecording ? "STOP & SEND" : "START SESSION")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRecording ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    // MARK: - Logic
    func startRecording() {
        isRecording = true
        recordedData = ["Timestamp,AccX,AccY,AccZ"]

        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 50.0
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data = data else { return }
                x = data.acceleration.x
                y = data.acceleration.y
                z = data.acceleration.z

                let timestamp = Date().timeIntervalSince1970
                let row = "\(timestamp),\(x),\(y),\(z)"
                recordedData.append(row)
            }
        }
    }

    func stopRecording() {
        isRecording = false
        motionManager.stopAccelerometerUpdates()
        print("Stopped! Samples collected: \(recordedData.count)")

        WatchConnectivityManager.shared.sendDataToPhone(data: recordedData)
    }
}

#Preview {
    ContentView()
}
