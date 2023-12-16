//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-07.
//

import Foundation

final class LocationManager: ObservableObject {
  @Published var locations: [DDGLocation] = []

  var selectedLocation: DDGLocation?
}
