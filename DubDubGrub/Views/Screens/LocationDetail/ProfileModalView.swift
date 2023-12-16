//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-11.
//

import SwiftUI

struct ProfileModalView: View {
  @Binding var isShowingProfileModal: Bool
  var profile: DDGProfile

  var body: some View {
    ZStack(alignment: .top) {
      VStack {
        HStack {
          Spacer()
          Button {
            withAnimation {
              isShowingProfileModal = false
            }
          } label: {
            XDismissButton()
          }
        }
        .padding(.bottom, 10)
        Text("\(profile.firstName) \(profile.lastName)")
          .bold()
          .font(.title2)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .padding(.horizontal)
        Text(profile.companyName)
          .fontWeight(.semibold)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .foregroundStyle(.secondary)
          .padding(.horizontal)
          .accessibilityLabel("Works at \(profile.companyName)")
        Text(profile.bio)
          .lineLimit(3)
          .minimumScaleFactor(0.75)
          .padding()
          .foregroundStyle(.secondary)
          .accessibilityLabel("Bio, \(profile.bio)")
        Spacer()
      }
      .frame(width: 300, height: 230)
      .background(.regularMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .padding(.top, 70)

      Image(uiImage: profile.avatarImage)
        .resizable()
        .scaledToFill()
        .frame(width: 110, height: 110)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
        .accessibilityHidden(true)
    }
    .transition(.opacity.combined(with: .slide))
    .zIndex(2)
    .accessibilityAddTraits(.isModal)
  }
}

#Preview {
  ProfileModalView(isShowingProfileModal: .constant(false), profile: DDGProfile(record: MockData.profile))
}
