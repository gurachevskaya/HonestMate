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
                
                TextField(R.string.localizable.signinEmail(), text: $viewModel.email)
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                
                SecureField(R.string.localizable.signinPassword(), text: $viewModel.password)
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                
                Button {
                    viewModel.login()
                } label: {
                    RoundedTextButton(title: R.string.localizable.signinButtonTitle(), style: .blue)
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
                .environment(\.colorScheme, .dark)
        }
    }
}
