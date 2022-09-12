//
//  RemoteConfigService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 9.09.22.
//

import Firebase
import Combine

protocol RemoteConfigServiceProtocol {
    var loginConfigPublisher: AnyPublisher<LoginConfig, Error> { get }
}

class RemoteConfigService: RemoteConfigServiceProtocol, ObservableObject {
    
    private let remoteConfig: RemoteConfig
    
    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig
        
        loadDefaultValues()
        configSettings()
    }
            
    var loginConfigPublisher: AnyPublisher<LoginConfig, Error> {
        return loginPublisher()
    }
    
    private func loadDefaultValues() {
        remoteConfig.setDefaults(fromPlist: "appConfig")
    }
    
    private func configSettings() {
        let settings = RemoteConfigSettings()
        settings.fetchTimeout = 10.0 // timeout to 10s
        
        if EnvironmentConstants.isDebug {
            settings.minimumFetchInterval = 0
        } else {
            settings.minimumFetchInterval = 3600 * 4 // refresh every 4h
        }
        
        remoteConfig.configSettings = settings
    }
    
    private func fetchAndActivate() -> AnyPublisher<RemoteConfigFetchAndActivateStatus, Error> {
        Future<RemoteConfigFetchAndActivateStatus, Error> { [unowned self] promise in
            remoteConfig.fetchAndActivate { result, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func loginPublisher() -> AnyPublisher<LoginConfig, Error> {
        fetchAndActivate()
            .map { [unowned self] _ -> String in
                remoteConfig.configValue(forKey: Constants.FeatureFlagKeys.loginConfig.rawValue).stringValue ?? ""
            }
            .map { Data($0.utf8) }
            .decode(
                type: LoginConfig.self,
                decoder: JSONDecoder()
            )
            .eraseToAnyPublisher()
    }
}
