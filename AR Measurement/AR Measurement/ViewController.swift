//
//  ViewController.swift
//  AR Measurement
//  Created by Nareshri Babu on 2020-05-05.
//  Copyright © 2020 Nareshri Babu. All rights reserved.
//  This app was created for learning purposes.
//  All images were only used for learning purposes and do not belong to me.
//  All sounds were only used for learning purposes and do not belong to me.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //tapping the scene for the third time it removes all the dots form the scene
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            dotNodes = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            //converts the touches from your phone screen to the "real world"
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.002)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                   y: hitResult.worldTransform.columns.3.y,
                                   z: hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        //sceneView.autoenablesDefaultLighting = true
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
        
    }
    
    func calculate() {
        
        //should only have 2 dots in the array
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        let unsignedDistance = abs(distance) * 100
        
        let textString = String(format: "%.2f", unsignedDistance)
        
        updateText(text: "\(textString)cm", atPosition: end.position)
        
    }
    
    func updateText(text: String, atPosition position: SCNVector3) {

        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        textNode = SCNNode(geometry: textGeometry)
        
//        textNode.position = SCNVector3(x: position.x, y: position.y + 0.01, z: position.z)
        
        textNode.position = SCNVector3(x: position.x - 0.07, y: position.y + 0.01, z: position.z + 0.0013)
        
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    @IBAction func clearDots(_ sender: UIBarButtonItem) {
        
        //remove text
        textNode.removeFromParentNode()
        
        //remove dots
        for dot in dotNodes {
            dot.removeFromParentNode()
        }
        
        dotNodes = [SCNNode]()
    }
    
    
}


