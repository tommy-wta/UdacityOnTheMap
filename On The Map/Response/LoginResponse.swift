//
//  LoginResponse.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import Foundation

struct LoginResponse : Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
