//
//  ViewController.swift
//  SmartQuote
//
//  Created by Alvary on 05.11.20.

import UIKit
import HealthKit


class ViewController: UIViewController {

    let healthStore = HKHealthStore()
    @IBOutlet weak var birthDateLabel: UILabel!
    
    @IBOutlet weak var birthDateSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var genderName: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var stairSpeedLabel: UILabel!
    @IBOutlet weak var birthDateName: UILabel!
    @IBOutlet weak var stairSpeedSwitch: UISwitch!
    @IBOutlet weak var stairSpeedName: UILabel!
    @IBOutlet weak var stepLengthName: UILabel!
    @IBOutlet weak var stepCountName: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    
    @IBOutlet weak var stepLengthLabel: UILabel!
    @IBOutlet weak var stepLengthSwitch: UISwitch!
    @IBOutlet weak var stepCountSwitch: UISwitch!
    @IBOutlet weak var walkingSpeedName: UILabel!
    @IBOutlet weak var bloodPressureSwitch: UISwitch!
    
    @IBOutlet weak var walkingSpeedLabel: UILabel!
    @IBOutlet weak var walkingSpeedSwitch: UISwitch!
    @IBOutlet weak var heartRateName: UILabel!
    @IBOutlet weak var heartRateSwitch: UISwitch!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var bloodPressureName: UILabel!
    @IBOutlet weak var bloodPressureLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var bloodTypeName: UILabel!
    
    @IBOutlet weak var bloodTypeSwitch: UISwitch!
    
    
    
    var steps = -1.0
    var gender = ""
    var birthDate = ""
    var stairSpeed = -1.0
    var stepLength = -1.0
    var walkingSpeed = -1.0
    var heartRate = -1.0
    var bloodPressure = ""
    var bloodType = ""
    var stop = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.submitButton.layer.cornerRadius = 10
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.white.cgColor
        let col = UIColor(red: (86/255), green: (187/255), blue: (144/255), alpha:1.0)
        self.submitButton.layer.backgroundColor = col.cgColor
        self.birthDateSwitch.onTintColor = col
        self.genderSwitch.onTintColor = col
        self.stairSpeedSwitch.onTintColor = col
        self.stepCountSwitch.onTintColor = col
        self.stepLengthSwitch.onTintColor = col
        self.walkingSpeedSwitch.onTintColor = col
        self.heartRateSwitch.onTintColor = col
        self.bloodPressureSwitch.onTintColor = col
        self.bloodTypeSwitch.onTintColor = col
        
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
        readTypes.insert(HKObjectType.quantityType(forIdentifier: .walkingSpeed)!)
    
        
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
        let now = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
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
    
    func getStairSpeed(){
        self.stairSpeed = 2.8
    }
    
    func getStepLength(){
        self.stepLength = 39.0
    }
    
    func getWalkingSpeed(){
        self.walkingSpeed = 5.0
    }
    
    func getHeartRate(){
        self.heartRate = 65.0
    }
    
    func getBloodPressure(){
        guard let type = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure),
           let systolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic),
           let diastolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic) else {

               return
       }

       let sampleQuery = HKSampleQuery(sampleType: type, predicate: nil, limit: 0, sortDescriptors: nil) { (sampleQuery, results, error) in
           if let dataList = results as? [HKCorrelation] {
               for data in dataList
               {
                   if let data1 = data.objects(for: systolicType).first as? HKQuantitySample,
                       let data2 = data.objects(for: diastolicType).first as? HKQuantitySample {

                       let value1 = data1.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
                       let value2 = data2.quantity.doubleValue(for: HKUnit.millimeterOfMercury())

                    self.bloodPressure = String(value1)+"/"+String(value2)
                        
                   }
                   else {
                        self.bloodPressure = ""
                   }
               }
           }
       }
       healthStore.execute(sampleQuery)
    }
    
    func getBloodType(){
        do{
            //print gender as example for specs accessibility
            let bType = try? healthStore.bloodType()
            switch bType?.bloodType {
                    case .abNegative:
                        self.bloodType = "AB-"
                    case .abPositive:
                        self.bloodType = "AB+"
                    case .aNegative:
                        self.bloodType =  "A-"
                    case .aPositive:
                        self.bloodType =  "A+"
                    case .bNegative:
                        self.bloodType =  "B-"
                    case .bPositive:
                        self.bloodType =  "B+"
                    case .oNegative:
                        self.bloodType =  "O-"
                    case .oPositive:
                        self.bloodType =  "O+"
                    default:
                        self.bloodType =  ""
                    }
        }
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
    
    func getBirthDate(){
//        do{
//            let datebuff = try? healthStore.dateOfBirthComponents().date
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd.MM.yyyy"
//
//            self.birthDate = formatter.string(from: datebuff!)
//        }
        self.birthDate = "27.04.1998"
    }
    
    
    
    
    func fill_UI(){
        if self.stop == false {
            self.getSteps()
            self.getGender()
            self.getBirthDate()
            self.getStairSpeed()
            self.getStepLength()
            self.getWalkingSpeed()
            self.getHeartRate()
            self.getBloodPressure()
            self.getBloodType()
        
            print("steps: ", self.steps)
            print("gender: ", self.gender)
            
            if self.steps == -1 {
                self.stepCountLabel.text = ""
                self.stepCountLabel.textColor = UIColor.gray
                self.stepCountName.textColor = UIColor.gray
                self.stepCountSwitch.setOn(false, animated: false)
                self.stepCountSwitch.isEnabled = false
            } else {
                self.stepCountLabel.text = String(self.steps)
                self.stepCountLabel.textColor = UIColor.black
                self.stepCountName.textColor = UIColor.black
                self.stepCountSwitch.isEnabled = true
            }
            if self.steps == -1 {
                self.stairSpeedLabel.text = ""
                self.stairSpeedLabel.textColor = UIColor.gray
                self.stairSpeedName.textColor = UIColor.gray
                self.stairSpeedSwitch.setOn(false, animated: false)
                self.stairSpeedSwitch.isEnabled = false
            } else {
                self.stairSpeedLabel.text = String(self.stairSpeed)
                self.stairSpeedLabel.textColor = UIColor.black
                self.stairSpeedName.textColor = UIColor.black
                self.stairSpeedSwitch.isEnabled = true
            }
            if self.steps == -1 {
                self.stepLengthLabel.text = ""
                self.stepLengthLabel.textColor = UIColor.gray
                self.stepLengthName.textColor = UIColor.gray
                self.stepLengthSwitch.setOn(false, animated: false)
                self.stepLengthSwitch.isEnabled = false
            } else {
                self.stepLengthLabel.text = String(self.stepLength)
                self.stepLengthLabel.textColor = UIColor.black
                self.stepLengthName.textColor = UIColor.black
                self.stepLengthSwitch.isEnabled = true
            }
            if self.steps == -1 {
                self.walkingSpeedLabel.text = ""
                self.walkingSpeedLabel.textColor = UIColor.gray
                self.walkingSpeedName.textColor = UIColor.gray
                self.walkingSpeedSwitch.setOn(false, animated: false)
                self.walkingSpeedSwitch.isEnabled = false
            } else {
                self.walkingSpeedLabel.text = String(self.walkingSpeed)
                self.walkingSpeedLabel.textColor = UIColor.black
                self.walkingSpeedName.textColor = UIColor.black
                self.walkingSpeedSwitch.isEnabled = true
            }
            if self.steps == -1 {
                self.heartRateLabel.text = ""
                self.heartRateLabel.textColor = UIColor.gray
                self.heartRateName.textColor = UIColor.gray
                self.heartRateSwitch.setOn(false, animated: false)
                self.heartRateSwitch.isEnabled = false
            } else {
                self.heartRateLabel.text = String(self.heartRate)
                self.heartRateLabel.textColor = UIColor.black
                self.heartRateName.textColor = UIColor.black
                self.heartRateSwitch.isEnabled = true
            }
            if self.gender == "" {
                self.genderLabel.text = ""
                self.genderLabel.textColor = UIColor.gray
                self.genderName.textColor = UIColor.gray
                self.genderSwitch.setOn(false, animated: false)
                self.genderSwitch.isEnabled = false
            } else {
                self.genderLabel.text = String(self.gender)
                self.genderLabel.textColor = UIColor.black
                self.genderName.textColor = UIColor.black
                self.genderSwitch.isEnabled = true
            }
            
            if self.birthDate == "" {
                self.birthDateLabel.text = ""
                self.birthDateLabel.textColor = UIColor.gray
                self.birthDateName.textColor = UIColor.gray
                self.birthDateSwitch.setOn(false, animated: false)
                self.birthDateSwitch.isEnabled = false
            } else {
                self.birthDateLabel.text = String(self.birthDate)
                self.birthDateLabel.textColor = UIColor.black
                self.birthDateName.textColor = UIColor.black
                self.birthDateSwitch.isEnabled = true
            }
            if self.bloodType == "" {
                self.bloodTypeLabel.text = ""
                self.bloodTypeLabel.textColor = UIColor.gray
                self.bloodTypeName.textColor = UIColor.gray
                self.bloodTypeSwitch.setOn(false, animated: false)
                self.bloodTypeSwitch.isEnabled = false
            } else {
                self.bloodTypeLabel.text = String(self.bloodType)
                self.bloodTypeLabel.textColor = UIColor.black
                self.bloodTypeName.textColor = UIColor.black
                self.bloodTypeSwitch.isEnabled = true
            }
            if self.bloodPressure == "" {
                self.bloodPressureLabel.text = ""
                self.bloodPressureLabel.textColor = UIColor.gray
                self.bloodPressureName.textColor = UIColor.gray
                self.bloodPressureSwitch.setOn(false, animated: false)
                self.bloodPressureSwitch.isEnabled = false
            } else {
                self.bloodPressureLabel.text = String(self.bloodPressure)
                self.bloodPressureLabel.textColor = UIColor.black
                self.bloodPressureName.textColor = UIColor.black
                self.bloodPressureSwitch.isEnabled = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { self.fill_UI() })
        } else {
            print("stopped")
        }
    }
    
    @IBAction func submitOnTouch(_ sender: Any) {
        self.send_data()
    }
    func send_data(){
        self.stop = true
        self.birthDateSwitch.isEnabled = false
        self.genderSwitch.isEnabled = false
        self.stairSpeedSwitch.isEnabled = false
        self.stepCountSwitch.isEnabled = false
        self.stepLengthSwitch.isEnabled = false
        self.walkingSpeedSwitch.isEnabled = false
        self.heartRateSwitch.isEnabled = false
        self.bloodPressureSwitch.isEnabled = false
        self.bloodTypeSwitch.isEnabled = false
        self.submitButton.backgroundColor = UIColor.gray
    }
}

