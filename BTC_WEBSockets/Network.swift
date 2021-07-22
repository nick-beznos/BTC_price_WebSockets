//
//  Network.swift
//  Network
//
//  Created by Nikolay Beznos on 22.07.2021.
//

import Foundation
import Starscream
import Combine

enum Pair: String {
    case btcusd
    case ethusd
}

protocol NetworkService {
    func subscribeToPair(_ pair: Pair)
    var isConnected: CurrentValueSubject<Bool, Never> { get }
    var channel: CurrentValueSubject<Channel?, Never> { get }
}

class NetworkManager: NetworkService {
    private let baseURL = URL(string: "wss://ws.bitstamp.net/")
    private var request = URLRequest(url: URL(string: "wss://ws.bitstamp.net/")!)
    private let socket: WebSocket
    var isConnected: CurrentValueSubject<Bool, Never> = .init(false)
    var channel: CurrentValueSubject<Channel?, Never> = .init(nil)

    
    init() {
        socket = WebSocket(request: request)
        socket.onEvent = { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .connected(let headers):
                self.isConnected.send(true)
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                self.isConnected.send(false)
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                let jsonData = string.data(using: .utf8)!
                print(string)
                do {
                    let trade: LiveTrade = try JSONDecoder().decode(LiveTrade.self, from: jsonData)
                    self.channel.send(trade.data)
                } catch let error {
                    print(error)
                    
                }
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnected.send(false)
            case .error(let error):
                self.isConnected.send(false)
                self.handleError(error)
            }
        }
        
        connect()
    }

    private func connect() {
        request.timeoutInterval = 5
        socket.connect()
    }
    
    private func handleError(_ error: Error?) {
        print(error?.localizedDescription ?? "")
    }
    
    func subscribeToPair(_ pair: Pair) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue("bts:subscribe", forKey: "event")
        jsonObject.setValue(["channel": "live_trades_\(pair.rawValue)"], forKey: "data")

        let jsonData: Data

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")

            socket.write(data: jsonData)
        } catch _ {
            print ("JSON Failure")
        }
    }
}
