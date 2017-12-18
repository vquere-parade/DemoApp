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
    var selectedShoe: Shoe?
    var jsonFile: String?
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 200
        print("jsonFile: "+jsonFile!)
        
        //
        
        let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ultrices odio cursus felis ullamcorper, in semper arcu congue. In ornare diam vitae nulla dignissim, ac porttitor dolor consectetur. Curabitur dapibus placerat eros, et sodales lectus efficitur at. Vestibulum malesuada, mauris a convallis volutpat, urna lectus laoreet arcu, vitae dictum elit eros vitae mauris. Maecenas vitae enim quam. Phasellus aliquam dolor dolor. Quisque vel feugiat metus, sit amet posuere mauris. Etiam bibendum porttitor enim non porttitor. Praesent sit amet ultricies metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ultrices odio cursus felis ullamcorper, in semper arcu congue. In ornare diam vitae nulla dignissim, ac porttitor dolor consectetur. Curabitur dapibus placerat eros, et sodales lectus efficitur at. Vestibulum malesuada, mauris a convallis volutpat, urna lectus laoreet arcu, vitae dictum elit eros vitae mauris. Maecenas vitae enim quam. Phasellus aliquam dolor dolor. Quisque vel feugiat metus, sit amet posuere mauris. Etiam bibendum porttitor enim non porttitor. Praesent sit amet ultricies metus."
        
        if let _jsonFile = jsonFile {
            print("_jsonFile ok: "+_jsonFile)
            if let filePath = Bundle.main.path(forResource: _jsonFile, ofType:"json") {
                print("filePath ok")
                let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: filePath)), options: [])
                guard let jsonContent = json as? [String: Any] else {
                    fatalError("JSON error")
                }
                print("jsonContent ok")
                self.title = jsonContent["title"] as! String
                
            }

            //
            /*
            if sc == "Evone" {
                self.shoes.append(Shoe(name: "test", image: "1", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "2", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "3", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "4", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "5", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "6", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "7", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "8", description: loremIpsum))
            } else if sc == "Evan" {
                self.shoes.append(Shoe(name: "test", image: "9", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "10", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "11", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "12", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "13", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "14", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "15", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "16", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "17", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "18", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "19", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "20", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "21", description: loremIpsum))
            } else if sc == "Izome" {
                self.shoes.append(Shoe(name: "test", image: "DSC_9396", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9397", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9398", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9399", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9400", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9401", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9402", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9403", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9405", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9406", description: loremIpsum))
                
                self.shoes.append(Shoe(name: "test", image: "DSC_9409", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9410", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9411", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9412", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9413", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9414", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9415", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9416", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9417", description: loremIpsum))
                self.shoes.append(Shoe(name: "test", image: "DSC_9418", description: loremIpsum))
                
            } else {
                
            }
            */
        }
        
        
        
        
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
        DispatchQueue.global(qos: .background).async {
            let image = UIImage(named: self.shoes[indexPath.row].image)
            DispatchQueue.main.async {
                cell.shoeImageView.image = image
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShoe = shoes[indexPath.row]
        performSegue(withIdentifier: "showShoeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShoeSegue" {
            if let toViewController = segue.destination as? ShoeViewController {
                toViewController.shoe = selectedShoe
            }
        }
    }
 
}
