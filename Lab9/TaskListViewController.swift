//
//  TaskListViewController.swift
//  Lab9
//
//  Created by steven coverdale on 2026-04-07.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
    }

    private func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch tasks:", error)
        }
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell",
                                                 for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
}
