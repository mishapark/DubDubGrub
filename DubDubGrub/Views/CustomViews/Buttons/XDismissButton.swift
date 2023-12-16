//
//  XDismissButton.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-08.
//

import SwiftUI

struct XDismissButton: View {
  var body: some View {
    Image(systemName: "xmark")
      .foregroundStyle(.white)
      .imageScale(.small)
      .padding(8)
      .background(.brandPrimary)
      .clipShape(Circle())
      .padding(10)
  }
}

#Preview {
  XDismissButton()
}
