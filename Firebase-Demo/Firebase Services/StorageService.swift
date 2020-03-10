//
//  StorageService.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/5/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseStorage
class StorageService{
    
    // In our application we will be uploading a photo to storage in two places:
    // 1. Profile view controller
    // 2. Create item view controller
    
    // We will be creating two different buckets of folders:
    // 1. User Profile photos/user.uid
    // 2. Items photos/itemId
    
    // Let us create a reference to the Firebase storage.
    
    private let storageRef = Storage.storage().reference()
    
    // Default parameters in Swift e.g. userId: String? = nil
    public func updatePhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL,Error>) -> ()){
        
        // 1. Convert UIImage to Data because this is the object we are posting to Firebase Storage.
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        // We need to establish which bucket, or collection, or folder we will be saving the photo to
        var photoReference: StorageReference!
        if let userId = userId{ // Coming from profile view controller
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpeg")
        } else if let itemId = itemId{ // Coming from create item view controller
            photoReference = storageRef.child("ItemsPhoto/\(itemId).jpeg")
        }
        
        // Configure metadata for the object being uploaded.
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
