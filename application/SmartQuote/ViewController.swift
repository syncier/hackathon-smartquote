//
//  ViewController.swift
//  SmartQuote
//
//  Created by Alvary on 05.11.20.

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    
    @IBOutlet weak var StepsData: UILabel!
    @IBOutlet weak var StepsSwitch: UISwitch!
    @IBOutlet weak var StepsName: UILabel!
    
    
    
    
    
    var steps = -1.0
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.check_permissions()
        self.fill_UI()
    }
    
    //check permissions
    func check_permissions(){
        let shareTypes = Set<HKSampleType>()
        
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.workoutType())
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: .biologicalSex)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: .bloodType)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .stepCount)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .heartRate)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .walkingStepLength)!)
    
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes){ (success, error) -> Void in
            if success {
                print("success. got permissions")
                
            } else {
                print("failure. need permissions")
            }
            if let error = error { print(error) }
        }
    }
    
    func getSteps(){
        //print todays steps as example for activity accessibility
        let stepstype = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startofday = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startofday, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepstype, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                    guard let result = result, let sum = result.sumQuantity() else {
                        self.steps = -1.0
                        return
                    }
                    self.steps = sum.doubleValue(for: HKUnit.count())
               }
        
        healthStore.execute(query)
    }
    
    func getGender(){
        do{
            //print gender as example for specs accessibility
            let sex = try? healthStore.biologicalSex()
            if sex?.biologicalSex == HKBiologicalSex.male {
                self.gender = "male"
            }
            else if sex?.biologicalSex == HKBiologicalSex.female {
                self.gender = "female"
            }
            else{
                self.gender = ""
            }
        }
    }
    
    func fill_UI(){
        
        self.getSteps()
        self.getGender()
        
        print("steps: ", self.steps)
        print("gender: ", self.gender)
        
        if self.steps == -1 {
            self.StepsData.text = ""
            self.StepsName.textColor = UIColor.gray
            self.StepsSwitch.setOn(false, animated: false)
            self.StepsSwitch.isEnabled = false
        }
        else {
            self.StepsData.text = String(self.steps)
            self.StepsName.textColor = UIColor.black
            self.StepsSwitch.isEnabled = true
            self.StepsData.text = String(self.steps)
        }
        
        if 
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { self.fill_UI() })
    }
    
    func send_ticked(){
        //send
        //{"steps":{
        //  "perDay": 10
        //  "floors":
        //
        //
        //
        
        
    }

    
    
}

