//
//  VoicemailViewController.swift
//  EngageApp
//
//  Created by Grace Lam on 1/9/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VoicemailViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable play and done buttons on launch
        playButton.isEnabled = false
        playButton.alpha = 0.35
        doneButton.isEnabled = false
        doneButton.alpha = 0.25
        recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
        playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
        
        // set the audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var currentDateTime = Date()
        var formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.string(from: currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        //print(filePath!)
        
        // set up audio session
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // initialize and prepare the recorder
        do {
            audioRecorder = try AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
        } catch let error as NSError {
            audioRecorder = nil
            print(error.localizedDescription)
        }
        
        // initialize and prepare the player
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch let error as NSError {
            audioPlayer = nil
            print(error.localizedDescription)
        }
        
    }
    
    
    @IBAction func recordStopButton(sender: UIButton) {
        
        // determining function of record/stop button
        if (recordButton.currentBackgroundImage == UIImage(named: "record")) {
            recordAudio()
        } else {
            stopRecording()
        }
    }
    
    func recordAudio() {
        
        recordButton.setBackgroundImage(UIImage(named: "stop"), for: UIControlState.normal)
        
        // stop the audio player before recording
        if (audioPlayer.isPlaying) {
            audioPlayer.stop()
        }
        
        // start recording
        if (!audioRecorder.isRecording) {
            
            audioRecorder.record()
            
            playButton.isEnabled = false
            playButton.alpha = 0.35
            doneButton.isEnabled = false
            doneButton.alpha = 0.25
        }
    }
    
    func stopRecording() {
        
        recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
        
        // stop recording and close the file, else cannot play
        if (audioRecorder.isRecording) {
            
            audioRecorder.stop()
            
            playButton.isEnabled = true
            playButton.alpha = 1
            doneButton.isEnabled = true
            doneButton.alpha = 1
        }
        
        // update the player here, else play will always start from beginning
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch let error as NSError {
            audioPlayer = nil
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func playPauseButton(sender: UIButton) {
        
        // determining function of play/pause button
        if (playButton.currentBackgroundImage == UIImage(named: "play")) {
            playAudio()
        } else {
            pauseAudio()
        }
    }
    
    func playAudio() {
        
        playButton.setBackgroundImage(UIImage(named: "pause"), for: UIControlState.normal)
        recordButton.isEnabled = false
        recordButton.alpha = 0.35
        
        // play the recording
        if (!audioPlayer.isPlaying) {
            audioPlayer.play()
            print("playing", audioPlayer.duration) // for testing purposes
        }
    }
    
    func pauseAudio() {
        
        playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
        recordButton.isEnabled = true
        recordButton.alpha = 1
        
        // pause the replay
        if (audioPlayer.isPlaying) {
            audioPlayer.pause()
        }
    }
    
    
    @IBAction func doneVoicemail(sender: UIButton) {
        
        // end voicemail recording session
        audioRecorder.stop()
        audioPlayer.stop()
        
        // set audio session inactive
        var audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.performSegue(withIdentifier: "doneSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass the recorded file to the next view controller
        if segue.identifier == "doneSegue" {
            let secondViewController = segue.destination as! ConfirmVoicemailViewController
            secondViewController.audioFile = audioRecorder.url as NSURL!
        }
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        if sender.identifier == "doneSegueUnwind" {
            // disable play and done buttons on return
            playButton.isEnabled = false
            playButton.alpha = 0.35
            doneButton.isEnabled = false
            doneButton.alpha = 0.25
            recordButton.isEnabled = true
            recordButton.alpha = 1
            recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
            playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
            
            var audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        
            audioRecorder.deleteRecording()
        }
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "doneSegueUnwind" {
                let unwindSegue = SegueFromLeft(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }
    
    
    // handling audio interruptions when recording, flag will be false
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
        
        if !flag {
            audioRecorder.stop()
            
            playButton.isEnabled = false
            playButton.alpha = 0.35
            doneButton.isEnabled = false
            doneButton.alpha = 0.25
            
            let alert = UIAlertController(title: "Error", message: "Your voicemail could not be recorded due to interruptions. Please try recording again.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    
    // handling audio interruptions when recording, flag will be false
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        // reset play button if finished playing successfully
        if flag {
            pauseAudio()
        }
    }
}
