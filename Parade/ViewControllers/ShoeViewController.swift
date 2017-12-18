//
//  ShoeViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ShoeViewController : UITableViewController {
    
    var shoe: Shoe.Model?

    override func viewDidLoad() {
        print("shoe")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (shoe?.viewSequence.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mv = shoe?.viewSequence[indexPath.row]
        if mv?.htmlType == "img" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoeImg", for: indexPath) as? ImageViewCell else {
                fatalError("The dequeued cell is not an instance of ShoeTableViewCell.")
            }
            cell.frame = CGRect(x: cell.bgImage.frame.origin.x,y: cell.bgImage.frame.origin.y,width: 400, height: 300);
            cell.bgImage.frame = CGRect(x: cell.bgImage.frame.origin.x,y: cell.bgImage.frame.origin.y,width: 400, height: 300);
            DispatchQueue.global(qos: .background).async {
                let image = UIImage(named: (mv?.content)!)
                DispatchQueue.main.async {
                    cell.bgImage.image = image
                }
            }
            

            return cell
        } else if mv?.htmlType == "h1" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoeTitle", for: indexPath) as? TitleViewCell else {
                fatalError("The dequeued cell is not an instance of ShoeTableViewCell.")
            }
            cell.titleLabel.text = mv?.content
            
            return cell
        } else if mv?.htmlType == "p" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoeBody", for: indexPath) as? BodyViewCell else {
                fatalError("The dequeued cell is not an instance of ShoeTableViewCell.")
            }
            cell.bodyLabel.text = mv?.content
            return cell
        } else {
            fatalError("HtmlType not recognized")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mv = shoe?.viewSequence[indexPath.row]
        if mv?.htmlType == "img" {
            return 200
        } else {
            return 50
        }
    }
}
