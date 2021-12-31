import UIKit
import CoreData

class ReportTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Report>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReports()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reportViewController = segue.destination as? ReportViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            reportViewController.report = fetchedResultsController.object(at: indexPath)
        }
    }
    
    func loadReports() {
        let fetchRequest: NSFetchRequest<Report> = Report.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReportTableViewCell else {
            return UITableViewCell()
        }
        let report = fetchedResultsController.object(at: indexPath)
        cell.configureWith(report)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let report = fetchedResultsController.object(at: indexPath)
            context.delete(report)
            try? context.save()
        }
    }
}

extension ReportTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
