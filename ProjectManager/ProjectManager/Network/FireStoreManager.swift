//
//  FireStoreManager.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/26.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class FireStoreManager {
    private enum DBConstant {
        static let collection = "Plans"
        static let titleAttribute = "title"
        static let contentAttribute = "content"
        static let dateAttribute = "date"
        static let stateAttribute = "state"
        
    }
    
    private let fireStoreDB = Firestore.firestore().collection(DBConstant.collection)
    
    func add(data: Plan) {
        fireStoreDB
            .document(data.id.description)
            .setData([
                DBConstant.titleAttribute: data.title,
                DBConstant.contentAttribute: data.content,
                DBConstant.dateAttribute: data.deadLine,
                DBConstant.stateAttribute: data.processState
            ])
    }
    
    func update(data: Plan) {
        fireStoreDB
            .document(data.id.description)
            .updateData([
                DBConstant.titleAttribute: data.title,
                DBConstant.contentAttribute: data.content,
                DBConstant.dateAttribute: data.deadLine
            ])
    }
    
    func delete(data: Plan) {
        fireStoreDB
            .document(data.id.description)
            .delete()
    }
}

