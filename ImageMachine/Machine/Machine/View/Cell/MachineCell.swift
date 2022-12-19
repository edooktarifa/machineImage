//
//  MachineCell.swift
//  ImageMachine
//
//  Created by Phincon on 15/12/22.
//

import UIKit

class MachineCell: UITableViewCell, ReusableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var typeMachine: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .black
        return label
    }()
    
    lazy var qrNumberMachine: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .red
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI(){
        [titleLabel, typeMachine, qrNumberMachine].forEach { views in
            contentView.addSubview(views)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(20)
            make.top.equalTo(10)
        }
        
        typeMachine.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        qrNumberMachine.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(20)
            make.top.equalTo(typeMachine.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    func setContent(data: ImageMachineData?){
        titleLabel.text = "Machine Name: \(data?.name ?? "")"
        typeMachine.text = "Machine Type: \(data?.machine ?? "")"
        qrNumberMachine.text = "QR Number: \(data?.id ?? "")"
    }
}
