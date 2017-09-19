//
//  MasterViewController.swift
//  TodoDemo
//
//  Created by Chandrakala Neerukonda on 9/18/17.
//  Copyright © 2017 Chandrakala Neerukonda. All rights reserved.
//

import UIKit

enum Segues {
    static let showDetail = "showDetail"
    static let exitFromNewTask = "ExitFromNewTask"
}

class MasterViewController: UITableViewController, ErrorDisplay {
    
    enum Constants {
        enum Strings {
            static let actionSheetTitle = NSLocalizedString("Sort Options", tableName: "task", comment: "Sort options title")
            static let latest = NSLocalizedString("Latest", tableName: "task", comment: "Latest options title")
            static let hightToLow = NSLocalizedString("High to low priority", tableName: "task", comment: "High to low priority option title")
            static let lowToHigh = NSLocalizedString("Low to high priority", tableName: "task", comment: "Low to high priority option title")
            static let removeSort = NSLocalizedString("Remove Sort", tableName: "task", comment: "Remove Sort option title")
            static let cancel = NSLocalizedString("Cancel", tableName: "task", comment: "Cancel option title")
        }
        
        static let checked = "checked"
    }
    
    var detailViewController: TaskViewController? = nil
    lazy var taskManager = type.dataManager()
    var tasks: [Task]!
    private var selected: SortOptions = .none
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        tasks = taskManager.tasks()
        configureSearchController()
        guard let split = splitViewController else { return }
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? TaskViewController
        
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            segue.identifier == Segues.showDetail  else { return }
        let object = tasks[indexPath.row]
        let controller = (segue.destination as! UINavigationController).topViewController as! TaskViewController
        controller.state = .view(object)
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == Segues.exitFromNewTask else {
            return
        }
        tasks = taskManager.tasks()
        tableView.reloadData()
    }
    
    @IBAction func tappedSort() {
        let alert = UIAlertController(title: Constants.Strings.actionSheetTitle, message: "", preferredStyle: .actionSheet)
        let date = UIAlertAction(title: Constants.Strings.latest, style: .default) { [weak self] action in
            self?.sortTask(with: .creadtedDate)
        }
        let highToLow = UIAlertAction(title: Constants.Strings.hightToLow, style: .default) { [weak self] action in
            self?.sortTask(with: .hightoLowPriority)
        }
        let lowToHigh = UIAlertAction(title: Constants.Strings.lowToHigh, style: .default) { [weak self] action in
            self?.sortTask(with: .lowtoHignPriority)
        }
        let cancel = UIAlertAction(title: Constants.Strings.cancel, style: .cancel, handler: nil)
        let clearSort = UIAlertAction(title: Constants.Strings.removeSort, style: .destructive) { [weak self] action in
            self?.sortTask(with: .none)
        }
        alert.addAction(date)
        alert.addAction(highToLow)
        alert.addAction(lowToHigh)
        alert.addAction(clearSort)
        alert.addAction(cancel)
        alert.actions.forEach { action in
            action.setValue("false", forKey: Constants.checked)
        }
        if .none != selected {
            alert.actions[selected.rawValue].setValue("true", forKey: Constants.checked)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func sortTask(with option: SortOptions) {
        selected = option
        taskManager.sort(option)
        tasks = taskManager.tasks()
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel!.text = task.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try taskManager.delete(tasks[indexPath.row])
                tasks = taskManager.tasks()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            catch let error {
                display(error)
            }
        }
    }
    
    
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        taskManager.filter(name: searchText)
        tasks = taskManager.tasks()
        tableView.reloadData()
    }
}

