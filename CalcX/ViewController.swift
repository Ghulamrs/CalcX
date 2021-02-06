//
//  ViewController.swift
//  CalcX
//
//  Created by Home on 8/28/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

extension String {
    subscript(ch: Character) -> String {
        let dot = self.lastIndex(of: ch)
        return String(self[dot!..<self.endIndex])
    }
}

class ViewController: UIViewController {
    var fn:Int?
    var mem:String?
    var op1:String?
    var R1: Double?
    var R2: Double?
    var DMSb: Bool?
    var DMS: String? // to remember the original pattern
    var Degree: Double?
    var Minute: Double?
    var Second: Double?
    var normalColor: UIColor?
    let pi: Double = 3.141592653589793
    let abnormalColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1);
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBAction func Memory(_ sender: UIButton) {
        mem = textField.text
        if !mem!.isEmpty {
            button.isEnabled = true
            button?.tintColor = .red // UIColor(displayP3Red: 0, green: 0.5, blue: 0, alpha: 1)
        }
    }
    @IBAction func RecallMemory(_ sender: UIButton) {
        if !mem!.isEmpty { textField.text = mem }
    }
    @IBAction func DS(_ sender: UIButton) { // All D's Callback
        append(digit: Int(sender.titleLabel!.text!)!)
    }
    @IBAction func DD(_ sender: UIButton) {
        if !((textField.text?.contains("."))! || (textField.text?.contains("°"))!) {
            textField.text?.append(".")
        }
    }
    @IBAction func EQ(_ sender: UIButton) {
        calc(op: op1!)
        op1="="
    }
    @IBAction func FP(_ sender: UIButton) {
        calc(op: op1!)
        op1="+"
    }
    @IBAction func FS(_ sender: UIButton) {
        calc(op: op1!)
        op1="-"
    }
    @IBAction func FM(_ sender: UIButton) {
        calc(op: op1!)
        op1="*"
    }
    @IBAction func FD(_ sender: UIButton) {
        calc(op: op1!)
        op1="/"
    }
    @IBAction func CANCEL(_ sender: UIButton) {
        textField.text?.removeAll()
        fn = 0
        R1 = 0
    }
    @IBAction func CCANCEL(_ sender: UIButton) {
        let text = textField.text!
        if !text.isEmpty {
            textField.text = String(text.dropLast(1))
        }
        textField.resignFirstResponder()
    }
    func calc(op: String) {
        if textField.text!.isEmpty { return }
        if fn==0  {
            guard let x = Double(textField.text!) else { return }
            R1 = x
            fn = 2
        }
        else {
            guard let x = Double(textField.text!) else { return }
            R2 = x

            switch op {
            case "+": R1 = R1! + R2!
            case "-": R1 = R1! - R2!
            case "*": R1 = R1! * R2!
            case "/": R1 = R1! / R2!
            default:  R1 = R1! + 0
            }
            fn = 2
            textField.text = String(R1!)
        }
    }
    func append(digit: Int) {
        if fn==2 {
            textField.text?.removeAll()
            fn = 1
        }
        if badDegMinSec(digit: digit) { return }
        textField.text?.append(String(digit))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fn = 0
        mem = ""
        op1 = ""
        R1 = 0.0
        R2 = 0.0
        normalColor = textField.textColor
        button.isEnabled = false
    }
    @IBAction func ToDeg(_ sender: UIButton) {
        if textField.text!.isEmpty ||
           textField.text!.contains("°") { return }
        if fn==0 {
            guard let x = Double(textField.text!) else { return }
            R1 = x
        }
        if R1! > 2.1*pi { return }
        textField.text = String(R1!*180.0/pi)
    }
    @IBAction func ToRad(_ sender: UIButton) {
        if textField.text!.isEmpty { return }
        guard let x = Double(textField.text!) else { return }
        R1 = x
        if R1! > 360.1 { return }
        textField.text = String(R1!*pi/180.0)
    }
    @IBAction func ToDMS(_ sender: UIButton) {
        if textField.text!.isEmpty { return }
        if !(textField.text?.contains("°"))! {
            if textField.text!.contains(".") {
                let str = textField.text!["."]
                if  str.count > 3 { toDMS(); return }
            }
            guard let x = Double(textField.text!) else { return }
            if x >= 360.0 { textField.textColor = abnormalColor; return }
            textField.textColor = normalColor
            textField.text?.append("°")
            Degree  = x
        }
        else if !(textField.text?.contains("'"))! {
            let DM2 = textField.text!.components(separatedBy: ["°"])
            if  DM2.count < 2 { return }
            guard let x = Double(DM2[1]) else { return }
            if x > 59.0 { textField.textColor = abnormalColor; return }
            textField.textColor = normalColor
            textField.text?.append("'")
            Minute  = x
        }
        else if !(textField.text?.contains("\""))! {
            let DM3 = textField.text!.components(separatedBy: ["°","'"])
            if  DM3.count < 3 { return }
            guard let x = Double(DM3[2]) else { return }
            if x > 59.0 { textField.textColor = abnormalColor; return }
            textField.textColor = normalColor
            textField.text?.append("\"")
            Second =  x
            DMSb = true
        }
        else if(DMSb! == true) {
            DMS = textField.text!
            let dms = Degree! + (Minute! + Second!/60.0) / 60.0
            var dmsStr = String(dms);
            if  dmsStr.count > 10 {
                dmsStr = String(dmsStr.dropLast(3))
            }
            textField.text =  dmsStr + "°'\""
            DMSb = false
        }
        else {
            DMSb = true
            textField.text = DMS!
        }
    }
    @IBAction func Sin(_ sender: UIButton) {
        if textField.text!.isEmpty { return }
        let text = textField.text!.trimmingCharacters(in: ["°","'","\""])
        guard let x = Double(text) else { return }
        if fabs(x) <= 2.0*pi {
            textField.text = String(sin(x))
        } else if(fabs(x) < 360.1) {
            textField.text = String(sin(x*pi/180))
        }
    }
    @IBAction func Cos(_ sender: UIButton) {
        if textField.text!.isEmpty { return }
        let text = textField.text!.trimmingCharacters(in: ["°","'","\""])
        guard let x = Double(text) else { return }
        if fabs(x) <= 2.0*pi {
            textField.text = String(cos(x))
        } else if(fabs(x) < 360.1) {
            textField.text = String(cos(x*pi/180))
        }
    }
    @IBAction func Tan(_ sender: UIButton) {
        if textField.text!.isEmpty { return }
        let text = textField.text!.trimmingCharacters(in: ["°","'","\""])
        
        guard let x = Double(text) else { return }
        if fabs(x) <= 2.0*pi {
            textField.text = String(tan(x))
        } else if(fabs(x) < 360.1) {
            textField.text = String(tan(x*pi/180))
        }
    }
    @IBAction func Log(_ sender: UIButton) { // pi
        if !textField.text!.isEmpty {
            guard let x = Double(textField.text!) else { return }
            R1 = x
        } else {
            R1 = 1.0
        }
        
        textField.text = String(pi*R1!)
        fn = 0
    }
    @IBAction func Logn(_ sender: UIButton) { // used for +/- instead of log
        if textField.text!.isEmpty { return }
        let text = textField.text!.trimmingCharacters(in: ["°","'","\""])
        if  text.contains("°") || text.contains("'") { return }
        guard let x = Double(text) else { return }
        textField.text = String(-x)
    }
    func badDegMinSec(digit: Int) -> Bool {
        if textField.text!.contains("\"") { return true }
        if textField.text!.contains("°") {
            let parts = textField.text!.components(separatedBy: ["°","'"])
            if  parts.count > 1 {
                var last = parts[parts.count-1]
                if !last.isEmpty {
                    last.append(String(digit))
                    let value = Float(last)!
                    if value > 59 { return true }
                }
            }
        }
        return false
    }
    func toDMS() {
        guard let x = Double(textField.text!) else { return }
        textField.text?.append("°'\"")
        if  x > 360.0 { return }
        Degree = floor(x)
        let y = 60.0 * (x - Degree!)
        Minute = floor(y)
        let z = 60.0 * (y - Minute!)
        Second = floor(z + 0.5)
        DMS = String(Int(Degree!)) + "°" + String(Int(Minute!)) + "'" + String(Int(Second!)) + "\""
        DMSb = false
    }
}
//  let alert = UIAlertController(title: "Calc", message: "Ver 2.3\nOctober 21, 2019", preferredStyle: UIAlertController.Style.alert)
//  let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//  alert.addAction(OKAction)
//  self.present(alert, animated: true, completion: nil)
