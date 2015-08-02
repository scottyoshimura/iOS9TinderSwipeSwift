//
//  ViewController.swift
//  animatedSwipe
//
//  Created by Scott Yoshimura on 8/1/15.
//  Copyright © 2015 west coast dev. All rights reserved.
//
//this app will cover how to create links and labels programatically without using storyboard

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // lets create a label making a UILabel, frame and CGRectMake. X is the distrance from the left edge of screen. you can get the width of the screen using self. to get the viewController, view. to get the view. then bounds and then width, will give you the width of the screen. if you just divide it by two will get you to the center of the screen, but would make hte left hand edge the center. so we need to subtract half the width of the rectangle, the label - 100. 
        // to repeat, we want the left of the edge to be 100 pixels to the left of the center of the screen. this is because the width of the label will be 200. so this will make the label central. and to do that we use below. self.view.bounds.width will give us the width of the screen, divide that by 2 and subtract the 100. for height, we will make the label 100 pixels high, so - 50. and then for width and height, we enter the size of hte label.
        let label = UILabel(frame: CGRectMake(self.view.center.x - 100, self.view.center.y - 50, 200, 100))
        //lets create the actual label text, what gets dragged around
        label.text = "drag me"
        //lets set the text alignment
        label.textAlignment = NSTextAlignment.Center
        //and lets present it in the view controller, addSubview and label is the label we want to add
        self.view.addSubview(label)
        
        //lets create a gesture to get let the user make a drag. //target is self, action is the method that we want called when a drag is recognized
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
            //remember, if we want some information about the pan to be passed on to our selector we ahve to put the colon. if we didn't do that, we would still call wasDragged, but the info wouldn't be passed from the gestureRecognizer to the Selector. and we aer going to want to know when and where the user dragged the label
        //then lets add the gesture to the label
        label.addGestureRecognizer(gesture)
        //and we want to allow user interaction with the label
        label.userInteractionEnabled = true
        
    }

    //the wasDragged method is going to receive a gestureRecognizer, called gesture, with a type UIPanGestrureREcognizer. we can then use a closure for some code.
    func wasDragged(gesture: UIPanGestureRecognizer) {
        //this function will give us alot of information that will be helpful.
        print("wasDragged")
        
        //we want to know the "translation" of the gesture. the translation from one point to another is a description of how to get from one point to another. we want to know where it started, and where it ended up.
            //lets create a variable to get that. we will take our gesture that was passed from the UIPanGestureRecognizer and we can take from that the translation in the view; the view is just self.
        let translation = gesture.translationInView(self.view)
        
        //now we want to move the label too, the translation coordinate.
        //notice we can't use label here, but the gesture variable gives us the object that has been dragged, so we can get that to represent our label. we have to force unwrap gesture.view, cause we know it will be there.
        print(translation)
        let label = gesture.view!
        
        //then we will set the label.center to the new coordinate. we get that from cgpoint. cg point creates a coordinate pair relative to the bottom left of the screen. and remember translation gives us a coordinate relative to the center of the screen, which is where we started off. too work out hte new coordinate is as a cgpoint to start off in the center of the screen, and then add the amount that has been translated in the x direction.
        
        label.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y)
        //we can set the label so that it returns to the center whenever the user lets their finger off the screen by checking another aspect of our gesture variable which is gesture.state
        
        //the more this label moves to left or right, we want it to get smaller lets set up a variable that tracks how far from the center the label is
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        //lets set up a scale which is going to determine the size based on how far it is from the center. so we know we need xFromCenter, we don't care about scaling to the left or the right, so we use abs, which is short for absolute, which just gives you the value of xFromCenter regardless if it is positive or negative. we want the scale to be one in the center, and we want it to get smaller and smaller as the xFromCenter gets bigger and bigger. if you want something to get smaller, while something gets bigger, generally it is a good idea to divide by the thing that is getting bigger. so something like below, the scale will get smaller, as xFromCenter gets bigger. however, we want to be careful, cause when xFromCenter is small, then the scale could be flipped. so we don't ever want to make this thing bigger, only smaller. the way we can deal with that is to set the scale to a minimum of either the calculation below, or 1. so essentially, it can never be greater than 1.
        let scale = min(100 / abs(xFromCenter), 1)
        
        //below, makes a rotation based from an angle. the angle is in radians. a radian is like a degree, a deggree is split from a circle 360 degrees, with a tranform, the circle is split into two pi radians, which makes certain mathmatical tasks much easier, but make it more complicated to think about. for now, lets say about two pi is 6. so we want one radian.
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        //we want the rotation to be roughly in proportion to the distance from the center. the positive and negative thing works in our favor
        
        //lets set up our. a scale is made from a previous transform, rotation in this case, and a scale in x and a scale in y
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        //below applies to both the rotation and stretch
        label.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            //lets first check to what degree the user has swiped to the left or right
            if label.center.x < 100 {
                print("not chosen")
            } else if label.center.x > self.view.bounds.width - 100 {
                print("chosen")
            }
            
            
            //lets reset the label to its origins
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            
            //if the gesture state has ended, lets move the label to the center
            label.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        }
        
        //what we want is to have our label move around where ever the user wants to
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

