//
//  AddImage.swift
//  UTrend

import Foundation
import UIKit
import Firebase

class AddImage : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var viewForImage: UIView!

    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var shoesButton: UIButton!

    var clothingType: String!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 15.0
        imageView.layer.masksToBounds = true

        viewForImage.layer.cornerRadius = 10
        viewForImage.layer.masksToBounds = true

        imagePicker.delegate = self
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        present(imagePicker, animated:true, completion:nil)
       }

    // camera function
    @IBAction func takePhoto(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                imagePicker.cameraCaptureMode = .photo
                imagePicker.modalPresentationStyle = .fullScreen
                present(imagePicker, animated: true, completion:nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera is unavailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]) {

        var newImage: UIImage

        if let maybeImage = info[.editedImage] as? UIImage {
            newImage = maybeImage
           } else if let maybeImage = info[.originalImage] as? UIImage {
            newImage = maybeImage
           } else { return }

        imageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func topButtonPressed(_ sender: UIButton) {
        self.clothingType = "top"
    }

    @IBAction func bottomButtonPressed(_ sender: UIButton) {
        self.clothingType = "bottom"
    }

    @IBAction func shoesButtonPressed(_ sender: UIButton) {
        self.clothingType = "shoes"
    }

    //using clothingType, determine type and add to closet
    @IBAction func addToCloset(_ sender: UIButton) {

        /*
        let actionTitle = "Are you sure?"
        let actionMessage = "Add to closet?"
        let actionOk = "Add to Closet"

        let actionController = UIAlertController(title: actionTitle, message: actionMessage, preferredStyle: .actionSheet)
        let actionOkay = UIAlertAction(title: actionOk, style: .default, handler:nil)

        actionController.addAction(actionOkay)
        */

        //get text from text field
        //var text: String? = textField.text
        var type: String = ""

        var shouldUpload : Bool = false

        /* //re did this part using variable clothingType instead of textfield ********
        if text?.contains("top") ?? false { //is top, add to top array
            print("top")
            type = "top"
            shouldUpload = true
        } else if text?.contains("bottom") ?? false { //is bottom, add to bottom array
            print("bottom")
            type = "bottom"
            shouldUpload = true
        } else if text?.contains("shoes") ?? false { //is shoes, add to shoes array
            print("shoes")
            type = "shoes"
            shouldUpload = true
        }*/

        if clothingType == "top" {
            print("top")
            type = "top"
            shouldUpload = true
        } else if clothingType == "bottom" {
            print("bottom")
            type = "bottom"
            shouldUpload = true
        } else if clothingType == "shoes" {
            print("shoes")
            type = "shoes"
            shouldUpload = true
        }

        //do not add
        else {

            let alertTitle = "Wait!"
            let alertMessage = "Please enter 'top', 'bottom', 'shoes' before adding to closet."
            let alertOk = "OK"

            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: alertOk, style: .default, handler: nil)

            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
        }

        // UPLOAD TO FIREBASE
        if shouldUpload {
            let imgData = imageView.image?.jpegData(compressionQuality: 0.4)
            let user = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            let imgN = UUID().uuidString
            let ref = Storage.storage().reference().child("users").child(user!).child("clothes")

            ref.child(imgN).putData(imgData!, metadata: nil) { (meta, err) in
                if err != nil {return}
            }

            db.collection("users").document(user!).collection("clothes").addDocument(data: ["imgName":imgN,"type":type])

        // refresh wardrobe collection

        }
    }

}
