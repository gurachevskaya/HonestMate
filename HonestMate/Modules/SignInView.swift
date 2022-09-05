//
//  SignInView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text(R.string.localizable.honestmate())
                    .font(.largeTitle)
                
                Picker("", selection: $viewModel.selected) {
                    ForEach(SignInViewModel.PickerCase.allCases, id: \.self) { value in
                        Text(value.title).tag(value)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField(R.string.localizable.signinEmail(), text: $viewModel.email)
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.top, 30)
                
                SecureField(R.string.localizable.signinPassword(), text: $viewModel.password)
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                
                if viewModel.selected == .register {
                    SecureField(R.string.localizable.signinPasswordConfirm(), text: $viewModel.confirmPassword)
                        .padding(.horizontal, 20)
                        .frame(height: 50)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
                
                Button {
                    viewModel.login()
                } label: {
                    RoundedTextButton(title: viewModel.selected == .login ?  R.string.localizable.signinButtonTitleSignin() : R.string.localizable.signinButtonTitleSighup(), style: .blue)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
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
            SignInView(viewModel: SignInViewModel())
                .environment(\.colorScheme, .light)
            
            SignInView(viewModel: SignInViewModel())
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
        }
    }
}
