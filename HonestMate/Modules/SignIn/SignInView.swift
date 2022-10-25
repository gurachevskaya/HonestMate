//
//  SignInView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI
import Resolver

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ZStack {
                VStack {
                    Spacer()
                    
                    title
                    
                    picker
                    
                    Spacer().frame(height: 30)
                    
                    Group {
                        if viewModel.selected == .register {
                            nameTextField
                        }
                        
                        emailTextField
                        
                        passwordTextField
                        
                        if viewModel.selected == .register {
                            confirmPasswordTextField
                        }
                    }
                    
                    signInButtons
                        .padding(.top, 30)
                    
                    actionButton
                    
                    Spacer()
                }
                .padding()
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: alertItem.dismissButton)
                }
                
                if viewModel.isLoading {
                    ProgressView().scaleEffect(2)
                }
            }
            .navigationDestination(for: SignInRoute.self) { route in
                route.view()
            }
        }
    }
    
    var title: some View {
        Text(R.string.localizable.honestmate())
            .font(.title)
            .fontWeight(.bold)
            .accessibilityIdentifier(Constants.AccessebilityIDs.titleLabel)
    }
    
    var picker: some View {
        Picker("", selection: $viewModel.selected) {
            ForEach(SignInViewModel.PickerCase.allCases, id: \.self) { value in
                Text(value.title).tag(value)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    var nameTextField: some View {
        TextField("Name", text: $viewModel.name, onEditingChanged: { _ in
            viewModel.name = viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines)
        })
        .modifier(TextFieldCustomRoundStyle())
        .accessibilityIdentifier(Constants.AccessebilityIDs.emailTextField)
    }
    
    var emailTextField: some View {
        TextField(R.string.localizable.signinEmail(), text: $viewModel.email, onEditingChanged: { _ in
            viewModel.email = viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines)
        })
        .modifier(TextFieldCustomRoundStyle())
        .accessibilityIdentifier(Constants.AccessebilityIDs.emailTextField)
    }
    
    var passwordTextField: some View {
        SecureField(R.string.localizable.signinPassword(), text: $viewModel.password)
            .modifier(TextFieldCustomRoundStyle())
            .accessibilityIdentifier(Constants.AccessebilityIDs.passwordTextField)
    }
    
    var confirmPasswordTextField: some View {
        SecureField(R.string.localizable.signinPasswordConfirm(), text: $viewModel.confirmPassword)
            .modifier(TextFieldCustomRoundStyle())
            .accessibilityIdentifier(Constants.AccessebilityIDs.confirmPasswordTextField)
    }
    
    var signInButtons: some View {
        SignInButtonsStack(viewModel: viewModel)
    }
    
    var actionButton: some View {
        Button {
            viewModel.actionButtonTapped()
        } label: {
            RoundedTextButton(
                title: viewModel.selected == .login ?  R.string.localizable.signinButtonTitleSignin() : R.string.localizable.signinButtonTitleSighup(),
                style: .filled(Color(hex: viewModel.accentColor ?? ""))
            )
        }
        .padding(.top, 20)
        .disabled(!viewModel.actionButtonEnabled)
        .accessibilityIdentifier(Constants.AccessebilityIDs.signInButton)
    }
    
}

struct SignInButtonsStack: View {
    
    @ObservedObject private(set) var viewModel: SignInViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            if viewModel.loginConfig?.facebookEnabled == true {
                Button(
                    action: {  },
                    label: { R.image.facebookLogo.image })
            }
            if viewModel.loginConfig?.appleEnabled == true {
                Button(
                    action: {  },
                    label: { R.image.appleLogo.image })
            }
            if viewModel.loginConfig?.googleEnabled == true {
                Button(
                    action: {  },
                    label: { R.image.googleLogo.image })
            }
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView(
                viewModel: SignInViewModel(
                    authService: Resolver.resolve(),
                    remoteConfigService: Resolver.resolve()
                )
            )
        }
    }
}
