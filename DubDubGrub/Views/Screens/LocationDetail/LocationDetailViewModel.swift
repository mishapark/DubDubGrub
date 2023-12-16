//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-11.
//

import CloudKit
import MapKit
import SwiftUI

enum CheckInStatus {
  case checkedIn, checkedOut
}

@MainActor
@Observable
final class LocationDetailViewModel {
  var alertItem: AlertItem?
  var isLoading = false
  var isShowingProfileModal = false
  var isCheckedIn = false
  var checkedInProfiles: [DDGProfile] = []

  var buttonColor: Color { isCheckedIn ? Color(.systemPink) : .brandPrimary }
  var buttonImageTitle: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
  var buttonA11yLabel: String { isCheckedIn ? "Check out" : "Check in" }

  @ObservationIgnored var location: DDGLocation
  @ObservationIgnored var selectedProfile: DDGProfile? {
    didSet {
      isShowingProfileModal = true
    }
  }

  init(location: DDGLocation) {
    self.location = location
  }

  func getDirectionsToLocation() {
    let placemark = MKPlacemark(coordinate: location.location.coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = location.name

    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
  }

  func callLocation() {
    guard let url = URL(string: "tel://\(location.phoneNumber)") else {
      alertItem = AlertContext.invalidPhoneNumber
      return
    }
    UIApplication.shared.open(url)
  }

  func getCheckedInStatus() async {
    guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }

    do {
      let profileRecord = try await CloudKitManager.shared.fetchRecord(for: profileRecordID)
      if profileRecord[DDGProfile.kIsCheckedIn] as? CKRecord.Reference != nil {
        isCheckedIn = profileRecord.recordID == location.id
      } else {
        isCheckedIn = false
      }
    } catch {
      alertItem = AlertContext.unableToGetCheckInStatus
    }
  }

  func updateCheckInStatus(to checkInStatus: CheckInStatus) async {
    guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
      alertItem = AlertContext.unableToGetProfile
      return
    }

    showLoadingView()
    defer {
      hideLoadingView()
    }
    do {
      let profileRecord = try await CloudKitManager.shared.fetchRecord(for: profileRecordID)

      switch checkInStatus {
      case .checkedIn:
        profileRecord[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
        profileRecord[DDGProfile.kIsCheckedInNilCheck] = 1
      case .checkedOut:
        profileRecord[DDGProfile.kIsCheckedIn] = nil
        profileRecord[DDGProfile.kIsCheckedInNilCheck] = nil
      }

      let savedRecord = try await CloudKitManager.shared.save(record: profileRecord)
      HapticManager.playSuccess()

      let profile = DDGProfile(record: savedRecord)
      switch checkInStatus {
      case .checkedIn:
        checkedInProfiles.append(profile)
      case .checkedOut:
        checkedInProfiles.removeAll { $0.id == profile.id }
      }

      isCheckedIn.toggle()
    } catch {
      alertItem = AlertContext.unableToGetCheckInOrOut
    }
  }

  func getCheckedInProfiles() async {
    showLoadingView()
    defer {
      hideLoadingView()
    }

    do {
      checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
    } catch {
      alertItem = AlertContext.unableToGetCheckedInProfiles
    }
  }

  private func showLoadingView() { isLoading = true }
  private func hideLoadingView() { isLoading = false }
}
