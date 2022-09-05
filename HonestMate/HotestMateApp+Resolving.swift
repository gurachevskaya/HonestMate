//
//  HotestMateApp+Resolving.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { AuthService() as AuthServiceProtocol }.scope(.application)
    }
}
