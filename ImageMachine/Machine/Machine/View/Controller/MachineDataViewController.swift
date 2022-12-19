//
//  ViewController.swift
//  ImageMachine
//
//  Created by Phincon on 14/12/22.
//

import UIKit
import SnapKit

class MachineDataViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(cell: MachineCell.self)
        return table
    }()
    
    private var viewModel = MachineViewModel()
    private var dataSource: MachineDataSource = MachineDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Image Machine"
        configTable()
        createNavigationButton()
    }
    
    func configTable(){
        view.addSubview(tableView)
        
        tableView.snp.remakeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        dataSource = MachineDataSource(viewModel: viewModel, view: self, tableView: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchDataFromCoreData()
    }
    
    func createNavigationButton(){
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMachine))
        navigationItem.rightBarButtonItem = add
    }
    
    @objc func addMachine(){
        let vc = AddMachineDataViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

