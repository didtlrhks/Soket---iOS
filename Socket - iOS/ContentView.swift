//
//  ContentView.swift
//  Socket - iOS
//
//  Created by 양시관 on 1/28/24.
//

import SwiftUI
import Foundation


struct ContentView: View {
    @StateObject var viewModel = RabbitMQViewModel()

    var body: some View {
        VStack {
            List(viewModel.receivedMessages, id: \.self) { message in
                Text(message)
            }
            Button("Send Message") {
                         // 이 부분에서 메시지를 보냅니다.
                         viewModel.sendMessage("Hello RabbitMQ")
                     }
        }
        .onAppear {
            viewModel.connectToRabbitMQ()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}



#Preview {
    ContentView()
}
