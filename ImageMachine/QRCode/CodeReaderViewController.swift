//
//  CodeReaderViewController.swift
//  ImageMachine
//
//  Created by Phincon on 14/12/22.
//

import UIKit
import DKImagePickerController
import RxSwift
import RxCocoa
import SnapKit

class CodeReaderViewController: UIViewController {
    
    lazy var scannerView: QRScannerView = {
        let scanner = QRScannerView()
        return scanner
    }()
    
    lazy var scanButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    var viewModel = MachineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "QR Reader"
        setupView()
        
        scannerView.delegate = self
        scanButton.rx.tap.subscribe(onNext: {
            [weak self] in
            guard let self = self else { return }
            self.moveToScanView()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scannerView.startScanning()
        scanButton.setTitle("STOP", for: .normal)
    }
    
    func setupView(){
        [scannerView, scanButton].forEach { views in
            view.addSubview(views)
        }
        
        scannerView.snp.remakeConstraints { make in
            make.height.equalTo(view.frame.height / 2)
            make.width.equalTo(view.snp.width)
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        scanButton.snp.remakeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.centerX.equalTo(scannerView.snp.centerX)
            make.top.equalTo(scannerView.snp.bottom).offset(15)
        }
    }
    
    func moveToScanView(){
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        scanButton.setTitle(buttonTitle, for: .normal)
    }
}

extension CodeReaderViewController: QRScannerViewDelegate {
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        guard let `str` = str else { return }
        viewModel.filterMachine(id: str)
        
        if viewModel.filterMachine.value?.id != str {
            presentAlert(withTitle: "ERROR", message: "QR number not found")
        } else {
            if let filter = viewModel.filterMachine.value {
                moveToDetailViewController(data: filter)
            }
        }
    }
    
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.scannerView.startScanning()
            self.qrScanningDidStop()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func moveToDetailViewController(data: ImageMachineData){
        let vc = DetailMachineViewController()
        vc.machineImage = data
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
