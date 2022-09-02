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
        VStack {
            Spacer()

            Text(R.string.localizable.honestmate())
                .font(.largeTitle)
                        
            TextField(R.string.localizable.signinEmail(), text: $viewModel.email)
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)

            SecureField(R.string.localizable.signinPassword(), text: $viewModel.password)
                .frame(height: 44)
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
