//
//  EditorViewController.swift
//  Canvasly
//
//  Created by Lorenzo Zanotto on 30/03/2016.
//  Copyright © 2016 Lorenzo Zanotto. All rights reserved.
//

import UIKit
import CoreData
import MarkdownTextView

class EditorViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    let contentField = MarkdownTextView(frame: CGRectZero)
    
    var draft: Draft!
    var firstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentField)
        configureMarkdown()
        setConstraints()
        
        if (draft != nil) {
            firstTime = false
            configureEditor()
        } else {
            firstTime = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveDraft()
    }
    
    func saveDraft() {
        
        if (firstTime && titleField.text != "") {
            saveForTheFirstTime()
        } else if (!firstTime && titleField.text != "") {
            updateCanvasEntry()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /// Configure the editor in case you're working on an already existing canvas
    func configureEditor() {
        self.titleField.text = draft.title
        self.contentField.text = draft.content
    }
    
    func setConstraints() {
        let views = ["textView": contentField, "titleView": titleField]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[titleView]-10-[textView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func configureMarkdown() {
        
        let attributes = MarkdownAttributes()
        let textStorage = MarkdownTextStorage(attributes: attributes)
        do {
            textStorage.addHighlighter(try LinkHighlighter())
        } catch let error {
            fatalError("Error initializing LinkHighlighter: \(error)")
        }
        textStorage.addHighlighter(MarkdownStrikethroughHighlighter())
        textStorage.addHighlighter(MarkdownSuperscriptHighlighter())
        if let codeBlockAttributes = attributes.codeBlockAttributes {
            textStorage.addHighlighter(MarkdownFencedCodeHighlighter(attributes: codeBlockAttributes))
        }
        
    }
    
    // MARK: - CoreData Management
    func updateCanvasEntry() {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            draft.title = self.titleField.text!
            draft.content = self.contentField.text
            
            do {
                try managedObjectContext.save()
        } catch {
                print(error)
            }
        }
        
    }
    
    /// Saves the canvas if it's the first time you're creating it
    func saveForTheFirstTime() {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            draft = NSEntityDescription.insertNewObjectForEntityForName("Draft", inManagedObjectContext: managedObjectContext) as! Draft
            draft.title = self.titleField.text!
            draft.content = self.contentField.text
            
            do {
                try managedObjectContext.save()
                print("Saved \(draft.title)")
                dismissViewControllerAnimated(true, completion: nil)
            } catch {
                print(error)
                return
            }
            
        }
    }

}











