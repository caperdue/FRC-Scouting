//
//  ScoutTeamController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/15/21.
//

import Foundation
import UIKit
import ImageSlideshow

class ScoutTeamController: UIViewController, UINavigationControllerDelegate {
  var images: [UIImage] = []
  var imgPicker = UIImagePickerController()
  var takenImage: UIImage?
  var fullscreen = FullScreenSlideshowViewController()
  var inFullScreen = false
  var deleteButton = UIButton()

  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveTapped(_:)))
    
    deleteButton = UIButton(frame: CGRect(x: 10, y: self.view.frame.height-75, width: 100, height: 50))
    
    
    let delGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteImg))
    deleteButton.addGestureRecognizer(delGestureRecognizer)
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImgFullScreen))
    imgSlideshow.addGestureRecognizer(gestureRecognizer)
    
    let cancelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(turnOffFullScreen))
    fullscreen.closeButton.addGestureRecognizer(cancelGestureRecognizer)
   
    self.navigationItem.rightBarButtonItem = rightBarButton
    imgPicker.allowsEditing = true
    imgPicker.delegate = self
    
    inFullScreen = false
    
    checkPickerConstraint()
  
  }

  @IBOutlet weak var teamNumberField: UITextField!
  @IBOutlet weak var teamNameField: UITextField!
  @IBOutlet weak var commentsTextView: UITextView!
  @IBOutlet weak var likeControl: UISegmentedControl!
  @IBOutlet weak var pictureStackView: UIStackView!
  @IBOutlet weak var imgSlideshow: ImageSlideshow!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  @IBAction func cameraBtnPressed(_ sender: UIButton) {
    imgPicker.sourceType = .camera
    self.presentImgPicker()
    
  }

  @IBAction func galleryBtnPressed(_ sender: UIButton) {
    imgPicker.sourceType = .photoLibrary
    self.presentImgPicker()
    
  }
  func checkPickerConstraint() {
    if imgSlideshow.images.count == 0 {
      imgSlideshow.isHidden = true
      heightConstraint.constant = 100
    }
    
    else {
      imgSlideshow.isHidden = false
      heightConstraint.constant = 300
    }
    
  }
  @objc func deleteImg() {
    print("ran")
    var newSet = fullscreen.slideshow.images
    if imgSlideshow.images.count != 0 {
      newSet.remove(at: fullscreen.slideshow.currentPage)
    }
    else {
      self.dismiss(animated: true, completion: nil)
    }
    imgSlideshow.setImageInputs(newSet)
  }
  
  @objc func turnOffFullScreen() {
    inFullScreen = false
    checkPickerConstraint()
    self.dismiss(animated: true, completion: nil)
  }
  // FIX ME: Do the image slideshow programatically to support being able to add the slideshow and have no layout issues. Probably more efficient.
  @objc func presentImgFullScreen() {
    if !inFullScreen {

    deleteButton.setTitleColor(.white, for: .normal)
    deleteButton.setTitle("Delete", for: .normal)
  
    fullscreen.slideshow = imgSlideshow
    fullscreen.view.addSubview(deleteButton)
    
    self.present(fullscreen, animated: true, completion: nil)
    inFullScreen = true
    }
  }
  
  func presentImgPicker() {
    self.navigationController?.present(imgPicker, animated: true, completion: {
      
    })
  }
  
  @objc func saveTapped(_ sender: UIBarButtonItem) {
    
    
    let numText = teamNumberField.text!
    if !numText.isEmpty && Int(numText) != nil {
      let commentText = commentsTextView.text!.isEmpty ? nil : commentsTextView.text!
      
      do {
    
        _ = try Utilities.db.collection("Users").document(Utilities.uid!).collection("teams").document(teamNumberField.text!).setData(from: UserTeam(id: numText, number: Int(numText)!, nickname: teamNameField.text!, comments: commentText, likeStatus: likeControl.selectedSegmentIndex))
     
      }
      
      catch {
        
        print(error.localizedDescription)
        
      }
      navigationController?.popViewController(animated: true)
    }
  }
}

extension ScoutTeamController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    if let image = info[.editedImage] as? UIImage {
      takenImage = image
      var newSet = self.imgSlideshow.images
      newSet.append(ImageSource(image: takenImage!))
      
      
      self.imgSlideshow.setImageInputs(newSet)
      checkPickerConstraint()
    }
  }
}
