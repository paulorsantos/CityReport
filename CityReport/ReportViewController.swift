import UIKit

class ReportViewController: UIViewController {
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textViewNote: UITextView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var report: Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reportFormViewController = segue.destination as? ReportFormViewController {
            reportFormViewController.report = report
        }
    }
    
    func prepareScreen() {
        if let report = report {
            if let image = report.photo {
                imageViewPhoto.image = UIImage(data: image)
            }
            
            labelTitle.text = report.title
            labelDate.text = report.date
            labelAddress.text = report.address
            textViewNote.text = report.note
        }
    }
}
