//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-06.
//

import SwiftUI

extension View {
  func profileNameStyle() -> some View {
    self
      .font(.system(size: 32, weight: .bold))
      .lineLimit(1)
      .minimumScaleFactor(0.75)
  }
}
