//
//  StudentLocationData.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import Foundation

struct StudentLocationData: Codable {
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
