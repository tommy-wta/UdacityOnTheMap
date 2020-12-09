//
//  UserData.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import Foundation

struct UserData: Codable {
    let firstName: String
    let lastName: String
    let nickname: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
