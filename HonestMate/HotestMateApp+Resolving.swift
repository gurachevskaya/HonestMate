//
//  HotestMateApp+Resolving.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import Resolver
import Foundation

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        registerCores()
        registerServices()
    }
    
    private static func registerCores() {
    }
    
    private static func registerServices() {
        if ProcessInfo.processInfo.arguments.contains("testing") {
            register { AuthServiceMock() as AuthServiceProtocol }.scope(.application)
            register { AppStateMock() as AppStateProtocol }.scope(.application)
            register { RemoteConfigMock() as RemoteConfigServiceProtocol }.scope(.application)
        } else {
            register { AuthService() as AuthServiceProtocol }.scope(.application)
            register { AppState() as AppStateProtocol }.scope(.application)
            register { RemoteConfigService() as RemoteConfigServiceProtocol }.scope(.application)
        }
    }
}
