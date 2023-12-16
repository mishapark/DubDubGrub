//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-05.
//

import SwiftUI

struct LocationListView: View {
  @EnvironmentObject private var locationManager: LocationManager
  @State private var viewModel = LocationListViewModel()

  var body: some View {
    NavigationStack {
      List {
        ForEach(locationManager.locations) { location in
          NavigationLink(
            destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))
          ) {
            LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
              .accessibilityElement(children: .ignore)
              .accessibilityLabel(viewModel.createVoiceOverSummary(for: location))
          }
        }
      }
      .listStyle(.plain)
      .navigationTitle("Grub Spots")
      .alert(item: $viewModel.alertItem) { $0.alert }
      .task {
        await viewModel.getCheckedInProfilesDictionary()
      }
      .refreshable {
        await viewModel.getCheckedInProfilesDictionary()
      }
    }
  }
}

#Preview {
  LocationListView()
    .environmentObject(LocationManager())
}
