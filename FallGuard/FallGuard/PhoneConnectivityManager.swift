//
//  PhoneConnectivityManager.swift
//  FallGuard
//
//  Created by abdul wasay on 19/02/2026.
//
import WatchConnectivity
import Combine

class PhoneConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var receivedData: [String] = []

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["sensorData"] as? [String] {
            DispatchQueue.main.async {
                self.receivedData = data
                print("iPhone: Received \(data.count) samples!")
                self.saveToCSV(data: data)
            }
        }
    }

    func saveToCSV(data: [String]) {
        let csvString = data.joined(separator: "\n")
        let fileName = "FallData_\(Date().timeIntervalSince1970).csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            print("CSV Saved at: \(path)")
        } catch {
            print("Failed to save CSV: \(error)")
        }
    }

    // MARK: - WCSessionDelegate stubs
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
}
