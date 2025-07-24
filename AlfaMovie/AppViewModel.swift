//
//  AppViewModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import Foundation
import Firebase

class AppViewModel: ObservableObject {
    @Published var shouldShowMainView: Bool = false

    init() {
        FirebaseApp.configure()
        RemoteConfigProvider.shared.fetchCloudValues()
        RemoteConfigProvider.shared.loadingDoneCallback = { [weak self] in
            DispatchQueue.main.async {
                print("authentication: \(RemoteConfigProvider.shared.authentication())")
                self?.shouldShowMainView = true
            }
        }
    }
}
