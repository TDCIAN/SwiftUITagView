//
//  Tag.swift
//  SwiftUITagView
//
//  Created by 김정민 on 6/30/25.
//

import Foundation

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
