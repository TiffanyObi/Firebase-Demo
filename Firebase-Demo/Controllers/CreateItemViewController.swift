//
//  CreateItemViewController.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateItemViewController: UIViewController {
    
    @IBOutlet weak var itemNameTextfield: UITextField!
    @IBOutlet weak var itemPriceTextfield: UITextField!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    
    private var category: Category
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private var selectedImage: UIImage? {
        didSet {
            itemImageView.image = selectedImage
        }
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        return picker
        
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
        
    }()
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    init?(coder: NSCoder, category: Category) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = category.name
        itemNameTextfield.delegate =  self
        itemPriceTextfield.delegate = self
        
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(longPressGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        itemNameTextfield.resignFirstResponder()
        itemPriceTextfield.resignFirstResponder()
    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true)

        }
        
        let cancelAction = UIAlertAction(title: "Camera", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        present(alertController, animated:  true)
    }
    
    @IBAction func postIemButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let itemName = itemNameTextfield.text,
        !itemName.isEmpty,
            let itemPriceText = itemPriceTextfield.text,
            !itemPriceText.isEmpty,
            let price = Double(itemPriceText),
        let selectedImage = selectedImage else {
                showAlert(title: "Missings Fields", message: "All feilds are required along with a phone")
                return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please complete your profile")
            return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: itemImageView.bounds)
        
        dbService.createItem(itemName: itemName, price: price, catergory: category, displayName: displayName) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error creating item", message: "Sorry, something went wrong: \(error.localizedDescription)") }
            case .success(let documentID):
                self?.uploadPhoto(image: resizedImage, documentID: documentID)
                DispatchQueue.main.async {
                self?.showAlert(title: "Awesome!!", message: "Your item has been posted!") }
            }
        }
    }
        
        
        
    private func uploadPhoto(image: UIImage, documentID: String){
        
        storageService.updatePhoto(itemId: documentID, image: image) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error!", message: "\(error.localizedDescription)")
                }
                
            case .success(let url):
                self?.updateItemImageURL(url, documentID: documentID)
            
                }
            }
        }
        
    
    
private func updateItemImageURL(_ url: URL, documentID: String) {
    
    //upate an exisiting document on firebase
    
    Firestore.firestore().collection(DatabaseService.itemsCollection).document(documentID).updateData(["imageURL": url.absoluteString]) { [weak self] (error) in
        if let error = error {
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
            }
        } else {
            print("Everything well well with the update")
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
    
}
extension CreateItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        
        selectedImage = image
        dismiss(animated: true, completion: nil)
        
    }
}

extension CreateItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
