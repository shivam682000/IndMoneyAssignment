//
//  ViewController2.swift
//  TestConcurrency
//
//  Created by Shivam Kumar on 30/11/23.
//

import UIKit

class IntialViewController: UIViewController {

    @IBOutlet weak var tfRows: UITextField!
    @IBOutlet weak var tfColums: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func action(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "GridViewController") as? GridViewController {
            vc.rows = Int(tfRows.text ?? "3") ?? 3
            vc.column = Int(tfColums.text ?? "4") ?? 4
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
