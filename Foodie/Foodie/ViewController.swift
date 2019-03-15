//
//  ViewController.swift
//  Foodie
//
//  Created by apple on 3/14/19.
//  Copyright © 2019 EudoraHan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIPickerViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
         
            imageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
       
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
        
        
        
    }
    
}

