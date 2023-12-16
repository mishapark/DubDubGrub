//
//  DDGLocation.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-06.
//

import CloudKit
import UIKit

struct DDGLocation: Identifiable {
  static let kName = "name"
  static let kDescription = "description"
  static let kAddress = "address"
  static let kWebsiteURL = "websiteURL"
  static let kPhoneNumber = "phoneNumber"
  static let kLocation = "location"
  static let kSquareAsset = "squareAsset"
  static let kBannerAsset = "bannerAsset"

  let id: CKRecord.ID
  let name: String
  let description: String
  let address: String
  let websiteURL: String
  let phoneNumber: String
  let location: CLLocation
  let squareAsset: CKAsset!
  let bannerAsset: CKAsset!

  init(record: CKRecord) {
    id = record.recordID
    name = record[DDGLocation.kName] as? String ?? "N/A"
    description = record[DDGLocation.kDescription] as? String ?? "N/A"
    address = record[DDGLocation.kAddress] as? String ?? "N/A"
    websiteURL = record[DDGLocation.kWebsiteURL] as? String ?? "N/A"
    phoneNumber = record[DDGLocation.kPhoneNumber] as? String ?? "N/A"
    location = record[DDGLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
    squareAsset = record[DDGLocation.kSquareAsset] as? CKAsset
    bannerAsset = record[DDGLocation.kBannerAsset] as? CKAsset
  }

  var squareImage: UIImage {
    guard let squareAsset else { return PlaceholderImage.square }
    return squareAsset.convertToUIImage(in: .square)
  }

  var bannerImage: UIImage {
    guard let bannerAsset else { return PlaceholderImage.banner }
    return bannerAsset.convertToUIImage(in: .banner)
  }
}
