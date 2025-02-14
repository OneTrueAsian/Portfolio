//
//  Collection.swift
//  SkullKing
//
//  Created by Joey on 1/22/25.
//

import Foundation

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
