//
//  ViewController.swift
//  Foodie
//
//  Created by 张唯维 on 3/18/19.
//  Copyright © 2019 张唯维. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self //i.e this current view control
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not cobvert to CIImage")
            }//an image type suitable for core M-L frame work, guard...is for safety
            detect(image: ciimage)
        }
        // the data you got from the dictionary should be in the type of UIImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Mosel Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("model failed to process the image")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog"
                } else if firstResult.identifier.contains("burger") {
                    self.navigationItem.title = "Burger"
                } else if firstResult.identifier.contains("ice cream") {
                    self.navigationItem.title = "Ice cream"
                } else if firstResult.identifier.contains("hotpot") {
                    self.navigationItem.title = "Hot pot"
                } else if firstResult.identifier.contains("pizza") {
                    self.navigationItem.title = "Pizza"
                } else if firstResult.identifier.contains("dark glasses"){
                    self.navigationItem.title = "Not Hotdog! Wait...Thug Hotdog!"
                }
                else {
                    guard let Observation = results.first else {
                        fatalError("try more you cam nail it!")
                    }
                    self.navigationItem.title = "I'm not sure but it maybe \(Observation.identifier)"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch { //try to do it and catch error occured
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

