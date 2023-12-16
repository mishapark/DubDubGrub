//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-06.
//

import SwiftUI

struct DDGButton: View {
  var title: String

  var body: some View {
    Text(title)
      .bold()
      .foregroundStyle(.white)
      .padding()
      .padding(.horizontal, 50)
      .background(.brandPrimary.gradient)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  DDGButton(title: "Save Profile")
}
