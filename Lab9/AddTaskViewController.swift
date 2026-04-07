//
//  AddTaskViewController.swift
//  Lab9
//
//  Created by steven coverdale on 2026-04-07.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!

    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    @IBAction func saveTaskTapped(_ sender: UIButton) {
        guard let text = taskTextField.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let task = Task(context: context)
        task.title = text

        do {
            try context.save()
            taskTextField.text = ""
        } catch {
            print("Failed to save task:", error)
        }
    }

    @IBAction func viewTasksTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showTasks", sender: nil)
    }
    
    private func editTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]

        let alert = UIAlertController(title: "Edit Task",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = task.title
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newText = alert.textFields?.first?.text,
                  !newText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

            task.title = newText
            do {
                try self.context.save()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to update task:", error)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

}
