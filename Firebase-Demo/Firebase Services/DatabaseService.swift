//
//  DatabaseService.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let itemsCollection = "items" // convention is using lowercase - we make a static let to prevent misspelling.
    static let usersCollection = "users"
    static let commentsCollection = "comments" // sub-collection on an item collection
    
    //review - firebase firestore hierarchy
    //topLevel
    //collection - > document -> collection -> document
    //get a reference to the Firebsae Firestore database
    private let database = Firestore.firestore()
    
    public func createItem(itemName: String, price: Double, catergory: Category, displayName: String, completion: @escaping (Result<String, Error>) ->()) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        //generate a document ID for the item collection - note that document could ANYTHING you make it
        
        let documentRef = database.collection(DatabaseService.itemsCollection).document()
        
        //create a document in out items collection
        database.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName" : itemName, "price": price, "itemId": documentRef.documentID, "listedDate" : Timestamp(date: Date()), "sellerName": displayName, "sellerId":user.uid,"categoryName": catergory.name ]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
                print("item was created \(documentRef.documentID) ")
            }
        }
        
    }
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool,Error>) -> ()){
        
        guard let email = authDataResult.user.email else {return}
        database.collection(DatabaseService.usersCollection).document(authDataResult.user.uid).setData(["email" : email, "createdDate":Timestamp(date: Date()),"userId": authDataResult.user.uid]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    public func updateDatabaseUser(displayName: String, photoURL:String, completion: @escaping (Result<Bool,Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        database.collection(DatabaseService.usersCollection).document(user.uid).updateData(["photoURL" : photoURL,"displayName":displayName]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    public func delete(item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        database.collection(DatabaseService.itemsCollection).document(item.itemID).delete() { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        }
    }
}
