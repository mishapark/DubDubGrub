//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-08.
//

import SwiftUI

struct LogoView: View {
  let frameWidth: CGFloat

  var body: some View {
    Image(.ddgMapLogo)
      .resizable()
      .scaledToFit()
      .frame(width: frameWidth)
  }
}

#Preview {
  LogoView(frameWidth: 250)
}
