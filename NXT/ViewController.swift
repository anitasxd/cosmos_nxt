//
//  ViewController.swift
//  NXT
//
//  Created by Student on 7/23/17.
//  Copyright © 2017 Moses Oh. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {
    
    let PI : Float = 3.14159265359
    var engine: AVAudioEngine!
    var file:  AVAudioFile!
    var buffer: AVAudioPCMBuffer!
    var player:  AVAudioPlayerNode!
    var output: AVAudioOutputNode!
    var mixer: AVAudioMixerNode!
    var mixer3d: AVAudioEnvironmentNode!
    var selectedAlgorithm: Int!
    
    @IBOutlet weak var Person1: UIButton!
    @IBOutlet weak var Person2: UIButton!
    @IBOutlet weak var Person3: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
   
        guard let filePath = Bundle.main.url(forResource: "Person1Moses", withExtension: "WAV", subdirectory: "Sounds") else {
            print("Cannot find file")
            return
        }
        do {
            file = try AVAudioFile(forReading: filePath)
        }
        catch {
            print("Cannot load audiofile!")
        }
        // We need the following two statements to use our buffer object
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        // we create an instance of the buffer
        buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
        do {
            try file.read(into: buffer, frameCount: audioFrameCount)
            print("File loaded")
        }
        catch{
            print("Could not load file into buffer")
        }
        
        // We create a helper function to init the sound engine (makes code easier to read and clean)
        initEngine()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
           }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initEngine(){
        
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        mixer3d = AVAudioEnvironmentNode()
        // Helper function to initialize the player (source) and head (mixer3D or EnvironmentNode)
        initPositions()//(mixer3d, playerPosition: player)
        
        // Here we connect the nodes following a signal flow chain
        mixer = engine.mainMixerNode
        engine.attach(player)
        engine.attach(mixer3d)
        player.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm(rawValue: 5)!
        engine.connect(player, to: mixer3d, format: file.processingFormat)
        engine.connect(mixer3d, to: mixer, format: mixer3d.outputFormat(forBus: 0))
        
        let loop = AVAudioPlayerNodeBufferOptions.loops
        player.scheduleBuffer(buffer, at: nil, options: loop, completionHandler: nil)
        do {
            try engine.start()
        }
        catch {
            print("Cannot initialize engine")
        }
        player.play()
    }
    
    
    func initPositions(){
        mixer3d.listenerPosition.x = 0
        mixer3d.listenerPosition.y = 0
        mixer3d.listenerPosition.z = 0
        
        player.position.x = 0
        player.position.y = 0
        player.position.z = 0
    }
    
    
    @IBAction func algorithm1(_ sender: UIButton) {
        player.play()
    }


    func degrees(_ radian: Float) -> Float {
        return (180 * radian / PI)
    }
    
    func receivedOrientationDictionary(_ data: [String:Float]) {
        
        // Retreive the value of the dictionary with the data from sensors
        let pitch = data["pitch"]
        let yaw = data["yaw"]
        let roll = data["roll"]
        
        //Change the orientation of the head (mixer3d, our environmentNode)
        mixer3d.listenerAngularOrientation.pitch  = degrees(pitch!)
        mixer3d.listenerAngularOrientation.yaw = degrees(yaw!)
        
    }
    
}




