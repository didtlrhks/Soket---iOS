//
//  WebSocketManager.swift
//  Socket - iOS
//
//  Created by 양시관 on 1/28/24.
//

import Foundation
import SwiftUI
import RMQClient
import UIKit


class RabbitMQViewModel: ObservableObject {
    @Published var receivedMessages: [String] = []
    private var connection: RMQConnection?
    private var channel: RMQChannel?

    func connectToRabbitMQ() {
        let factory = RMQConnectionFactory()
        factory.hostName = "112.219.138.170"
        factory.userName = "neo"
        factory.password = "01579"

        self.connection = factory.newConnection()
        self.channel = connection?.createChannel()

        let queueName = channel?.queueDeclare().queueName
        channel?.queueBind(queueName, exchange: "neotest", routingKey: "")

        let consumer = RMQConsumer(channel: channel, queueName: queueName, options: .noLocal)
        consumer.onReceived { message in
            let body = message.body
            let text = String(data: body, encoding: .utf8) ?? ""
            DispatchQueue.main.async {
                self.receivedMessages.append(text)
            }
        }

        channel?.basicConsume(queueName, consumer: consumer)
    }

    func disconnect() {
        connection?.close()
    }
}
