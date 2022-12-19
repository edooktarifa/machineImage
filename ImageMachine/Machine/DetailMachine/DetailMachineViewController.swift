//
//  DetailMachineViewController.swift
//  ImageMachine
//
//  Created by Phincon on 16/12/22.
//

import UIKit
import RxCocoa
import RxSwift
import DKImagePickerController
import DKPhotoGallery

class DetailMachineViewController: UIViewController {
    
    lazy var machineNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var machineTypeLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var machineQRCodeNumberLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(cell: DetailMachineImageCell.self)
        return table
    }()
    
    lazy var addImageBtn : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Add Image", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .blue.withAlphaComponent(0.7)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    var machineImage: ImageMachineData?
    var listImages = [ListImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Detail"
        machineNameLbl.text = "Machine Name: \(machineImage?.name ?? "")"
        machineTypeLbl.text = "Machine Type: \(machineImage?.id ?? "")"
        machineQRCodeNumberLbl.text = "Machine QR Number: \(machineImage?.machine ?? "")"
        setUpUI()
        addImageBtn.rx.tap.subscribe(onNext: {
            [weak self] in
            guard let self = self else { return }
            self.openGallery()
        }).disposed(by: disposeBag)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        if let `machineImage` = machineImage {
            listImages = CoreDataManager.sharedManager.listImage(images: `machineImage`)
            tableView.reloadData()
        }
    }
    
    func openGallery(){
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 10
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage() { (image, info) in
                    if let `machineImage` = self.machineImage, let `image` = image {
                        _ = CoreDataManager.sharedManager.addImageToMachine(imageMachine: `machineImage`, image: `image`)
                        self.fetchData()
                    }
                }
            }
        }
        
        self.present(pickerController, animated: true)
    }
    
    func setUpUI(){
        [machineNameLbl, machineTypeLbl, machineQRCodeNumberLbl, tableView, addImageBtn].forEach { views in
            view.addSubview(views)
        }
        
        machineNameLbl.snp.remakeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        machineTypeLbl.snp.remakeConstraints { make in
            make.top.equalTo(machineNameLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        machineQRCodeNumberLbl.snp.remakeConstraints { make in
            make.top.equalTo(machineTypeLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        addImageBtn.snp.remakeConstraints { make in
            make.top.equalTo(machineQRCodeNumberLbl.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.centerX.equalTo(machineQRCodeNumberLbl.snp.centerX)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(addImageBtn.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(0)
        }
    }
}

extension DetailMachineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cell: DetailMachineImageCell.self)
        cell.deleteImage.tag = indexPath.row
        cell.zoomImage.tag = indexPath.row
        let images = listImages[indexPath.row]
        cell.listImage = images
        cell.deleteImage.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
        cell.zoomImage.addTarget(self, action: #selector(zoomImages(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteImages(sender: UIButton){
        let deleteImage = listImages[sender.tag]
        CoreDataManager.sharedManager.removeImageFromMachine(imageMachine: deleteImage) { status in
            if status == true {
                self.fetchData()
            }
        }
    }
    
    @objc func zoomImages(sender: UIButton){
        guard let zoomImage = listImages[sender.tag].images else { return }
        let vc = DetailZoomImageViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.getImage = zoomImage
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}
