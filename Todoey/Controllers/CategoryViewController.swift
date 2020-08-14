import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var categories: Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        loadCategories()
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No categories yet"
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do{
            try realm.write(){
                realm.add(category)
            }
        }catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text != ""){
                let newCategory = Category()
                newCategory.name = textField.text!
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
}
