import UIKit

class ReportFormViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var textViewNote: UITextView!
    @IBOutlet weak var buttonAddEdit: UIButton!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var report: Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let report = report {
            title = "Edição"
            textFieldTitle.text = report.title
            textFieldAddress.text = report.address
            textFieldDate.text = report.date
            textViewNote.text = report.note
            
            if let photo = report.photo {
                imageViewPhoto.image = UIImage(data: photo)
            }
            
            buttonAddEdit.setTitle("Alterar", for: UIControl.State.normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você deseja escolher a foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) {_ in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) {_ in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let albumAction = UIAlertAction(title: "Álbum de Fotos", style: .default) {_ in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
                                        
    @IBAction func save(_ sender: UIButton) {
        if report == nil {
            report = Report(context: context)
        }
        
        report?.title = textFieldTitle.text
        report?.note = textViewNote.text
        report?.date = textFieldDate.text
        report?.address = textFieldAddress.text
        report?.photo = imageViewPhoto.image?.jpegData(compressionQuality: 0.9)
        
        try? context.save()
        
        navigationController?.popViewController(animated: true)
    }
}
                
extension ReportFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageViewPhoto.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
