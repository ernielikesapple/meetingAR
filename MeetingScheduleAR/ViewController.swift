//
//  ViewController.swift
//  MeetingScheduleAR
//
//  Created by ernie.cheng on 9/26/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var currentCameraCoordinates = myCameraCoordinates(x: 0,
                                                       y: 0,
                                                       z: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.allowsCameraControl =  true
        sceneView.autoenablesDefaultLighting = true
        sceneView.isPlaying = true
    }
    
    func initCamera(){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
        addObject()
    }
    
    func addObject() {
        let calendar = ARCalendar()
        calendar.loadModal()
        let appearPostion = SCNVector3Make(1, 1, 1)
        calendar.position = appearPostion
        // add the calendar to the scene
        sceneView.scene.rootNode.addChildNode(calendar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            //let hitList = sceneView.hitTest(location, types: nil)
            // from the sceneARKit
            let hitList = sceneView.hitTest(location, options: nil)
            if let hitObject = hitList.first {
               let node = hitObject.node
                if node.name == "calendarTitle" {
                    node.removeFromParentNode()
                    addCube()
                    print("label get touched")
                }
            }
        }
    }
    
    func addCube() {
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        cubeNode.position = SCNVector3Make(currentCameraCoordinates.x,
                                           currentCameraCoordinates.y,
                                           currentCameraCoordinates.z)
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
 
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        let currentTransform = frame.camera.transform
        let cameraCoordinates = MDLTransform(matrix: currentTransform)
        currentCameraCoordinates = myCameraCoordinates(x: cameraCoordinates.translation.x,
                                                       y: cameraCoordinates.translation.y,
                                                       z: cameraCoordinates.translation.z)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

struct myCameraCoordinates {
    var x = Float()
    var y = Float()
    var z = Float()
}
