//
//  LogoListable.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import Foundation

protocol LogoListable: Identifiable {
    var id: Int { get }
    var name: String? { get }
    var logo: String? { get }
}
