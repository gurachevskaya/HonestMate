//
//  RemoteConfigMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 14.09.22.
//

import Foundation
import Combine

class RemoteConfigMock: RemoteConfigServiceProtocol {
    var appConfig: AppConfig? = AppConfig(
        loginConfig: LoginConfig(
            facebookEnabled: true,
            googleEnabled: true,
            appleEnabled: true
        ),
        isloginButtonPink: true
    )
    
    var appConfigPublisher: AnyPublisher<Void, Error> {
        configPublisherMock()
    }

    private func configPublisherMock() -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

