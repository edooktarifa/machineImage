//
//  UpdateMachineViewController.swift
//  ImageMachine
//
//  Created by Phincon on 16/12/22.
//

import UIKit
import SnapKit

class UpdateMachineViewController: BaseFormMachineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.baseTypeForm = .update
        title = "Update"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
