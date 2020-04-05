//
//  OrdersTableViewControllers.swift
//  Orders
//
//  Created by Khaled Bohout on 3/29/20.
//  Copyright © 2020 khaled. All rights reserved.
//

import Foundation
import UIKit

class OrdersTableViewController : UITableViewController {

    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
        
        Webservices().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders) :
                print(orders)
                self?.orderListViewModel.orderListViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addCoffeeOrderVC = navC.viewControllers.first as? AddNewOrderViewController else {
            fatalError("Error Performin Segue!")
        }
        
        addCoffeeOrderVC.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.orderListViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return  cell
    }
    
    
}

extension OrdersTableViewController : AddCoffeeOrderDelegate {
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.orderListViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderListViewModel.count, section: 0)], with: .automatic)

    }
    
    func addCoffeeOrderViewControllerDidClose(viewVontroller: UIViewController) {
        viewVontroller.dismiss(animated: true, completion: nil)
    }

}
