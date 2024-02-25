//
//  ViewController.swift
//  slideTimer
//
//  Created by LARRY COMBS on 1/21/18.
//  Copyright © 2018 LARRY COMBS. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, CountdownTimerDelegate {
    
    
    
    //MARK - Outlets
    @IBOutlet weak var History: UIBarButtonItem!
    @IBAction func History(_ sender: Any) {
        
        
    }
    
    @IBOutlet weak var Reset: UIBarButtonItem!
    @IBAction func Reset(_ sender: Any) {
        
        sliderHoursOutlet.isHidden = false
        sliderMinutesOutlet.isHidden = false
        sliderSecondsOutlet.isHidden = false
        messageLabel.isHidden = true
        counterView.isHidden = false
        
        stopBtn.isEnabled = false
        stopBtn.alpha = 1.0
        Reset.isEnabled = true
        startBtn.setTitle("START",for: .normal)
        
        
    }
    @IBOutlet weak var sliderHoursOutlet: UISlider!
    
    @IBAction func sliderHoursAction(_ sender: UISlider)
    {
        let value = Int(sender.value)
        selectedHours = value
        hours.text = String(value)
        countdownTimer.duration = Double(sender.value)
        countdownTimer.setTimer(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        progressBar.setProgressBar(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
       
    }
    @IBOutlet weak var sliderMinutesOutlet: UISlider!
    @IBAction func sliderMinutesAction(_ sender: UISlider)
    {
        let value = Int(sender.value)
        selectedMinutes = value
        minutes.text = String(value)
        countdownTimer.setTimer(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        progressBar.setProgressBar(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        
 
    }
    @IBOutlet weak var sliderSecondsOutlet: UISlider!
    @IBAction func sliderSecondsAction(_ sender: UISlider)
    {
        selectedSecs = Int(sender.value)
        //countdownTimer.duration = Double(sender.value)
        seconds.text? = String(selectedSecs)
        countdownTimer.setTimer(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        progressBar.setProgressBar(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        
    }
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var counterView: UIStackView!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    
    
    //MARK - Vars
    
    var countdownTimerDidStart = false
    var soundEffect: AVAudioPlayer = AVAudioPlayer()
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    
    // MARK - Slider Load Setup 
    var selectedSecs = 30
    var selectedMinutes = 0
    var selectedHours = 0
    
    let picker = UIDatePicker()
    
    
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Done!"
        
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //randomColor()
        
       
        func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
            // Randomly generate number in closure
            let randomColorGenerator = { ()-> CGFloat in
                CGFloat(arc4random() % 256 ) / 256
            }
            
            var red: CGFloat = randomColorGenerator()
            var green: CGFloat = randomColorGenerator()
            var blue: CGFloat = randomColorGenerator()
            
            // Mix the color
            if let mixColor = mixColor {
                var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
                mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
                
                red = (red + mixRed) / 2;
                green = (green + mixGreen) / 2;
                blue = (blue + mixBlue) / 2;
            }
            
            return UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        
        }
        
        view.backgroundColor = generateRandomPastelColor(withMixedColor: randomColor())
        
        
        
        countdownTimer.delegate = self
        countdownTimer.setTimer(hours: 0, minutes: 0, seconds: selectedSecs)
        progressBar.setProgressBar(hours: 0, minutes: 0, seconds: selectedSecs)
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        Reset.isEnabled = false
        view.addSubview(messageLabel)
        
        var constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.minutes, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.minutes, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, YYYY"
        let stringDate = dateFormatter.string(from: date as Date)
        Date.text = stringDate
        
        messageLabel.isHidden = true
        counterView.isHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Countdown Timer Delegate
    
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        hours.text = time.hours
        minutes.text = time.minutes
        seconds.text = time.seconds
    }
    
    
    func countdownTimerDone() {
        
        sliderHoursOutlet.isHidden = false
        sliderMinutesOutlet.isHidden = false
        sliderSecondsOutlet.isHidden = false
        counterView.isHidden = true
        messageLabel.isHidden = false
        seconds.text = String(selectedSecs)
        countdownTimerDidStart = false
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        startBtn.setTitle("START",for: .normal)
        Reset.isEnabled = true
        
       
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let musicFile = Bundle.main.path(forResource: "SystemSoundID", ofType: ".mp3")
        do {
            try soundEffect = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch{
            
            print(error)
        }
        
        soundEffect.play()
        
            
        print("countdownTimerDone")
    }
    
    
    //MARK: - Actions
    
    @IBAction func startTimer(_ sender: UIButton) {
        
        sliderHoursOutlet.isHidden = true
        sliderMinutesOutlet.isHidden = true
        sliderSecondsOutlet.isHidden = true
        messageLabel.isHidden = true
        counterView.isHidden = false
        
        stopBtn.isEnabled = true
        stopBtn.alpha = 1.0
        Reset.isEnabled = false
        
        let string = hours.text! + ":" + minutes.text! + ":" + seconds.text!
        SlideTimerUserDefaults().add(entry: string)
        
        // Set progessBar and countdownTimer
        
        if !countdownTimerDidStart{
            countdownTimer.start()
            progressBar.start()
            countdownTimerDidStart = true
            startBtn.setTitle("PAUSE",for: .normal)
            
        }else{
            countdownTimer.pause()
            progressBar.pause()
            countdownTimerDidStart = false
            startBtn.setTitle("RESUME",for: .normal)
        }
    }
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        
        resetTimer()
    }
    
    func resetTimer(){
        
        sliderHoursOutlet.isHidden = false
        sliderMinutesOutlet.isHidden = false
        sliderSecondsOutlet.isHidden = false
        countdownTimer.stop()
        progressBar.stop()
        countdownTimerDidStart = false
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        startBtn.setTitle("START",for: .normal)
        Reset.isEnabled = false
        
        
    }
    

    func randomColor() -> UIColor {
        
        let redValue = CGFloat(arc4random_uniform(256))/256.0
        let blueValue = CGFloat(arc4random_uniform(256))/256.0
        let greenValue = CGFloat(arc4random_uniform(256))/256.0
        return UIColor (red: redValue, green: greenValue, blue: blueValue, alpha: 0.5)
    }

    func countArray (){
       // print(count)
        
    }
    
    
    
}
