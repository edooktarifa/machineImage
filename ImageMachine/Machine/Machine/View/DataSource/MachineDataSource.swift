//
//  MachineDataSource.swift
//  ImageMachine
//
//  Created by Phincon on 18/12/22.
//

import Foundation
import UIKit
import RxSwift

class MachineDataSource: NSObject {
    weak var viewModel: MachineViewModel?
    var view: MachineDataViewController?
    var tableView: UITableView?
    let disposeBag = DisposeBag()
    
    init(viewModel: MachineViewModel? = nil, view: MachineDataViewController? = nil, tableView: UITableView? = nil){
        super.init()
        self.viewModel = viewModel
        self.view = view
        self.tableView = tableView
        self.bindView()
    }
    
    func bindView(){
        viewModel?.listMachine.drive(onNext: {
            [weak self] _ in
            guard let `self` = self else { return }
            self.tableView?.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension MachineDataSource: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cell: MachineCell.self)
        if let data = viewModel?.getListMachine.value[indexPath.row]{
            cell.setContent(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowMachine() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let machine = viewModel?.getListMachine.value[indexPath.row] else { return }
        switch editingStyle {
        case .delete:
            viewModel?.deleteMachine(id: machine.id ?? "")
        case .none:
            moveToUpdateMachineImage(imageMachineData: machine)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.tableView?.dataSource?.tableView!(self.tableView ?? UITableView(), commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor.black
        
        let editButton = UITableViewRowAction(style: .default, title: "Update") { (action, indexPath) in
            self.tableView?.dataSource?.tableView!(self.tableView ?? UITableView(), commit: .none, forRowAt: indexPath)
            return
        }
        editButton.backgroundColor = UIColor.orange
        return [deleteButton, editButton]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailMachineViewController()
        vc.machineImage = viewModel?.getListMachine.value[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToUpdateMachineImage(imageMachineData: ImageMachineData){
        let vc = UpdateMachineViewController()
        vc.imageMachineData = imageMachineData
        vc.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
