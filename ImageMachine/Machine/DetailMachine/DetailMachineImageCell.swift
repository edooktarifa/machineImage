//
//  DetailMachineImageCell.swift
//  ImageMachine
//
//  Created by Phincon on 16/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class DetailMachineImageCell: UITableViewCell, ReusableViewCell {

    lazy var detailImage: UIImageView = {
        let images = UIImageView()
        return images
    }()
    
    lazy var zoomImage: UIButton = {
        let button = UIButton()
        button.setTitle("zoom image", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    lazy var deleteImage: UIButton = {
        let button = UIButton()
        button.setTitle("delete image", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    var listImage: ListImage?{
        didSet {
            if let `listImage` = listImage?.images {
                detailImage.image = UIImage(data: `listImage`)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI(){
        [detailImage, zoomImage, deleteImage].forEach { views in
            contentView.addSubview(views)
        }
        
        detailImage.snp.remakeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        zoomImage.snp.remakeConstraints { make in
            make.top.equalTo(detailImage.snp.bottom).offset(10)
            make.centerX.equalTo(detailImage.snp.centerX)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        
        deleteImage.snp.remakeConstraints { make in
            make.top.equalTo(zoomImage.snp.bottom).offset(10)
            make.centerX.equalTo(zoomImage.snp.centerX)
            make.height.equalTo(30)
            make.width.equalTo(150)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }

}
