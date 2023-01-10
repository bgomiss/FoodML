//
//  ViewController.swift
//  FoodML
//
//  Created by aycan duskun on 5.01.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true //to be able to edit the image set this to true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = selectedImage
            
            guard let ciImage = CIImage(image: selectedImage) else {
                fatalError("Could not convert to CIImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results?.first as? VNClassificationObservation else {
                fatalError("Couldnt classift the image")
            }
            self.navigationItem.title = results.identifier.capitalized
            }
        
        let handler = VNImageRequestHandler(ciImage: image)
                
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
            //print(results)
           // if let firstResult = results.first {
                
                //print(firstResult.identifier.description)
               // self.navigationItem.title = firstResult.identifier
                
//                if firstResult.identifier.contains("bottle") {
//                    self.navigationItem.title = "Bottle!"
//                } else {
//                    self.navigationItem.title = "Not Bottle!"
//                }
            }
        
        
        
    
    
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true)
    }
    
}
    
    

