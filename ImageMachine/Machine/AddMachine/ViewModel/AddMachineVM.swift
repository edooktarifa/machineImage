//
//  AddMachineVM.swift
//  ImageMachine
//
//  Created by Phincon on 15/12/22.
//

import Foundation
import RxCocoa
import RxSwift

class AddMachineVM {
    let machineTf = BehaviorRelay<String?>(value: "")
    let machineQRTf = BehaviorRelay<String?>(value: "")
    let machineTypeTf = BehaviorRelay<String?>(value: "")
    
    var isValidForm: Observable<Bool>{
        return Observable.combineLatest(machineTf, machineQRTf, machineTypeTf){
            machine, qr, type in
        
            guard machine != nil && qr != nil && type != nil else { return false }
            
            return !(machine!.isEmpty) && !(qr!.isEmpty) && !(type!.isEmpty)
        }
    }
}
