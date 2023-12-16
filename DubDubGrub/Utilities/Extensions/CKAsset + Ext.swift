//
//  CKAsset + Ext.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-07.
//

import CloudKit
import UIKit

extension CKAsset {
  func convertToUIImage(in dimension: ImageDimension) -> UIImage {
    let placeholder = dimension.placeholder

    guard let fileURL else { return placeholder }

    do {
      let data = try Data(contentsOf: fileURL)
      return UIImage(data: data) ?? placeholder
    } catch {
      return placeholder
    }
  }
}
