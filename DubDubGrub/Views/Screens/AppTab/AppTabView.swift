//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-05.
//

import SwiftUI

struct AppTabView: View {
  @StateObject private var viewModel = AppTabViewModel()

//  init() {
//    let appearance = UITabBarAppearance()
//    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//    UITabBar.appearance().scrollEdgeAppearance = appearance
//  }

  var body: some View {
    TabView {
      LocationMapView()
        .tabItem {
          Label("Map", systemImage: "map")
        }
      LocationListView()
        .tabItem {
          Label("Locations", systemImage: "building")
        }
      NavigationStack {
        ProfileView()
      }
      .tabItem {
        Label("Profile", systemImage: "person")
      }
    }
    .onAppear {
      viewModel.checkIfHasSeenOnboard()
    }
    .sheet(isPresented: $viewModel.isShowingOnboardView) {
      OnboardView()
    }
  }
}

#Preview {
  AppTabView()
}
