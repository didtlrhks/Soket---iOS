//
//  WebSocketManager.swift
//  Socket - iOS
//
//  Created by 양시관 on 1/28/24.
//

import Foundation
import Foundation
import SwiftUI


// 웹 소켓 연결을 관리하는 클래스
class WebSocketManager : ObservableObject{
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var receivedMessages: [String] = []
    
    // 웹 소켓 연결을 시작하는 함수
    func connect() {
        let url = URL(string: "ws://112.219.138.170:8080")! // 실제 웹소켓 서버 주소로 바꿔야 합니다.
        var request = URLRequest(url: url)
        let userName = "neo"
        let password = "01579"
            

        // 사용자 이름과 비밀번호를 Base64 인코딩하여 HTTP 기본 인증 헤더를 생성
        let credentials = "\(userName):\(password)"
        let credentialsData = Data(credentials.utf8)
        let base64Credentials = credentialsData.base64EncodedString(options: [])
        request.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")

        // 웹소켓 연결을 위한 URLSessionWebSocketTask 생성 및 시작
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()

        // 메시지 수신을 위한 리스너 시작
        listenForMessages()
    }
    // 메시지를 보내는 함수
    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }
    
    // 메시지를 수신하는 함수
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
                
                
            case .success(.string(let message)):
                DispatchQueue.main.async {
                                 self?.receivedMessages.append(message)
                             }
                self?.listenForMessages() 
                
                
                // 다음 메시지를 계속 수신하기 위해 재귀적으로 호출
            case .success(.data(let data)):
                print("Received data: \(data)")
                self?.listenForMessages() // 다음 메시지를 계속 수신하기 위해 재귀적으로 호출
            default:
                break
            }
        }
    }
    
    // 웹 소켓 연결을 종료하는 함수
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
