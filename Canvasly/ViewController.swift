//
//  ViewController.swift
//  Canvasly
//
//  Created by Lorenzo Zanotto on 30/03/2016.
//  Copyright © 2016 Lorenzo Zanotto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var drafts = [Draft]()
    
    @IBOutlet weak var tableView: UITableView!
    var fetchResultController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDrafts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drafts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DraftCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DraftCell
        
        cell.titleLabel.text = drafts[indexPath.row].title
        cell.contentLabel.text = drafts[indexPath.row].content
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let canvasToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Draft
                managedObjectContext.deleteObject(canvasToDelete)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
                
            }
            
        }
        
        return [deleteAction]
        
    }
    
    // MARK: - Segues Configuration
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCanvas" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! EditorViewController
                destinationController.draft = drafts[indexPath.row]
            }
        }
     }
    
    // MARK: -  Core Data Management
    func retrieveDrafts() {
        
        let fetchRequest = NSFetchRequest(entityName: "Draft")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            // Retrieving the actual data
            do {
                try fetchResultController.performFetch()
                drafts = fetchResultController.fetchedObjects as! [Draft]
            } catch {
                print(error)
            }
        }
        
    }
    
    // MARK: - TableView Delegate Management
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation:
                    .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation:
                    .Fade)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        
        drafts = controller.fetchedObjects as! [Draft]
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}

