//
//  PowerHelper.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 14/1/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

enum PowerSlideState: Float {
    case all = 0
    case three = 3.7
    case eleven = 11
    case twenty = 22
    case fourty = 43
    case hundred = 150
    case threehundred = 300
}

func getState(from power: Float) -> PowerSlideState {
    switch power {
    case 0:
        return .all
    case 1...2:
        return .three
    case 3...4:
        return .eleven
    case 4...6:
        return .twenty
    case 7...8:
        return .fourty
    case 9...12:
        return .hundred
    case 13...16:
        return .threehundred
    default:
        return .all
    }
}
