//
//  BaseFormMachineViewController.swift
//  ImageMachine
//
//  Created by Phincon on 16/12/22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum BaseTypeForm {
    case add, update
}

class BaseFormMachineViewController: UIViewController {
    
    lazy var machineNameLbl: UILabel = {
        let label = UILabel()
        label.text = "Machine Name"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var machineTypeLbl: UILabel = {
        let label = UILabel()
        label.text = "Machine Type"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var machineQRCodeNumberLbl: UILabel = {
        let label = UILabel()
        label.text = "Machine QR Number"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var machineNameTf: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .lightGray.withAlphaComponent(0.1)
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var machineTypeTf: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .lightGray.withAlphaComponent(0.1)
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var machineQRNumberCodeTf: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .lightGray.withAlphaComponent(0.1)
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var submitButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModelUpdateMachine = MachineViewModel()
    var baseTypeForm: BaseTypeForm = .add
    var imageMachineData: ImageMachineData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    func bindViewModel(){
        machineNameTf.rx.text.bind(to: viewModelUpdateMachine.machineTf).disposed(by: disposeBag)
        machineTypeTf.rx.text.bind(to: viewModelUpdateMachine.machineTypeTf).disposed(by: disposeBag)
        machineQRNumberCodeTf.rx.text.bind(to: viewModelUpdateMachine.machineQRTf).disposed(by: disposeBag)
        
        _ = viewModelUpdateMachine.isValidForm.asObservable().subscribe(onNext: {
            [weak self] enable in
            guard let self = self else { return }
            self.submitButton.isUserInteractionEnabled = enable
            enable == true ? self.enableBtn() : self.dissableBtn()
        }).disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe(onNext: {
            [weak self] in
            guard let self = self else { return }
            self.saveDataToDataBase()
        }).disposed(by: disposeBag)
        
        viewModelUpdateMachine.fetchDataFromCoreData()
    }
    
    func enableBtn(){
        submitButton.backgroundColor = .red
        submitButton.isUserInteractionEnabled = true
    }
    
    func dissableBtn(){
        submitButton.backgroundColor = .gray
        submitButton.isUserInteractionEnabled = false
    }
    
    func saveDataToDataBase(){
        switch baseTypeForm {
        case .add:
            insertNewMachine()
        case .update:
            updateMachine()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateMachine(){
        if checkDataAlreadyAddToDataBase(type: imageMachineData?.id ?? "") == true {
            if let `imageMachineData` = imageMachineData {
                viewModelUpdateMachine.updateMachine(name: machineNameTf.text!, id: machineQRNumberCodeTf.text!, machine: machineTypeTf.text!, imageMachine: `imageMachineData`)
            }
        } else {
            presentAlert(withTitle: "ERROR", message: "QR Number Already Add")
        }
        
    }
    
    func insertNewMachine(){
        if checkDataAlreadyAddToDataBase(type: machineQRNumberCodeTf.text!) == true {
            viewModelUpdateMachine.insertNewMachineImage(name: machineNameTf.text!, id: machineQRNumberCodeTf.text!, machine: machineTypeTf.text!)
        } else {
            presentAlert(withTitle: "ERROR", message: "QR Number Already Add")
        }
    }
    
    func checkDataAlreadyAddToDataBase(type: String) -> Bool{
        let checkId = CoreDataManager.sharedManager.filterMachine(id: type)
        
        switch baseTypeForm {
        case .add:
            return checkId?.id == type ? false : true
        case .update:
            return checkId?.id == type ? false : true
        }
    }
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupUI(){
        [machineNameLbl, machineTypeLbl, machineNameTf, machineTypeTf, machineQRCodeNumberLbl, machineQRNumberCodeTf, submitButton].forEach { views in
            view.addSubview(views)
        }
        
        machineNameLbl.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        machineNameTf.snp.remakeConstraints { make in
            make.top.equalTo(machineNameLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        machineTypeLbl.snp.remakeConstraints { make in
            make.top.equalTo(machineNameTf.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        machineTypeTf.snp.remakeConstraints { make in
            make.top.equalTo(machineTypeLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        machineQRCodeNumberLbl.snp.remakeConstraints { make in
            make.top.equalTo(machineTypeTf.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        machineQRNumberCodeTf.snp.remakeConstraints { make in
            make.top.equalTo(machineQRCodeNumberLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        submitButton.snp.remakeConstraints { make in
            make.top.equalTo(machineQRNumberCodeTf.snp.bottom).offset(20)
            make.centerX.equalTo(machineQRNumberCodeTf.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }
}
