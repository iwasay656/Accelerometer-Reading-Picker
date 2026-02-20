//
//  ContentView.swift
//  FallGuard
//
//  Created by abdul wasay on 18/02/2026.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var phoneManager = PhoneConnectivityManager()

    var body: some View {
        VStack {
            Text("FallGuard iPhone Receiver")
                .font(.headline)
                .padding()

            Text("Received samples: \(phoneManager.receivedData.count)")
                .padding()

            List(phoneManager.receivedData, id: \.self) { row in
                Text(row)
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
}
