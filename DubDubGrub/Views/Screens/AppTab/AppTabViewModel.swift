//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-13.
//

import MapKit
import SwiftUI

extension AppTabView {
  final class AppTabViewModel: ObservableObject {
    @Published var isShowingOnboardView = false
    @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
      didSet {
        isShowingOnboardView = hasSeenOnboardView
      }
    }

    var deviceLocationManager: CLLocationManager?

    let kHasSeenOnboardView = "hasSeenOnboardView"

    func checkIfHasSeenOnboard() {
      if !hasSeenOnboardView {
        hasSeenOnboardView = true
      }
    }
  }
}
