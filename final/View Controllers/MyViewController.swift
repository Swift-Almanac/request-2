//
//  MyViewController.swift
//  final
//
//  Created by Mark Hoath on 16/10/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI

class MyViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var  record = MyData()
    
    var  mode: Mode!
    var  delegate: MyCollectionViewController!
    
    let nameTF = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    let genderSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    let ageStepper = UIStepper(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    let genderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
    let ageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
    
    let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveRecord))
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRecord))
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Name - Text Field
        // Gender - Switch
        // Age - Stepper
        
        setUpNavigation()
        
        checkPermission()
        
        genderSwitch.addTarget(self, action: #selector(genderSwitchTouch), for: .valueChanged)
        
        ageStepper.addTarget(self, action: #selector(ageStepperMove), for: .valueChanged)
        
        nameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        view.addSubview(nameTF)
        view.addSubview(genderSwitch)
        view.addSubview(ageStepper)
        view.addSubview(genderLabel)
        view.addSubview(ageLabel)
        view.addSubview(imageView)
        
        view.backgroundColor = .yellow
        
        setUpContraints()
        
        setUpValues()
        
    }
    
    func setUpNavigation() {

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titleLabel
        if record.name.isEmpty {
            titleLabel.text = "Add Record"
        } else {
            titleLabel.text = "Edit Record"
        }
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        record.name = textField.text!
        saveButton.isEnabled = !record.name.isEmpty
    }
    
    
    @objc func saveRecord() {
        
        print ("Save record")
        if mode == .add {
            delegate?.add(record: record)
        } else if mode == .edit {
            delegate?.modify(record: record)
        }
        else {
            print ("This Shouldn't Happen")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelRecord() {
        print ("Cancel Record")
        navigationController?.popViewController(animated: true)
    }

    
    @objc func genderSwitchTouch() {
        
        record.gender = genderSwitch.isOn
        genderLabel.text = (genderSwitch.isOn) ? "Female" : "Male"
    }
    
    @objc func ageStepperMove() {
        record.age = Int(ageStepper.value)
        ageLabel.text = String(describing: record.age)
    }
    
    func setUpValues() {
        imageView.image = record.theImages[0]
        nameTF.text = record.name
        nameTF.placeholder = "Your Name"
        nameTF.textAlignment = .center
        genderSwitch.isOn = record.gender
        genderLabel.text = (genderSwitch.isOn) ? "Female" : "Male"
        ageStepper.minimumValue = 18
        ageStepper.maximumValue = 100
        ageStepper.value = Double(record.age)
        ageLabel.text = String(describing: record.age)
        saveButton.isEnabled = !record.name.isEmpty
        nameTF.becomeFirstResponder()
        
    }
    
    func setUpContraints() {
        
        //   Image View
        
        //      Centre X, Top +25  , Height (30), Width (160)
        
        
        let ivCentreX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 25)
        let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 90)
        let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 90)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([ivCentreX, ivTop, ivHeight, ivWidth])

        
        //   Name Text
        
        //      Centre X, Top +150  , Height (30), Width (160)
        
        
        let nameCentreX = NSLayoutConstraint(item: nameTF, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let nameTop = NSLayoutConstraint(item: nameTF, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 150)
        let nameHeight = NSLayoutConstraint(item: nameTF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
        let nameWidth = NSLayoutConstraint(item: nameTF, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 160)
        
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([nameCentreX, nameTop, nameHeight, nameWidth])

        //   Gender Switch
        
        //      Centre X, Top +200  , Height (30), Width (80)
        
        
        let genderCentreX = NSLayoutConstraint(item: genderSwitch, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: -30)
        let genderTop = NSLayoutConstraint(item: genderSwitch, attribute: .top, relatedBy: .equal, toItem: nameTF, attribute: .bottom, multiplier: 1.0, constant: 100)
        let genderHeight = NSLayoutConstraint(item: genderSwitch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
        let genderWidth = NSLayoutConstraint(item: genderSwitch, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 60)
        
        genderSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([genderCentreX, genderTop, genderHeight, genderWidth ])

        //   Age Stepper
        
        //      Centre X, Top +300  , Height (30), Width (80)
        
        
        let ageCentreX = NSLayoutConstraint(item: ageStepper, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: -40)
        let ageTop = NSLayoutConstraint(item: ageStepper, attribute: .top, relatedBy: .equal, toItem: genderSwitch, attribute: .bottom, multiplier: 1.0, constant: 100)
        let ageHeight = NSLayoutConstraint(item: ageStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
        let ageWidth = NSLayoutConstraint(item: ageStepper, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 80)
        
        ageStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([ageCentreX, ageTop,ageWidth, ageHeight])
        
        //   Gender Label
        
        //      Centre X, Top +300  , Height (30), Width (80)
        
        
        let glLeft = NSLayoutConstraint(item: genderLabel, attribute: .left, relatedBy: .equal, toItem: genderSwitch, attribute: .right, multiplier: 1.0, constant: 16)
        let glTop = NSLayoutConstraint(item: genderLabel, attribute: .top, relatedBy: .equal, toItem: genderSwitch, attribute: .top, multiplier: 1.0, constant: 0)
        let glHeight = NSLayoutConstraint(item: genderLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
        let glWidth = NSLayoutConstraint(item: genderLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 80)
        
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([glLeft, glTop, glWidth, glHeight])

        
        //   Age Label
        
        //      Centre X, Top +300  , Height (30), Width (80)
        
        
        let alLeft = NSLayoutConstraint(item: ageLabel, attribute: .left, relatedBy: .equal, toItem: ageStepper, attribute: .right, multiplier: 1.0, constant: 32)
        let alTop = NSLayoutConstraint(item: ageLabel, attribute: .top, relatedBy: .equal, toItem: ageStepper, attribute: .top, multiplier: 1.0, constant: 0)
        let alHeight = NSLayoutConstraint(item: ageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
        let alWidth = NSLayoutConstraint(item: ageLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 80)
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([alLeft, alTop, alWidth, alHeight])
    }
    
    @objc func handleTap() {
        // Display the Image Picker
        
        nameTF.resignFirstResponder()
        
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .popover
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageView.contentMode = .scaleAspectFit
            imageView.image = resizeImage(image: selectedImage, newWidth: 200)
            record.theImages[0] = imageView.image!
        }
        
        // Dismiss the picker.
        picker.dismiss(animated: true, completion: nil)
        
        // This is a Bug FIX... Not Needed once Xcode 9.unknown is released.
        saveRecord()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }

    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}
