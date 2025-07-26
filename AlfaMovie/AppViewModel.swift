//
//  AppViewModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var shouldShowMainView: Bool = false
    @Published var shouldShowNoInternetConnection: Bool = false
    @Published var shouldShowSlowInternetView: Bool = false
    @Published var shouldShowSessionIssue: Bool = false
    @Published var showFailedToFetchRemoteConfig: Bool = false
    private var cancellables = Set<AnyCancellable>()
    let notificationCenter = NotificationCenter.default
    
    init() {
        FirebaseApp.configure()
        getRemoteConfig()
        subscribe()
        observeNotificationCenter()
    }
    
    func getRemoteConfig(){
        showFailedToFetchRemoteConfig = false
        RemoteConfigProvider.shared.fetchCloudValues()
        RemoteConfigProvider.shared.loadingDoneCallback = { [weak self] error in
            if let error = error{
                if let authentication = UserDefaults.standard.value(forKey: "remoteConfigAuthentication") as? String{
                    self?.shouldShowMainView = true
                }else{
                    self?.showFailedToFetchRemoteConfig = true
                }
            }else{
                DispatchQueue.main.async {
                    print("authentication: \(RemoteConfigProvider.shared.authentication())")
                    self?.shouldShowMainView = true
                    UserDefaults.standard.set(RemoteConfigProvider.shared.authentication(), forKey: "remoteConfigAuthentication")
                }
            }
        }
    }
    
    func subscribe(){
        NetworkMonitor.shared.statusPublisher.receive(on: DispatchQueue.main).sink { isConnected in
            if isConnected{
                self.notificationCenter.post(name: .backOnline, object: nil)
            }else{
                self.notificationCenter.post(name: .noInternetNotification, object: nil)
            }
            withAnimation {
                self.shouldShowNoInternetConnection = !isConnected
            }
        }.store(in: &cancellables)
    }
    
    //MARK: It will catch a notification sent by Network Executor or by NetworkMonitor when user try to make an API call
    func observeNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(noInternet), name: .noInternetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backOnline), name: .backOnline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(slowInternetNotification), name: .slowInternetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionIssueNotification), name: .sessionIssue, object: nil)
    }
    
    func userAskToReload(){
        NotificationCenter.default.post(name: .userAskToReload, object: nil)
    }
    
    @objc func slowInternetNotification(){
            Task{
                await MainActor.run {
                    withAnimation {
                        shouldShowSlowInternetView = true
                    }
                }
                try? await Task.sleep(nanoseconds: 5000_000_000)
                await MainActor.run {
                    withAnimation {
                        shouldShowSlowInternetView = false
                    }
                }
        }
    }
    
    @objc func sessionIssueNotification(){
            Task{
                await MainActor.run {
                    withAnimation {
                        shouldShowSessionIssue = true
                    }
                }
                try? await Task.sleep(nanoseconds: 5000_000_000)
                await MainActor.run {
                    withAnimation {
                        shouldShowSessionIssue = false
                    }
                }
        }
    }
    
    @objc func noInternet(){
        withAnimation {
            shouldShowNoInternetConnection = true
        }
    }
    
    @objc func backOnline(){
        withAnimation {
            shouldShowNoInternetConnection = false
        }
    }
}
