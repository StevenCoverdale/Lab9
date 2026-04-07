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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Task"
    }

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
}
