//
//  AuthenticationSession.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 2/28/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
    
    public func creatNewUser(email:String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
       
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {completion(.success(authDataResult))
                
            }
        }
        
    }
    
    
    public func signInExistingUsingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult,Error>) ->()){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
        
    }
    
}
