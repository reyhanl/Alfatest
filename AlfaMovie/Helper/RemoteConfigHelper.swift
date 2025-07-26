//
//  Helper.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

//MARK: Credit
///https://medium.com/@katramesh91/how-to-integrate-firebase-remote-config-into-your-ios-app-a-complete-guide-895f5b9f294d

import FirebaseRemoteConfig

enum RemoteConfigValueKey: String {
    case authentication
}
/**
 Provider for communicate with firebase remote configs and fetch config values
 */
final class RemoteConfigProvider {
    static let shared = RemoteConfigProvider()
    var loadingDoneCallback: ((Error?) -> Void)?
    var fetchComplete = false
    var isDebug = true
    
    private var remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        setupConfigs()
        loadDefaultValues()
        setupListener()
    }
    
    func setupConfigs() {
        let settings = RemoteConfigSettings()
        // fetch interval that how frequent you need to check updates from the server
        settings.minimumFetchInterval = isDebug ? 0 : 43200
        remoteConfig.configSettings = settings
    }
    
    /**
     In case firebase failed to fetch values from the remote server due to internet failure
     or any other circumstance, In order to run our application without any issues
     we have to set default values for all the variables that we fetches
     from the remote server.
     If you have higher number of variables in use, you can use info.plist file
     to define the defualt values as well.
     */
    func loadDefaultValues() {
        let authentication = UserDefaults.standard.value(forKey: "remoteConfigAuthentication") as? String ?? ""
        let appDefaults: [String: Any?] = [
            RemoteConfigValueKey.authentication.rawValue: authentication
        ]
        remoteConfig.setDefaults(appDefaults as? [String: NSObject])
    }
    
    /**
     Setup listner functions for frequent updates
     */
    func setupListener() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard configUpdate != nil else {
                print("REMOTE CONFIG ERROR")
                return
            }
            
            self.remoteConfig.activate { changed, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("REMOTE CONFIG activation state change \(changed)")
                }
            }
        }
    }
    
    /**
         Function for fectch values from the cloud
     */
    func fetchCloudValues() {
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            guard let self = self else { return }
            
            if status == .success {
                self.remoteConfig.activate { _, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.fetchComplete = true
                    print("Remote config fetch success")
                    DispatchQueue.main.async {
                        self.loadingDoneCallback?(nil)
                    }
                }
            } else {
                print("Remote config fetch failed")
                DispatchQueue.main.async {
                    self.loadingDoneCallback?(error)
                }
            }
        }
    }
}

// MARK: Basic remote config value access methods

extension RemoteConfigProvider {
    func bool(forKey key: RemoteConfigValueKey) -> Bool {
        return remoteConfig[key.rawValue].boolValue
    }
    
    func string(forKey key: RemoteConfigValueKey) -> String {
        return remoteConfig[key.rawValue].stringValue
    }
    
    func double(forKey key: RemoteConfigValueKey) -> Double {
        return remoteConfig[key.rawValue].numberValue.doubleValue
    }
    
    func int(forKey key: RemoteConfigValueKey) -> Int {
        return remoteConfig[key.rawValue].numberValue.intValue
    }
}

// MARK: Getters for config values

extension RemoteConfigProvider {
    func authentication() -> String {
        return string(forKey: .authentication)
    }
}
