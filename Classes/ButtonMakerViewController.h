//
//  ButtonMakerViewController.h
//  ButtonMaker
//
//  Created by Dermot Daly on 22/04/2010.
//  Copyright tapadoo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonMakerViewController : UIViewController <UITextFieldDelegate> {
	UISlider *redSlider;
	UISlider *greenSlider;
	UISlider *blueSlider;
	UISlider *widthSlider;
	UISlider *heightSlider;
	
	UITextField *redValueField;
	UITextField *greenValueField;
	UITextField *blueValueField;
	UITextField *heightField;
	UITextField *widthField;
	
	UIButton *theButton;
}

@property(nonatomic, retain) IBOutlet UISlider *redSlider;
@property(nonatomic, retain) IBOutlet UISlider *greenSlider;
@property(nonatomic, retain) IBOutlet UISlider *blueSlider;
@property(nonatomic, retain) IBOutlet UISlider *widthSlider;
@property(nonatomic, retain) IBOutlet UISlider *heightSlider;

@property(nonatomic, retain) IBOutlet UITextField *redValueField;
@property(nonatomic, retain) IBOutlet UITextField *greenValueField;
@property(nonatomic, retain) IBOutlet UITextField *blueValueField;
@property(nonatomic, retain) IBOutlet UITextField *heightField;
@property(nonatomic, retain) IBOutlet UITextField *widthField;

-(IBAction) colorSliderChanged:(id)sender;
-(IBAction) sizeSlideChanged:(id)sender;
-(IBAction) saveTapped:(id)sender;

@end

