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

            Text("Honestmate")
                .font(.largeTitle)
                        
            TextField("Email", text: $viewModel.email)
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)

            SecureField("Password", text: $viewModel.password)
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)

            Button {
                viewModel.login()
            } label: {
                RoundedTextButton(title: "Sign In", style: .blue)
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
            
//            SignInView(viewModel: SignInViewModel())
//                .environment(\.colorScheme, .dark)
        }
    }
}
