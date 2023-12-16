//
//  ProfileViewMode.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-08.
//

import CloudKit
import PhotosUI
import SwiftUI

enum ProfileContext { case create, update }

extension ProfileView {
  @MainActor
  @Observable
  class ProfileViewModel {
    var alertItem: AlertItem?
    var isLoading = false
    var isCheckedIn = false

    var firstName = ""
    var lastName = ""
    var companyName = ""
    var bio = ""
    var avatar = PlaceholderImage.avatar
    var selectedImage: PhotosPickerItem? {
      didSet {
        Task {
          await changeAvatar()
        }
      }
    }

    @ObservationIgnored
    private var currentProfileRecord: CKRecord? {
      didSet {
        profileContext = .update
      }
    }
    
    @ObservationIgnored
    var profileContext = ProfileContext.create
    var buttonTitle: String {
      profileContext == .create ? "Create Profile" : "Update Profile"
    }

    func changeAvatar() async {
      if let selectedImage,
         let data = try? await selectedImage.loadTransferable(type: Data.self)
      {
        if let image = UIImage(data: data) {
          avatar = image
        }
      }
    }

    func determineButtonAction() async {
      profileContext == .create ? await createProfile() : await updateProfile()
    }

    func isValidProfile() -> Bool {
      guard !firstName.isEmpty,
            !lastName.isEmpty,
            !companyName.isEmpty,
            !bio.isEmpty,
            bio.count <= 100,
            avatar != PlaceholderImage.avatar else { return false }

      return true
    }

    func getCheckedInStatus() async {
      guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }

      do {
        let profileRecord = try await CloudKitManager.shared.fetchRecord(for: profileRecordID)
        if profileRecord[DDGProfile.kIsCheckedIn] as? CKRecord.Reference != nil {
          isCheckedIn = true
        } else {
          isCheckedIn = false
        }
      } catch {
        alertItem = AlertContext.unableToGetCheckInStatus
      }
    }

    func checkOut() async {
      showLoadingView()
      defer {
        hideLoadingView()
      }

      guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
        alertItem = AlertContext.unableToGetProfile
        return
      }

      do {
        let profileRecord = try await CloudKitManager.shared.fetchRecord(for: profileRecordID)

        profileRecord[DDGProfile.kIsCheckedIn] = nil
        profileRecord[DDGProfile.kIsCheckedInNilCheck] = nil

        let _ = try await CloudKitManager.shared.save(record: profileRecord)

        HapticManager.playSuccess()
        isCheckedIn = false
      } catch {
        alertItem = AlertContext.unableToGetCheckInOrOut
      }
    }

    func createProfile() async {
      guard let userRecord = CloudKitManager.shared.userRecord else {
        alertItem = AlertContext.noUserRecord
        return
      }
      guard isValidProfile() else {
        alertItem = AlertContext.invalidProfile
        return
      }

      let profileRecord = createProfileRecord()

      userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)

      showLoadingView()
      defer {
        hideLoadingView()
      }
      do {
        let records = try await CloudKitManager.shared.batchSave(records: [profileRecord, userRecord])
        for record in records where record.recordType == RecordType.profile {
          currentProfileRecord = record
          CloudKitManager.shared.profileRecordID = record.recordID
        }
        alertItem = AlertContext.createProfileSuccess
      } catch {
        alertItem = AlertContext.createProfileFail
      }
    }

    func getProfile() async {
      guard let userRecord = CloudKitManager.shared.userRecord else {
        alertItem = AlertContext.noUserRecord
        return
      }

      guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
      let profileRecordID = profileReference.recordID

      showLoadingView()
      defer {
        hideLoadingView()
      }
      do {
        let profileRecord = try await CloudKitManager.shared.fetchRecord(for: profileRecordID)
        currentProfileRecord = profileRecord

        let profile = DDGProfile(record: profileRecord)
        firstName = profile.firstName
        lastName = profile.lastName
        companyName = profile.companyName
        bio = profile.bio
        avatar = profile.avatarImage
      } catch {
        alertItem = AlertContext.unableToGetProfile
      }
    }

    func updateProfile() async {
      guard isValidProfile() else {
        alertItem = AlertContext.invalidProfile
        return
      }
      guard let currentProfileRecord else {
        alertItem = AlertContext.unableToGetProfile
        return
      }

      currentProfileRecord[DDGProfile.kFirstName] = firstName
      currentProfileRecord[DDGProfile.kLastName] = lastName
      currentProfileRecord[DDGProfile.kCompanyName] = companyName
      currentProfileRecord[DDGProfile.kBio] = bio
      currentProfileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()

      showLoadingView()
      defer {
        hideLoadingView()
      }

      do {
        let _ = try await CloudKitManager.shared.save(record: currentProfileRecord)
        alertItem = AlertContext.updateProfileSuccess
      } catch {
        alertItem = AlertContext.updateProfileFailure
      }
    }

    private func createProfileRecord() -> CKRecord {
      let profileRecord = CKRecord(recordType: RecordType.profile)
      profileRecord[DDGProfile.kFirstName] = firstName
      profileRecord[DDGProfile.kLastName] = lastName
      profileRecord[DDGProfile.kCompanyName] = companyName
      profileRecord[DDGProfile.kBio] = bio
      profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
      return profileRecord
    }

    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
  }
}
