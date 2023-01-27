//
//  FireStoreManager.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/26.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CRUDManageable {
    func load(_ process: Process, completion: @escaping ([Plan]) -> Void)
    func add(data: Plan)
    func update(data: Plan)
    func delete(data: Plan)
}

final class FireStoreManager: CRUDManageable {
    private enum DBConstant {
        static let collection = "Plans"
        static let titleAttribute = "title"
        static let contentAttribute = "content"
        static let dateAttribute = "date"
        static let stateAttribute = "state"
    }
    
    private let fireStoreDB = Firestore.firestore().collection(DBConstant.collection)
    
    func load(_ process: Process, completion: @escaping ([Plan]) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        fireStoreDB.whereField(
            DBConstant.stateAttribute,
            isEqualTo: process.state
        ).getDocuments { querySnapshot, error in
            var plans: [Plan] = []
            
            if let error = error {
                print(error)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    let result = self.convertPlan(from: document)
                    
                    switch result {
                    case .success(let data):
                        plans.append(data)
                    case .failure(let error):
                        //TODO: - Error 처리
                        print(error)
                    }
                }
                completion(plans)
            }
        }
    }

    func add(data: Plan) {
        fireStoreDB
            .document(data.id.description)
            .setData([
                DBConstant.titleAttribute: data.title,
                DBConstant.contentAttribute: data.content,
                DBConstant.dateAttribute: Timestamp(date: data.deadLine),
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
    
    private func convertPlan(from document: QueryDocumentSnapshot) -> Result<Plan, FireBaseError> {
        guard let id = UUID(uuidString: document.documentID),
              let stamp = document.data()[DBConstant.dateAttribute] as? Timestamp,
              let state = document.data()[DBConstant.stateAttribute] as? Int else {
            return .failure(FireBaseError.dataError)
        }
        
        let title = document.data()[DBConstant.titleAttribute] as? String ?? ""
        let content = document.data()[DBConstant.contentAttribute] as? String ?? ""
        let date = stamp.dateValue()
        
        let data = Plan(id: id, title: title, content: content, deadLine: date, processState: state)
        
        return .success(data)
    }
}
