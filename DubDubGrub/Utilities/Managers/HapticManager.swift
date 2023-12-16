//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-14.
//

import Foundation
import UIKit

struct HapticManager {
  static func playSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
  }
}
