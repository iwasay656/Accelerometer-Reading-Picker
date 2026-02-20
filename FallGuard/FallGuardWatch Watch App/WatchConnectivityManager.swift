//
//  WatchConnectivityManager.swift
//  FallGuard
//
//  Created by abdul wasay on 19/02/2026.
//
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendDataToPhone(data: [String]) {
        if WCSession.default.isReachable {
            let message = ["sensorData": data]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Error sending: \(error.localizedDescription)")
            })
        } else {
            print("iPhone not reachable! Make sure iPhone app is open.")
        }
    }

    // MARK: - WCSessionDelegate stubs
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }

}
