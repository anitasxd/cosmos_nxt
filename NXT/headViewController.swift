//
//  GameViewController.swift
//  head
//
//  Created by Martin Jaroszewicz on 7/18/17.
//  Copyright © 2017 Martin Jaroszewicz. All rights reserved.
//
//
//  PA3DTrackingView.swift
//  AccelerometerTest
//
//  Created by Pasquale Ambrosini on 14/05/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import SceneKit

class headViewController: SCNView {
    
    var pointerNode: SCNNode!
    var pointerBox: SCNSphere!
    var ship : SCNNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupScene()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupScene()
    }
    
    
    
    fileprivate func setupScene() {
        
        let scene = SCNScene(named: "art.scnassets/head.dae")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        /*
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        */
        // retrieve the ship node
        ship = scene.rootNode.childNode(withName: "basicHead_0", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self as! SCNView

        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        //create pointer
        
        pointerBox = SCNSphere(radius: 0.5)
        pointerNode = SCNNode(geometry: pointerBox)
        pointerNode.position = SCNVector3(0,0,0)
        scene.rootNode.addChildNode(pointerNode)

        pointerBox.firstMaterial?.diffuse.contents = UIColor.blue
        pointerBox.firstMaterial?.specular.contents = UIColor.white
        pointerBox.firstMaterial?.shininess = 10.0
        //pointerBox.firstMaterial?.reflective.contents = scene.background.contents
        
        pointerNode.castsShadow = true
        //setPointerPosition(x: 0, y: 0, z: 4)
        pointerNode.position = SCNVector3(x: 0, y: 0, z: 4)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }

    }
    
    func setPointerPosition(x: Double, y: Double, z: Double) {
        //self.pointerNode.position = SCNVector3(x, y, z)
        
        
        //ship.position.x = Float(x)
        ship.eulerAngles.y = Float(y)
        //ship.position.y = Float(y)
        //ship.position.z = Float(z)
    }
}

