//
//  ContentView.swift
//  Socket - iOS
//
//  Created by 양시관 on 1/28/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject var webSocketManager = WebSocketManager()

    var body: some View {
        VStack {
            // 수신된 메시지를 표시하는 뷰
            List(webSocketManager.receivedMessages, id: \.self) { message in
                Text(message)
                Text("메세지 보냇음")
            }

            // 메시지를 보내는 버튼
            Button("Send Message") {
                // 'Hello, World!' 메시지를 서버로 전송합니다.
                webSocketManager.sendMessage("양시관")
                    print("메세지 액션 시작함")
                
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .onAppear {
            // 뷰가 나타날 때 웹소켓 연결을 시작합니다.
            webSocketManager.connect()
            print("소켓연결 시작했음")
        }
        .onDisappear {
            // 뷰가 사라질 때 웹소켓 연결을 종료합니다.
            webSocketManager.disconnect()
            print("소켓연결 끝났음")
        }
    }
}


#Preview {
    ContentView()
}
