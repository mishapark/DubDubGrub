//
//  OnboardView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-08.
//

import SwiftUI

struct OnboardView: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button {
          dismiss()
        } label: {
          XDismissButton()
        }
      }
      Spacer()
      LogoView(frameWidth: 250)
        .padding(.bottom)
      VStack(alignment: .leading, spacing: 32) {
        OnboardInfoView(
          image: "building.2.crop.circle",
          title: "Restaurant Locations",
          description: "Find places to dine around the convention center")
        OnboardInfoView(
          image: "checkmark.circle",
          title: "Check in",
          description: "Let other iOS devs know where you are")
        OnboardInfoView(
          image: "person.2.circle",
          title: "Find Friends",
          description: "See where other iOS devs are and join the party")
      }
      .padding(.horizontal, 30)
      Spacer()
    }
  }
}

#Preview {
  OnboardView()
}

private struct OnboardInfoView: View {
  let image: String
  let title: String
  let description: String

  var body: some View {
    HStack(spacing: 26) {
      Image(systemName: image)
        .resizable()
        .frame(width: 50, height: 50)
        .foregroundStyle(.brandPrimary)
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .bold()
        Text(description)
          .foregroundStyle(.secondary)
          .lineLimit(2)
          .minimumScaleFactor(0.75)
      }
    }
  }
}
