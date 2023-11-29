import UIKit

protocol sendPostData {
    func data(post: AllPosts)
}
protocol sendEditedData {
    func data(caption : String , location : CustomAnnotation , editIndex : Int , currentDate : String , currentTime : String)
}
protocol deletePost {
    func data(indexForDelete : Int)
}

class CreatePostVC: UIViewController {
    
    @IBOutlet var uNameTextField: UITextField!
    @IBOutlet var captionTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageBtn: UIButton!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var editPostBtn: UIButton!
    @IBOutlet var doneBtn: UIBarButtonItem!
    @IBOutlet var deletePostBtn: UIButton!
    
    var delegate : sendPostData!
    var sendDelegate : sendEditedData!
    var deleteDelegate : deletePost!
    var postLocation : CustomAnnotation!
    var editModePost : AllPosts?
    let picker = UIImagePickerController()
    var isEditMode = false
    var isEditModeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uNameTextField.layer.borderWidth = 0.3
        uNameTextField.layer.borderColor = UIColor.black.cgColor
        uNameTextField.layer.cornerRadius = 7.0
        captionTextView.layer.borderWidth = 0.3
        captionTextView.layer.borderColor = UIColor.black.cgColor
        captionTextView.layer.cornerRadius = 7.0
        picker.delegate = self
        uNameTextField.becomeFirstResponder()
        
        if isEditMode {
            navigationItem.title = "Edit Post"
            uNameTextField.isUserInteractionEnabled = false
            imageBtn.isUserInteractionEnabled = false
            captionTextView.isUserInteractionEnabled = false
            imageView.isUserInteractionEnabled = false
            locationBtn.isUserInteractionEnabled = false
            editPostBtn.isHidden = false
            captionTextView.text = editModePost!.caption
            uNameTextField.text = editModePost!.userName
            locationBtn.setTitle(editModePost!.postLocation, for: .normal)
            imageView.image = editModePost!.photo
            postLocation = editModePost!.locationAnnotation
            imageBtn.setTitle(" Post Image", for: .normal)
            doneBtn.isHidden = true
            deletePostBtn.isHidden = false
        }
    }
}

//MARK: - Button ClickEvents :
extension CreatePostVC {
    @IBAction func chooseImageBtn(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func addLocationBtn(_ sender: Any) {
        performSegue(withIdentifier: "LocationVC", sender: self)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        if isValid() {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: currentDate)
            let timeString = timeFormatter.string(from: currentDate)

            let post = AllPosts(userName: uNameTextField.text!, caption: captionTextView.text!, photo: imageView.image!, postLocation: locationBtn.currentTitle!, currentDate: dateString, currentTime: timeString, locationAnnotation: postLocation)
            delegate.data(post: post)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func editPostClick(_ sender: Any) {
        if isEditMode {
            captionTextView.isUserInteractionEnabled = true
            captionTextView.becomeFirstResponder()
            locationBtn.isUserInteractionEnabled = true
            editPostBtn.setTitle("Done", for: .normal)
            isEditMode = !isEditMode
        } else {
            if isValid() {
                let currentDatee = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let dateString = dateFormatter.string(from: currentDatee)
                let timeString = timeFormatter.string(from: currentDatee)
                sendDelegate.data(caption: captionTextView.text, location: postLocation, editIndex: isEditModeIndex,currentDate : dateString , currentTime : timeString)
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func deletePostBtn(_ sender: Any) {
        deleteDelegate.data(indexForDelete: isEditModeIndex)
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Important Methods :
extension CreatePostVC {
    func isValid () -> Bool{
        if uNameTextField.text == nil {
            uNameTextField.becomeFirstResponder()
            allertMessage(title: "Error", Message: "Invalid UserName")
            return false
        } else if captionTextView.text.isEmpty {
            captionTextView.becomeFirstResponder()
            allertMessage(title: "Error", Message: "Invalid Caption")
            return false
        } else if imageBtn.currentTitle == " Tap to Choose a Image" {
            allertMessage(title: "Error", Message: "Please Select a Image")
            return false
        } else if locationBtn.currentTitle == "Add Location" {
            allertMessage(title: "Error", Message: "Please Enter Location")
            return false
        } else {
            return true
        }
    }
    
    func allertMessage(title : String ,Message : String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LocationVC
        destinationVC.delegate = self
    }
}

//MARK: - Received Data :
extension CreatePostVC : sendData {
    func data(locationAnnotation: CustomAnnotation) {
        self.locationBtn.setTitle("\(locationAnnotation.title ?? "")", for: .normal)
        postLocation = locationAnnotation
    }
}

//MARK: - ImagePicker Delegate Methods :
extension CreatePostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        imageBtn.setTitle(" Click to Change", for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
