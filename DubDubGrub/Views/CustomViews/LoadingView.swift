//
//  LoadingView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-10.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    ZStack {
      Color(.systemBackground)
        .opacity(0.9)
        .ignoresSafeArea()
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
        .tint(.brandPrimary)
        .scaleEffect(2)
        .offset(y: -40)
    }
  }
}

#Preview {
  LoadingView()
}
