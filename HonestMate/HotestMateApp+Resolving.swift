//
//  HotestMateApp+Resolving.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerCores()
        registerServices()
    }
    
    private static func registerCores() {
    }
    
    private static func registerServices() {
        register { AuthService() as AuthServiceProtocol }.scope(.application)
        register { AppState() as AppStateProtocol }.scope(.application)
        register { RemoteConfigService() as RemoteConfigServiceProtocol }.scope(.application)
    }
}
