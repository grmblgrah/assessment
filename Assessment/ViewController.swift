//
//  ViewController.swift
//  Assessment
//
//  Created by Nils Podewski on 21.10.21.
//

import UIKit

struct Item {
    let title: String
    let subtitle: String?
    let picture: URL?
    let value: CGFloat
    
    static func fromJson(json: [String: Any?]) -> Item? {
        let title = json["title"] as! String
        let subtitle = json["subtitle"] as? String
        let value = json["value"] as! CGFloat ?? 0
        let picture = json["picture"] as! URL

        let i = Item(title: title, subtitle: subtitle, picture: picture, value: value)

        // validation
        if value < -100 { return nil }
        return i
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var items = [Item?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any?]]
                
                
                for obj in jsonObj! {
                    let item = Item.fromJson(json: obj)
                    items.append(item)
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        }
        
        view.addSubview(tableView)
    }

    override func viewWillLayoutSubviews() {
        tableView.frame = view.frame
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = items[indexPath.row]?.title
        cell.detailTextLabel!.text = "\(items[indexPath.row]?.subtitle) \(items[indexPath.row]?.value)"
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
}

