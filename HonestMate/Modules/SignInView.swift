//
//  SignInView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI
import Resolver

struct SignInView: View {
    
    @ObservedObject var viewModel = SignInViewModel(authService: Resolver.resolve())
    
    var title: some View {
        Text(R.string.localizable.honestmate())
            .font(.largeTitle)
    }
    
    var picker: some View {
        Picker("", selection: $viewModel.selected) {
            ForEach(SignInViewModel.PickerCase.allCases, id: \.self) { value in
                Text(value.title).tag(value)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    var emailTextField: some View {
        TextField(R.string.localizable.signinEmail(), text: $viewModel.email, onEditingChanged: { _ in
            viewModel.email = viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines)
        })
        .modifier(TextFieldCustomRoundStyle())
    }
    
    var passwordTextField: some View {
        SecureField(R.string.localizable.signinPassword(), text: $viewModel.password)
            .modifier(TextFieldCustomRoundStyle())
    }
    
    var confirmPasswordTextField: some View {
        SecureField(R.string.localizable.signinPasswordConfirm(), text: $viewModel.confirmPassword)
            .modifier(TextFieldCustomRoundStyle())
    }
    
    var actionButton: some View {
        Button {
            viewModel.login()
        } label: {
            RoundedTextButton(title: viewModel.selected == .login ?  R.string.localizable.signinButtonTitleSignin() : R.string.localizable.signinButtonTitleSighup(), style: .blue)
        }
        .padding(.top, 20)
        .disabled(!viewModel.actionButtonEnabled)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                title
                
                picker
                
                emailTextField
                    .padding(.top, 30)
                
                passwordTextField
                
                if viewModel.selected == .register {
                    confirmPasswordTextField
                }
                
                actionButton
                
                Spacer()
            }
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
            .fullScreenCover(isPresented: $viewModel.isShowingMyEvents) {
                MyEventsView(
                    viewModel: MyEventsViewModel(
                        authService: Resolver.resolve(),
                        isShowingMyEvents: $viewModel.isShowingMyEvents)
                )
            }

            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView(viewModel: SignInViewModel(authService: Resolver.resolve()))
                .environment(\.colorScheme, .light)
            
            SignInView(viewModel: SignInViewModel(authService: Resolver.resolve()))
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
        }
    }
}
