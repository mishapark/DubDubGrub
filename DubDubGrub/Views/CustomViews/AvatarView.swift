//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-06.
//

import SwiftUI

struct AvatarView: View {
  var size: CGFloat
  var image: UIImage

  var body: some View {
    Image(uiImage: image)
      .resizable()
      .scaledToFill()
      .frame(width: size, height: size)
      .clipShape(Circle())
  }
}

#Preview {
  AvatarView(size: 30, image: PlaceholderImage.avatar)
}
