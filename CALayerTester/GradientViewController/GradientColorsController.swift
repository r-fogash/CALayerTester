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
            tableView.reloadData()
        }.store(in: &bag)
        
    }
    
    func deleteItem(at indexPath: IndexPath) {
        settings.deleteColor(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func addColor(_ color: UIColor) {
        settings.addColor(color)
    }
    
    func presentColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Gradient colort"
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        
        self.present(colorPicker, animated: true)
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
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == colors.count - 1 {
            presentColorPicker()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        indexPath.row == colors.count - 1
    }
    
}

// MARK: UIColorPickerViewControllerDelegate

extension GradientColorsController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        addColor(viewController.selectedColor)
    }
    
}
