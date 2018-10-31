//
//  ShoeTableView.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class ShoeTableViewController : UITableViewController {
    var jsonFile: String!
    
    lazy var shoe = { () -> Shoe in
        let data = try! Data(contentsOf: URL.urlFromCacheOrBundle(forResource: jsonFile, withExtension: "json")!)
        
        return try! JSONDecoder().decode(Shoe.self, from: data)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 200
        self.tableView.estimatedRowHeight = 200

        title = shoe.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoe.models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeIdentifier", for: indexPath) as? ShoeTableViewCell else {
            fatalError("The dequeued cell is not an instance of ShoeTableViewCell.")
        }

        Nuke.loadImage(with: URL.urlFromCacheOrBundle(forResource: self.shoe.models[indexPath.row].image, withExtension: ".jpg")!, into:  cell.shoeImageView)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShoeDetailSegue":
            let viewController = segue.destination as! ShoeViewController
            
            let selectedItemIndex = tableView.indexPathForSelectedRow!.row
            viewController.shoe = shoe.models[selectedItemIndex]
        default:
            break
        }
    }
}
