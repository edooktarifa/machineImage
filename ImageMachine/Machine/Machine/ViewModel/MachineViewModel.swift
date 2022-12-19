//
//  MachineViewModel.swift
//  ImageMachine
//
//  Created by Phincon on 15/12/22.
//

import Foundation
import RxSwift
import RxCocoa

class MachineViewModel {
    
    var getListMachine: BehaviorRelay<[ImageMachineData?]> = BehaviorRelay(value: [])
    let machineTf = BehaviorRelay<String?>(value: "")
    let machineQRTf = BehaviorRelay<String?>(value: "")
    let machineTypeTf = BehaviorRelay<String?>(value: "")
    let filterMachine: BehaviorRelay<ImageMachineData?> = BehaviorRelay(value: nil)
    
    var listMachine: Driver<[ImageMachineData?]>{
        getListMachine.asDriver()
    }
    
    var isValidForm: Observable<Bool>{
        return Observable.combineLatest(machineTf, machineQRTf, machineTypeTf){
            machine, qr, type in
        
            guard machine != nil && qr != nil && type != nil else { return false }
            
            return !(machine!.isEmpty) && !(qr!.isEmpty) && !(type!.isEmpty)
        }
    }
    
    func numberOfRowMachine() -> Int {
        getListMachine.value.count
    }
    
    func fetchDataFromCoreData(){
        if let machine = CoreDataManager.sharedManager.fetchAllMachine(){
            getListMachine.accept(machine)
        }
    }
    
    func deleteMachine(id: String){
        _ = CoreDataManager.sharedManager.delete(id: id)
        fetchDataFromCoreData()
    }
    
    func updateMachine(name: String, id: String, machine: String, imageMachine: ImageMachineData){
        CoreDataManager.sharedManager.update(name: name, id: id, machine: machine, imageMachine: imageMachine)
    }
    
    func insertNewMachineImage(name: String, id: String, machine: String){
        _ = CoreDataManager.sharedManager.insertData(name: name , id:id ,machineNumber: machine)
    }
        
    func filterMachine(id: String) {
        _ = CoreDataManager.sharedManager.filterMachine(id: id)
        filterMachine.accept(CoreDataManager.sharedManager.filterMachine(id: id))
    }
}
