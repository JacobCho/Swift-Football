//
//  Player.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Player: Decodable {
    let id: Int
    let name: String?
    let firstName: String?
    let lastName: String?
    let age: Int?
    let birth: Birth?
    let nationality: String?
    let height: String?
    let weight: String?
    let injured: Bool?
    let photo: String?
}
