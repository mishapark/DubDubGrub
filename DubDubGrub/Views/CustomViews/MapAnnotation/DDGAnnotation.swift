//
//  DDGAnnotation.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-13.
//

import SwiftUI

struct DDGAnnotation: View {
  var location: DDGLocation
  var number: Int

  var body: some View {
    VStack {
      ZStack {
        MapBalloon()
          .frame(width: 100, height: 70)
          .foregroundStyle(.brandPrimary)
        Image(uiImage: location.squareImage)
          .resizable()
          .scaledToFill()
          .frame(width: 40, height: 40)
          .clipShape(Circle())
          .offset(y: -11)
        if number > 0 {
          Text("\(min(number, 99))")
            .font(.system(size: 11, weight: .bold))
            .frame(width: 26, height: 18)
            .background(Color(.systemPink))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .offset(x: 20, y: -28)
        }
      }
//      Text(location.name)
//        .font(.caption)
//        .fontWeight(.semibold)
    }
    .accessibilityLabel("Map Pin \(location.name) \(number) checked in")
  }
}

#Preview {
  DDGAnnotation(location: DDGLocation(record: MockData.location), number: 44)
}
