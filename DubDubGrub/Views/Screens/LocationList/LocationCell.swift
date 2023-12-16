//
//  LocationCell.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-06.
//

import SwiftUI

struct LocationCell: View {
  var location: DDGLocation
  var profiles: [DDGProfile]

  var body: some View {
    HStack {
      Image(uiImage: location.squareImage)
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .padding(.vertical, 8)
      VStack(alignment: .leading) {
        Text(location.name)
          .font(.title2)
          .fontWeight(.semibold)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
        if profiles.isEmpty {
          Text("Nobody's Checked In")
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.top, 2)
        } else {
          HStack {
            ForEach(profiles.indices, id: \.self) { index in
              if index <= 3 {
                AvatarView(
                  size: 35,
                  image: profiles[index].avatarImage
                )
              } else if index == 4 {
                AdditionalProfilesView(number: profiles.count - 4)
              }
            }
          }
        }
      }
      .padding(.leading)
    }
  }
}

#Preview {
  LocationCell(location: DDGLocation(record: MockData.location), profiles: [])
}

private struct AdditionalProfilesView: View {
  var number: Int

  var body: some View {
    Text("+\(number)")
      .font(.system(size: 14, weight: .semibold))
      .frame(height: 35)
      .frame(minWidth: 35, maxWidth: 70)
      .foregroundStyle(.white)
      .background(.brandPrimary)
      .clipShape(Capsule())
  }
}
