//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-07.
//

import CloudKit
import MapKit
import SwiftUI

extension LocationMapView {
  @Observable
  final class LocationMapViewModel: NSObject, CLLocationManagerDelegate {
    var checkedInProfiles: [CKRecord.ID: Int] = [:]
    var isShowingDetailView = false
    var isShowingLookAround = false
    var alertItem: AlertItem?
    var route: MKRoute?
    var cameraPosition: MapCameraPosition = .region(.init(center: .init(
      latitude: 37.3315116,
      longitude: -121.891054
    ), latitudinalMeters: 1200, longitudinalMeters: 1200))

    var lookAroundScene: MKLookAroundScene? {
      didSet {
        if lookAroundScene != nil {
          isShowingLookAround = true
        }
      }
    }

    let deviceLocationManager = CLLocationManager()

    override init() {
      super.init()
      deviceLocationManager.delegate = self
    }

    func requestAllowOnceLocationPermission() {
      deviceLocationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let currentLocation = locations.last else { return }

      withAnimation {
        cameraPosition = .region(.init(center: currentLocation.coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200))
      }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Did fail with error")
    }

    @MainActor
    func getLocations(for locationManager: LocationManager) async {
      do {
        locationManager.locations = try await CloudKitManager.shared.getLocations()
      } catch {
        alertItem = AlertContext.unableToGetLocations
      }
    }

    @MainActor
    func getCheckedInCounts() async {
      do {
        checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
      } catch {
        alertItem = AlertContext.checkedInCount
      }
    }

    @MainActor
    func getLookAroundScene(for location: DDGLocation) {
      let request = MKLookAroundSceneRequest(coordinate: location.location.coordinate)
      Task {
        lookAroundScene = try? await request.scene
      }
    }

    @MainActor
    func getDirections(to location: DDGLocation) {
      guard let userLocation = deviceLocationManager.location?.coordinate else { return }
      let destination = location.location.coordinate

      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: .init(coordinate: userLocation))
      request.destination = MKMapItem(placemark: .init(coordinate: destination))
      request.transportType = .walking

      Task {
        let directions = try? await MKDirections(request: request).calculate()
        route = directions?.routes.first
      }
    }
  }
}
