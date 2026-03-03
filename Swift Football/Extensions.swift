//
//  Extensions.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-02.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it exists, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
