//
//  Channel.swift
//  Channel
//
//  Created by Nikolay Beznos on 22.07.2021.
//

import Foundation

enum ChannelType: Int {
    case buy
    case sell
}

struct Channel: Decodable {
    let id: Int             //Trade unique ID.
    let amount: Double      //Trade amount.
    let amount_str: String  //Trade amount represented in string format.
    let price: Double       //Trade price.
    let price_str: String   //Trade price represented in string format.
    let type: Int           //Trade type (0 - buy; 1 - sell).
    let timestamp: String   //Trade timestamp.
    let microtimestamp: String //Trade microtimestamp.
    let buy_order_id: Int   //Trade buy order ID.
    let sell_order_id: Int  //Trade sell order ID.
    
    func typeBool() -> ChannelType? {
        switch type {
        case 0: return .buy
        case 1: return .sell
        default: return nil
        }
    }
}

struct LiveTrade: Decodable {
    let channel: String
    let data: Channel
    let event: String
}
