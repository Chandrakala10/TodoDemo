//
//  TaskViewController.swift
//  TodoDemo
//
//  Created by Chandrakala Neerukonda on 9/18/17.
//  Copyright © 2017 Chandrakala Neerukonda. All rights reserved.
//
import UIKit

class TaskViewController: UIViewController, ErrorDisplay {
    
    enum State {
        case new
        case view(Task)
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var priority: UISegmentedControl!
    @IBOutlet weak var save: UIBarButtonItem!
    private var task: Task!
    override var isEditing: Bool {
        didSet {
            notes.isUserInteractionEnabled = isEditing
            priority.isUserInteractionEnabled = isEditing
            notes.borderStyle = isEditing == true ? .roundedRect :.none
        }
    }
    var state = State.new{
        didSet {
            if case let .view(task) = state {
                self.task = task
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard case .view = state else { return }
        configureView()
        isEditing = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(tapOnEdit)
        name.text = task.name
        notes.text = task.notes
        priority.selectedSegmentIndex = task.priority.rawValue
        name.isUserInteractionEnabled = false
        name.borderStyle = .none
    }
    
    func tapOnEdit() {
        defer {
            isEditing = !isEditing
        }
        guard case .view(let old) = state, isEditing else { return }
        let task = Task(name: name.text!, notes: notes.text ?? "", priority: Priority(rawValue: priority.selectedSegmentIndex)!)
        do {
            try type.dataManager().update(old: old, withNew: task)
        }
        catch let error {
            display(error)
        }
    }
    
    @IBAction func tapOnSave() {
        let task = Task(name: name.text!, notes: notes.text ?? "", priority: Priority(rawValue: priority.selectedSegmentIndex)!)
        do {
            try type.dataManager().add(task)
            performSegue(withIdentifier: "ExitFromNewTask", sender: nil)
        }
        catch let error {
            display(error)
        }
    }
    
    @IBAction func texfieldEditted(_ sender: Any) {
        save.isEnabled = true
    }
    
}
