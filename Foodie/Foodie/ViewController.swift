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
        imagePicker.sourceType = .camera
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
        guard let model = try? VNCoreMLModel(for: Food101().model) else {
            fatalError("Loading CoreML Mosel Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("model failed to process the image")
            }
            
            if let firstResult = results.first {
                guard let Observation = results.first else {
                    fatalError("try more you cam nail it!")
                }
                // relace"_" in food name with " " to make user comfortable woc wo tai ta ma li hai le
                let nameOfFood = Observation.identifier.replacingOccurrences(of: "_", with: " ")
                print(firstResult)
                self.navigationItem.title = "\(nameOfFood)"
                
                // collect results in UITexView
                self.foodRecordString = self.foodRecordString + "  [\(nameOfFood)]"
                self.foodRecord.text = self.foodRecordString
                //}
            }
            print(results)
            
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
