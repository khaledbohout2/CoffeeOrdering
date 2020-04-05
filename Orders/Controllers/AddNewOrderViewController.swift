//
//  AddNewOrderViewController.swift
//  Orders
//
//  Created by Khaled Bohout on 3/29/20.
//  Copyright © 2020 khaled. All rights reserved.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(viewVontroller: UIViewController)
}

class AddNewOrderViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTxF: UITextField!
    @IBOutlet weak var emailTxF: UITextField!
    
    var delegate: AddCoffeeOrderDelegate?
    
    var coffeeSizesSegmentController : UISegmentedControl!
    
    var vm = AddOrderViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
    }
    
    private func setUpUi() {
        
        self.coffeeSizesSegmentController = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizesSegmentController.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.coffeeSizesSegmentController)
        
        self.coffeeSizesSegmentController.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentController.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddOrderTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.type[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func save() {
        let name = nameTxF.text
        let email = emailTxF.text
        let selectedSize = self.coffeeSizesSegmentController.titleForSegment(at: self.coffeeSizesSegmentController.selectedSegmentIndex)
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("error at selecting type")
        }
        let selectedType = self.vm.type[indexPath.row]
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = selectedType
        
        Webservices().load(resource: Order.create(vm: self.vm)) { (result) in
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func close() {
        
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(viewVontroller: self)
        }
        }
}
