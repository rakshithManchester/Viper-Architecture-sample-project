//
//  HomeViewController.swift
//  LoginRegisterTodoList
//
//  Created by Appaiah on 25/04/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var dataList : [TodoList] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTable")
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchTodoList()
    }
    
    func fetchTodoList() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        do {
            let list = try context.fetch(fetchReq)
            let results = list as! [TodoList]
            self.dataList = results
            tableView.reloadData()
        } catch let exp {
            print(exp)
        }
    }
    
    func insertIntoTodoList(text: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTodo = TodoList(context: context)
        newTodo.title = text
        newTodo.date = Date()
        do {
            try context.save()
        } catch let exp {
            print(exp)
        }
    }
    
    @IBAction func addItem(sender: UIButton) {
        let alert = UIAlertController(title: "Add To Do Task", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "To Do"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textdField = alert?.textFields?[0]
            self.insertIntoTodoList(text: (textdField?.text)!)
            self.fetchTodoList()
        }))
        self.present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTable", for: indexPath) as! HomeTableViewCell
        cell.titleLabel.text = dataList[indexPath.row].title
        cell.dateLabel.text = dataList[indexPath.row].date?.description
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
