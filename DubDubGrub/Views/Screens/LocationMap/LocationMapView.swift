//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-05.
//

import CoreLocationUI
import MapKit
import SwiftUI

struct LocationMapView: View {
  @EnvironmentObject private var locationManager: LocationManager
  @State private var viewModel = LocationMapViewModel()

  var body: some View {
    ZStack(alignment: .top) {
      Map(initialPosition: viewModel.cameraPosition) {
        ForEach(locationManager.locations) { location in
          Annotation(location.name, coordinate: location.location.coordinate) {
            DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
              .onTapGesture {
                locationManager.selectedLocation = location
                viewModel.isShowingDetailView = true
              }
              .contextMenu {
                Button("Look Around", systemImage: "eyes") {
                  viewModel.getLookAroundScene(for: location)
                }
                Button("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle") {
                  viewModel.getDirections(to: location)
                }
              }
          }
        }
        UserAnnotation()
          .tint(Color(.systemPink))

        if let route = viewModel.route {
          MapPolyline(route)
            .stroke(.brandPrimary, lineWidth: 8)
        }
      }
      .lookAroundViewer(isPresented: $viewModel.isShowingLookAround, initialScene: viewModel.lookAroundScene)
      .mapStyle(.standard)
      .mapControls {
        MapCompass()
        MapPitchToggle()
        MapUserLocationButton()
        MapPitchToggle()
      }

      LogoView(frameWidth: 125)
        .shadow(radius: 10)
        .accessibilityHidden(true)
    }
    .sheet(isPresented: $viewModel.isShowingDetailView) {
      NavigationStack {
        LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
          .toolbar {
            Button {
              viewModel.isShowingDetailView = false
            } label: {
              Text("Dismiss")
            }
          }
      }
    }
    .alert(item: $viewModel.alertItem) { $0.alert }
    .overlay(alignment: .bottomTrailing) {
      LocationButton(.currentLocation) {
        viewModel.requestAllowOnceLocationPermission()
      }
      .foregroundStyle(.white)
      .symbolVariant(.fill)
      .tint(Color(.systemPink))
      .labelStyle(.iconOnly)
      .clipShape(Circle())
      .padding(.trailing, 20)
      .padding(.bottom, 40)
    }
    .task {
      if locationManager.locations.isEmpty {
        await viewModel.getLocations(for: locationManager)
      }
      await viewModel.getCheckedInCounts()
    }
  }
}

#Preview {
  LocationMapView()
    .environmentObject(LocationManager())
}
