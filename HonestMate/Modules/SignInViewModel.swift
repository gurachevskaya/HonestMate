//
//  SignInViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI
import CoreData

class SignInViewModel: ObservableObject {
    
    enum SignInRoute {
        case facebook, apple, google, mail
    }
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    
    func login() {
        //        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        //            if error != nil {
        //                print(error?.localizedDescription ?? "")
        //            } else {
        //                print("success")
        //            }
    }
    
}

