//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-05.
//

import SwiftUI

struct LocationDetailView: View {
  @Bindable var viewModel: LocationDetailViewModel

  var body: some View {
    ZStack {
      VStack(spacing: 16) {
        BannerImageView(image: viewModel.location.bannerImage)

        AddressView(address: viewModel.location.address)

        DescriptionView(text: viewModel.location.description)

        LocationActionsView(viewModel: viewModel)

        GridHeaderTextView(number: viewModel.checkedInProfiles.count)

        AvatarGridView(viewModel: viewModel)
      }
      .accessibilityHidden(viewModel.isShowingProfileModal)

      if viewModel.isShowingProfileModal {
        FullScreenBlackTransparencyView()

        ProfileModalView(
          isShowingProfileModal: $viewModel.isShowingProfileModal,
          profile: viewModel.selectedProfile ?? DDGProfile(record: MockData.profile)
        )
      }
    }
    .task {
      await viewModel.getCheckedInProfiles()
      await viewModel.getCheckedInStatus()
    }
    .alert(item: $viewModel.alertItem) { $0.alert }
    .navigationTitle(viewModel.location.name)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
  }
}

// MARK: - Custom Views

private struct LocationActionButton: View {
  var color: Color
  var imageName: String

  var body: some View {
    Image(systemName: imageName)
      .resizable()
      .scaledToFit()
      .foregroundStyle(.white)
      .frame(width: 22, height: 22)
      .padding()
      .background(color.gradient)
      .clipShape(Circle())
      .foregroundStyle(.white.shadow(.drop(radius: 3)))
  }
}

private struct FirstNameAvatarView: View {
  var profile: DDGProfile

  var body: some View {
    VStack {
      AvatarView(size: 65, image: profile.avatarImage)
      Text(profile.firstName)
        .bold()
        .lineLimit(1)
        .minimumScaleFactor(0.75)
    }
  }
}

private struct BannerImageView: View {
  var image: UIImage

  var body: some View {
    Image(uiImage: image)
      .resizable()
      .scaledToFill()
      .frame(height: 120)
      .accessibilityHidden(true)
  }
}

private struct AddressView: View {
  var address: String

  var body: some View {
    HStack {
      Label(address, systemImage: "mappin.and.ellipse")
        .font(.caption)
        .foregroundStyle(.secondary)
      Spacer()
    }
    .padding(.horizontal, 20)
  }
}

private struct DescriptionView: View {
  var text: String
  var body: some View {
    Text(text)
      .lineLimit(3)
      .minimumScaleFactor(0.75)
      .padding(.horizontal, 20)
  }
}

private struct GridHeaderTextView: View {
  var number: Int

  var body: some View {
    Text("Who's here?")
      .bold()
      .font(.title2)
      .accessibilityAddTraits(.isHeader)
      .accessibilityLabel("Who's here? \(number) checked in")
      .accessibilityHint("Bottom section is scrollable")
  }
}

private struct FullScreenBlackTransparencyView: View {
  var body: some View {
    Color.black
      .ignoresSafeArea()
      .opacity(0.8)
      .transition(.opacity)
      .zIndex(1)
      .accessibilityHidden(true)
  }
}

private struct LocationActionsView: View {
  var viewModel: LocationDetailViewModel

  var body: some View {
    HStack(spacing: 20) {
      Button {
        viewModel.getDirectionsToLocation()
      } label: {
        LocationActionButton(color: .brandPrimary, imageName: "location.fill")
      }
      .accessibilityLabel("Get directions")

      Link(destination: URL(string: viewModel.location.websiteURL)!) {
        LocationActionButton(color: .brandPrimary, imageName: "network")
      }
      .accessibilityRemoveTraits(.isButton)
      .accessibilityLabel("Go to website")

      Button {
        viewModel.callLocation()
      } label: {
        LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
      }
      .accessibilityLabel("Call location")

      if CloudKitManager.shared.profileRecordID != nil {
        Button {
          Task {
            await viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
          }
        } label: {
          LocationActionButton(
            color: viewModel.buttonColor, imageName: viewModel.buttonImageTitle
          )
          .disabled(viewModel.isLoading)
          .accessibilityLabel(viewModel.buttonA11yLabel)
        }
      }
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 20)
    .background(Color(.secondarySystemBackground))
    .clipShape(Capsule())
    .padding(.horizontal, 10)
  }
}

private struct LocationPeopleView: View {
  var viewModel: LocationDetailViewModel

  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(viewModel.checkedInProfiles) { profile in
          FirstNameAvatarView(profile: profile)
            .onTapGesture {
              withAnimation {
                viewModel.selectedProfile = profile
              }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityHint("Show \(profile.firstName)'s profile pop up")
            .accessibilityLabel("\(profile.firstName) \(profile.lastName)")
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}

private struct AvatarGridView: View {
  var viewModel: LocationDetailViewModel

  var body: some View {
    ZStack {
      if viewModel.checkedInProfiles.isEmpty {
        ContentUnavailableView("Nobody's here", systemImage: "person.slash", description: Text("Nobody has checked in yet"))
      } else {
        LocationPeopleView(viewModel: viewModel)
      }

      if viewModel.isLoading { LoadingView() }
    }
  }
}
