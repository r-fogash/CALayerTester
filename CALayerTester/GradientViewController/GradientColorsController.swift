//
//  GradientColorsController.swift
//  CALayerTester
//
//  Created by Robert on 26.04.2023.
//

import UIKit
import Combine

class GradientColorsController: UIViewController, GradientSettingsContainer {

    enum ColorItem {
        case add
        case item(color: GradientSettings.ColorRecord)
    }
    
    var settings: GradientSettings!
    var colors = [ColorItem]()
    var bag = Set<AnyCancellable>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.$colors.sink { [unowned self] colorRecords in
            colors.removeAll()
            for color in colorRecords {
                colors.append(.item(color: color))
            }
            colors.append(.add)
        }.store(in: &bag)
        
    }
    
    func deleteItem(at indexPath: IndexPath) {
        settings.deleteColor(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func editItem(at indexPath: IndexPath) {
        print("edit item at \(indexPath)")
    }
}

// MARK: UITableViewDataSource

extension GradientColorsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch colors[indexPath.row] {
        case .item(let color):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorRecordTableViewCell", for: indexPath) as! ColorRecordTableViewCell
            cell.fill(color)
            cell.settings = settings
            return cell
        case.add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddColorTableViewCell", for: indexPath) as! AddColorTableViewCell
            return cell
        }
        
    }
    
}

// MARK: UITableViewDelegate

extension GradientColorsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < colors.count - 1 else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [unowned self] performed, _, _  in
            deleteItem(at: indexPath)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] action, view, _ in
            editItem(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == colors.count - 1 {
            let alert = UIAlertController(title: "Add color", message: "Add color hex value", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "color hex"
            }
            let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self, unowned alert] action in
                addColor(hex: alert.textFields!.first!.text!)
            }
            
            alert.addAction(addAction)
            alert.addAction(.init(title: "Cancel", style: .destructive))
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        indexPath.row == colors.count - 1
    }
    
    func addColor(hex: String) {
        if let color = UIColor(hex: hex) {
            settings.addColor(color)
            tableView.reloadData()
        }
    }
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        var start = hex.index(hex.startIndex, offsetBy: 0)
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
        }
         
        let hexColor = String(hex[start...])

        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }

        return nil
    }
}
