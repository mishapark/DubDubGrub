//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-13.
//

import CloudKit
import Foundation

extension LocationListView {
  @MainActor
  @Observable
  final class LocationListViewModel {
    var alertItem: AlertItem?
    var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]

    func getCheckedInProfilesDictionary() async {
      do {
        checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
      } catch {
        alertItem = AlertContext.unableToGetAllCheckedInProfiles
      }
    }

    func createVoiceOverSummary(for location: DDGLocation) -> String {
      let count = checkedInProfiles[location.id, default: []].count

      let personPlurality = count == 1 ? "person" : "people"

      return "\(location.name) \(count) \(personPlurality) checked in"
    }
  }
}
