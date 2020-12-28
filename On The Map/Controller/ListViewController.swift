//
//  ListViewController.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import UIKit

class ListViewController: UIViewController {

    var listOfStudentInfo = [StudentLocationData]()

    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        getStudentInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getStudentInfo() {
        UdacityAPI.getStudentLocationUsingUrl() {(returnedStudentList, error) in
            self.listOfStudentInfo = returnedStudentList ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func logoutAction(_ sender: Any) {
        UdacityAPI.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func addNewLocationAction(_ sender: Any) {
    }

    @IBAction func refreshAction(_ sender: Any) {
        getStudentInfo()
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count: " + String(self.listOfStudentInfo.count))
        return self.listOfStudentInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! CustomCell
        let singleStudent = self.listOfStudentInfo[indexPath.row]
        cell.cellTitleLabel.text = singleStudent.firstName + " " + singleStudent.lastName
        cell.cellDetailLabel.text = singleStudent.mediaURL
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleStudent = self.listOfStudentInfo[indexPath.row]
        guard let url = URL(string: singleStudent.mediaURL ?? ""), UIApplication.shared.canOpenURL(url) else {
            let alertVC = UIAlertController(title: "Bad URL", message: "Unable to open URL", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true)
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDetailLabel: UILabel!
}
