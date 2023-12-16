//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-05.
//

import SwiftUI

@main
struct DubDubGrubApp: App {
  let locationManager = LocationManager()

  var body: some Scene {
    WindowGroup {
      AppTabView()
        .environmentObject(locationManager)
        .task {
          try? await CloudKitManager.shared.getUserRecord()
        }
    }
  }
}
