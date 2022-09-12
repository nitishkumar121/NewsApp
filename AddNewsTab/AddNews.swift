import UIKit

class AddNews: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextViewDelegate, UITextFieldDelegate  {
    @IBOutlet weak private var addImage           : UIImageView!
    @IBOutlet weak private var shortDescription   : UITextView!
    @IBOutlet weak private var addNewsButton      : UIButton!
    @IBOutlet weak private var newsTitle          : UITextField!
    @IBOutlet weak private var fullDescription    : UITextView!
    @IBOutlet weak private var elskroll           : UIScrollView!
    @IBOutlet weak private var dateSeclectedInput : UITextField!
    var imagePickers = UIImagePickerController()
    var imageSet : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTitle.delegate = self
        self.shortDescription.delegate = self
        self.fullDescription.delegate = self
        imagePickers.delegate = self
        imagePickers.allowsEditing = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        elskroll.addGestureRecognizer(recognizer)
        self.dateSeclectedInput.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        self.setPlaceholerInTextView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setPlaceholerInTextView()
    }
    private func setPlaceholerInTextView(){
        shortDescription.text = StringConstant.shortDescription.rawValue
        fullDescription.textColor = UIColor.lightGray
        fullDescription.text = StringConstant.fullDescription.rawValue
        shortDescription.textColor = UIColor.lightGray
    }
    @objc func touch() {
        self.view.endEditing(true)
    }
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {   newsTitle.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch textView {
            case shortDescription :
                textView.text = StringConstant.shortDescription.rawValue
                textView.textColor = UIColor.lightGray
            default :
                textView.text = StringConstant.fullDescription.rawValue
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    // MARK: - Add Image Button
    @IBAction private func addImageFromPhotoLibrary(_ sender: UIButton) {
        if imageSet{
            
            let alert = UIAlertController(title:AlertNotification.alert.rawValue, message: AlertNotification.selectOption.rawValue, preferredStyle: UIAlertController.Style.actionSheet)
            let okayButton = UIAlertAction(title: AlertNotification.photoLibrary.rawValue, style: UIAlertAction.Style.default) { [self] action in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    self.imagePickers.delegate = self
                    imagePickers.sourceType = .photoLibrary
                    imagePickers.allowsEditing = true
                    present(imagePickers, animated: true,completion: nil)
                    imageSet = false
                }
            }
            let cancelButton = UIAlertAction(title:AlertNotification.cancleButtonTitle.rawValue , style: UIAlertAction.Style.cancel) { action in
                
            }
            alert.addAction(okayButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let alert = UIAlertController(title: AlertNotification.confirmationMessage.rawValue, message: AlertNotification.selectOption.rawValue, preferredStyle: UIAlertController.Style.actionSheet)
            let removeImage = UIAlertAction(title: AlertNotification.removeImage.rawValue, style: UIAlertAction.Style.default) { [self] action in
                self.addImage.image = UIImage(named:StringConstant.imageName.rawValue)
                imageSet = true
                
            }
            let addImage = UIAlertAction(title: AlertNotification.photoLibrary.rawValue, style: UIAlertAction.Style.default) { [self] action in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    self.imagePickers.delegate = self
                    imagePickers.sourceType = .photoLibrary
                    imagePickers.allowsEditing = true
                    present(imagePickers, animated: true,completion: nil)
                    imageSet = false
                }
            }
            let cancelButton = UIAlertAction(title:AlertNotification.cancleButtonTitle.rawValue ,style: UIAlertAction.Style.cancel) { action in
            }
            alert.addAction(removeImage)
            alert.addAction(addImage)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: - TextField Delegate
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.shortDescription.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        if textField == newsTitle {
            let maxLength = 20
            let currentString: NSString = newsTitle.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else {
            if range.length == 0{
                return false
            }
            return true
        }
    }
    
    //MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{ addImage.image = image
        }
    }
    
    //MARK: - TextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == shortDescription{
            var words: [Substring] = []
            let updatedText = (shortDescription.text as NSString).replacingCharacters(in: range, with: text)
            updatedText.enumerateSubstrings(in: updatedText.startIndex..., options: .byWords) {  _, range, _, _ in
                words.append(updatedText[range])
            }
            if words.count > 80{
                return false
            }
            else{
                return true
            }
            
        }
        else {
            return true
        }
    }
    
    //MARK: - ADD News Button
    @IBAction private func addNews( _ sender : UIButton){
        var missingInformationAlert = UIAlertController()
        if imageSet {
            missingInformationAlert = UIAlertController(title: AlertNotification.warningTitle.rawValue,message: WarningMessage.imageWarning.rawValue,preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: .cancel, handler: nil)
            missingInformationAlert.addAction(cancelAction)
            present(missingInformationAlert,animated: true,completion:nil) }
        
        else if(newsTitle.text!.isEmpty)  {
            missingInformationAlert = UIAlertController(title:AlertNotification.warningTitle.rawValue,message: WarningMessage.titleWarning.rawValue,preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: .cancel, handler: nil)
            missingInformationAlert.addAction(cancelAction)
            present(missingInformationAlert,animated: true,completion:nil) }
        
        else  if(shortDescription.text!.isEmpty) {
            missingInformationAlert = UIAlertController(title: AlertNotification.warningTitle.rawValue,message: WarningMessage.shortDescription.rawValue,preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: .cancel, handler: nil)
            missingInformationAlert.addAction(cancelAction)
            present(missingInformationAlert,animated: true,completion:nil) }
        else if(fullDescription.text!.isEmpty){
            missingInformationAlert = UIAlertController(title:AlertNotification.warningTitle.rawValue,message: WarningMessage.fullDescription.rawValue,preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: .cancel, handler: nil)
            missingInformationAlert.addAction(cancelAction)
            present(missingInformationAlert,animated: true,completion:nil) }
        else if(dateSeclectedInput.text!.isEmpty){
            missingInformationAlert = UIAlertController(title: AlertNotification.warningTitle.rawValue,message: WarningMessage.date.rawValue,preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: .cancel, handler: nil)
            missingInformationAlert.addAction(cancelAction)
            present(missingInformationAlert,animated: true,completion:nil) }
        
        else{
            let fullDescriptionCheck = fullDescription.text.components(separatedBy: " ")
            
            if fullDescriptionCheck.count >= 40{
                NewFeed.shared.addNewData(data: AllNewsFeed(title: newsTitle.text!, shortDescription: shortDescription.text, longDescription: fullDescription.text, newsImage: addImage.image!, newsUploadDate: dateSeclectedInput.text!))
                
                allNewsDateSet.insert( dateSeclectedInput.text!)
                self.newsTitle.text = nil
                self.dateSeclectedInput.text = nil
                self.setPlaceholerInTextView()
                self.imageSet = true
                self.addImage.image = UIImage(named: StringConstant.imageName.rawValue)
                let alert = UIAlertController(title: AlertNotification.confirmationMessage.rawValue, message: StringConstant.newsAddSusscessfullyMessage.rawValue, preferredStyle: UIAlertController.Style.actionSheet)
                let okayButton = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: UIAlertAction.Style.default) {  action in
                    sectionDate()
                }
                alert.addAction(okayButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                missingInformationAlert = UIAlertController(title:AlertNotification.warningTitle.rawValue,message: WarningMessage.chackFullDescriptionWarning.rawValue,preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: AlertNotification.cancelActionTitle.rawValue, style: .cancel, handler: nil)
                missingInformationAlert.addAction(cancelAction)
                present(missingInformationAlert,animated: true,completion:nil)
                
            }
        }
        
    }
    @objc func tapDone() {
        if let datePicker = self.dateSeclectedInput.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = DateFormate.dateFormate.rawValue
            self.dateSeclectedInput.text = dateformatter.string(from: datePicker.date)
        }
        self.dateSeclectedInput.resignFirstResponder()
    }
}

//MARK: - TextField Extension For Date Pick In Text Field
extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .dateAndTime
        let currentDate = Date()
        datePicker.maximumDate = currentDate
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: AlertNotification.cancleButtonTitle.rawValue , style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: AlertNotification.done.rawValue, style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
