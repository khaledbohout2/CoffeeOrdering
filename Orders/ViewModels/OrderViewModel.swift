//
//  OrderViewModel.swift
//  Orders
//
//  Created by Khaled Bohout on 3/31/20.
//  Copyright © 2020 khaled. All rights reserved.
//

import Foundation

struct OrderListViewModel {
    var orderListViewModel: [OrderViewModel]
}

extension OrderListViewModel {
    init() {
        self.orderListViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.orderListViewModel[index]
    }
}

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    
    var name: String {
        return self.order.name
    }
    
    var email: String {
        return self.order.email
    }
    
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}
