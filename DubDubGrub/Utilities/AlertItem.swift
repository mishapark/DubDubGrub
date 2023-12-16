//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-07.
//

import SwiftUI

struct AlertItem: Identifiable {
  let id = UUID()
  let title: Text
  let message: Text
  let dismissButton: Alert.Button

  var alert: Alert {
    Alert(title: title, message: message, dismissButton: dismissButton)
  }
}

enum AlertContext {
  // MARK: - MapView Errors

  static let unableToGetLocations = AlertItem(
    title: Text("Locations Error"),
    message: Text("Unable to retrieve locations"),
    dismissButton: .default(Text("OK")))

  static let locationRestricted = AlertItem(
    title: Text("Location Restricted"),
    message: Text("Your location is restricted."),
    dismissButton: .default(Text("OK")))

  static let locationDenied = AlertItem(
    title: Text("Location Denied"),
    message: Text("Dub Dub Grub does not have permission to access your location"),
    dismissButton: .default(Text("OK")))

  static let locationDisabled = AlertItem(
    title: Text("Location Disabled"),
    message: Text("Your phone location services are disabled"),
    dismissButton: .default(Text("OK")))

  static let checkedInCount = AlertItem(
    title: Text("Server error"),
    message: Text("Unable to get the number of people checked into each location"),
    dismissButton: .default(Text("OK")))

  // MARK: - Location List

  static let unableToGetAllCheckedInProfiles = AlertItem(
    title: Text("Server Error"),
    message: Text("Unable to get all checked in user profiles at this time"),
    dismissButton: .default(Text("OK")))

  // MARK: - Invalid Profile

  static let invalidProfile = AlertItem(
    title: Text("Invalid Profile"),
    message: Text("All fields are required as well as a profile photo. Your bio must be < 100 character"),
    dismissButton: .default(Text("OK")))

  static let noUserRecord = AlertItem(
    title: Text("No User Record"),
    message: Text("You must log into iCloud on your phone in order to utilize Dub Dub Grub's Profile"),
    dismissButton: .default(Text("OK")))

  static let createProfileSuccess = AlertItem(
    title: Text("Profile created successfully!"),
    message: Text("Your profile has successfully been created"),
    dismissButton: .default(Text("OK")))

  static let createProfileFail = AlertItem(
    title: Text("Failed to create profile"),
    message: Text("We were unable to create your profile at this time. \nPlease try again later"),
    dismissButton: .default(Text("OK")))

  static let unableToGetProfile = AlertItem(
    title: Text("Unable to retrieve profile"),
    message: Text("We were unable to retrieve your profile at this time. \nPlease try again later"),
    dismissButton: .default(Text("OK")))

  static let updateProfileSuccess = AlertItem(
    title: Text("Profile updated successfully!"),
    message: Text("Your profile has successfully been updated"),
    dismissButton: .default(Text("OK")))

  static let updateProfileFailure = AlertItem(
    title: Text("Unable to update profile"),
    message: Text("We were unable to update your profile at this time. \nPlease try again later"),
    dismissButton: .default(Text("OK")))

  // MARK: - Location Detail

  static let invalidPhoneNumber = AlertItem(
    title: Text("Invalid Phone Number"),
    message: Text("The phone number for the location is invalid"),
    dismissButton: .default(Text("OK")))

  static let unableToGetCheckInStatus = AlertItem(
    title: Text("Server Error"),
    message: Text("Unable to retrieve checked in status of the current user"),
    dismissButton: .default(Text("OK")))

  static let unableToGetCheckInOrOut = AlertItem(
    title: Text("Server Error"),
    message: Text("Unable to check in/out at this time"),
    dismissButton: .default(Text("OK")))

  static let unableToGetCheckedInProfiles = AlertItem(
    title: Text("Server Error"),
    message: Text("Unable to get checked in user profiles at this time"),
    dismissButton: .default(Text("OK")))
}
