//
//  ChangeHOST.swift
//  QrScanner
//
//  Created by Alexey Borisov on 26.11.2022.
//

import Foundation
import UIKit

class ChangeHOST: UIViewController {
    
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var hostTextField: UITextField!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController

        newViewController.host = host

        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    var host: String = "10.131.57.46"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.106, green: 0.46, blue: 1, alpha: 1)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        hostTextField.delegate = self
        hostLabel.text = "Host: http://10.131.57.46:3000/mark"
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
}
extension ChangeHOST: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        host = textField.text ?? ""
        hostLabel.text = "Host: \(host)"
        return true
    }
}
