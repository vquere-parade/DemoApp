//
//  ShoeTableView.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ShoeTableViewController : UITableViewController {
    
    var shoes = [Shoe]()
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 200
        shoes.append(Shoe())
        shoes.append(Shoe())
        shoes.append(Shoe())
        shoes.append(Shoe())
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeIdentifier", for: indexPath) as? ShoeTableViewCell else {
            fatalError("The dequeued cell is not an instance of ShoeTableViewCell.")
        }
        cell.shoeImageView.image = UIImage(named: "sample")
        return cell
    }

}
