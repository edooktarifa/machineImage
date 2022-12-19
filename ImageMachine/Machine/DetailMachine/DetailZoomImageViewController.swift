//
//  DetailZoomImageViewController.swift
//  ImageMachine
//
//  Created by Phincon on 16/12/22.
//

import UIKit
import SnapKit
import RxSwift

class DetailZoomImageViewController: UIViewController {

    lazy var images : UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let image = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.blue
        
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    var getImage = Data()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        [images, closeBtn].forEach { views in
            view.addSubview(views)
        }
        
        images.snp.remakeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        closeBtn.snp.remakeConstraints { make in
            make.top.equalTo(images.snp.top).offset(20)
            make.trailing.equalTo(images.snp.trailing).offset(-20)
            make.height.width.equalTo(30)
        }
        
        images.image = UIImage(data: getImage)
        
        closeBtn.rx.tap.subscribe(onNext: {
            [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    

}
