//
//  RemoteConfigService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 9.09.22.
//

import Firebase
import Combine

protocol RemoteConfigServiceProtocol {
    var appConfig: AppConfig? { get }

    var appConfigPublisher: AnyPublisher<Void, Error> { get }
}

class RemoteConfigService: RemoteConfigServiceProtocol, ObservableObject {
    
    private let remoteConfig: RemoteConfig
    
    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig
        
        loadDefaultValues()
        configSettings()
    }
    
    var appConfig: AppConfig?
            
    var appConfigPublisher: AnyPublisher<Void, Error> {
        return configPublisher()
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
                    if result == .successFetchedFromRemote {
                        print("fetched from remote")
                    }
                    if result == .successUsingPreFetchedData {
                        print("pre fetched data")
                    }
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func configPublisher() -> AnyPublisher<Void, Error> {
        fetchAndActivate()
            .map { _ in return () }
            .handleEvents(receiveOutput: { [unowned self] config in
                let mappedConfig = mapRemoteConfig()
                appConfig = mappedConfig
            })
            .eraseToAnyPublisher()
    }
    
    private func mapRemoteConfig() -> AppConfig {
        let isloginButtonPink = remoteConfig.configValue(forKey: Constants.FeatureFlagKeys.isloginButtonPink.rawValue).boolValue
        
        let loginConfigString = remoteConfig.configValue(forKey: Constants.FeatureFlagKeys.loginConfig.rawValue).stringValue ?? ""
        let loginConfigData = Data(loginConfigString.utf8)
        let loginConfig = try? JSONDecoder().decode(LoginConfig.self, from: loginConfigData)
        
        let appConfig = AppConfig(
            loginConfig: loginConfig,
            isloginButtonPink: isloginButtonPink
        )
        
        return appConfig
    }
}
