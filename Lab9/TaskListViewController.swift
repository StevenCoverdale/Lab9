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

    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        tableView.dataSource = self
        tableView.delegate = self
        fetchTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
    }

    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching tasks:", error)
        }
    }

    func deleteTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        context.delete(task)

        do {
            try context.save()
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error deleting task:", error)
        }
    }

    func editTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]

        let alert = UIAlertController(title: "Edit Task",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.text = task.title
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let newText = alert.textFields?.first?.text,
                  !newText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

            task.title = newText

            do {
                try self.context.save()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                print("Error editing task:", error)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { _, _, done in
            self.deleteTask(at: indexPath)
            done(true)
        }

        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { _, _, done in
            self.editTask(at: indexPath)
            done(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
