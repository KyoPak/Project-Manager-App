//
//  Plan.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/12.
//

import Foundation

struct Plan: Hashable, Decodable {
    let id: UUID
    var title: String
    var content: String
    var deadLine: Date
    var processState: Int
    
    var convertDeadline: String {
        return DateFormatter.convertToString(deadLine)
    }
    
    var isOverDeadLine: Bool {
        let now = DateFormatter.convertToString(Date())
        if now > convertDeadline {
            return true
        }
        return false
    }
}
