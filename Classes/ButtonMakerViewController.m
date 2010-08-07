//
//  ButtonMakerViewController.m
//  ButtonMaker
//
//  Created by Dermot Daly on 22/04/2010.
//  Copyright tapadoo 2010. All rights reserved.
//

#import "ButtonMakerViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation ButtonMakerViewController

@synthesize redSlider;
@synthesize greenSlider;
@synthesize blueSlider;
@synthesize widthSlider;
@synthesize heightSlider;

@synthesize redValueField;
@synthesize greenValueField;
@synthesize blueValueField;
@synthesize heightField;
@synthesize widthField;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Force the first draw
	[self colorSliderChanged:nil];
	[self sizeSlideChanged:nil];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[theButton release];
    [super dealloc];
}

-(void) updateButton { 
	if(theButton != nil) {
		[theButton removeFromSuperview];
		[theButton release];
		theButton = nil;
	}
	// OK - Create it
	CGFloat width = roundf(widthSlider.value);
	CGFloat height = roundf(heightSlider.value);
	CGFloat x = 160.0 - width/2;
	CGFloat y = 280.0;
	CGFloat red = roundf(redSlider.value)/255.0;
	CGFloat green = roundf(greenSlider.value)/255.0;
	CGFloat blue = roundf(blueSlider.value)/255.0;
	
	Class theClass = NSClassFromString(@"UIGlassButton");
	theButton = [[theClass alloc] initWithFrame:CGRectMake(x, y, width, height)];
	[theButton setValue:[UIColor colorWithRed:red green:green blue:blue alpha:1.0] forKey:@"tintColor"];
	[self.view addSubview:theButton];
}

-(IBAction) colorSliderChanged:(id)sender {
	// Update all the color Fields
	redValueField.text = [NSString stringWithFormat:@"%d", (int)roundf(redSlider.value)];
	blueValueField.text = [NSString stringWithFormat:@"%d", (int)roundf(blueSlider.value)];
	greenValueField.text = [NSString stringWithFormat:@"%d", (int)roundf(greenSlider.value)];
	[self updateButton];
}
-(IBAction) sizeSlideChanged:(id)sender {
	widthField.text = [NSString stringWithFormat:@"%d", (int)roundf(widthSlider.value)];
	heightField.text = [NSString stringWithFormat:@"%d", (int)roundf(heightSlider.value)];
	[self updateButton];
}

- (void) saveImageToFile: (NSString *) filePath {
	UIGraphicsBeginImageContext(theButton.frame.size);
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	[theButton.layer renderInContext:theContext];
	
	CGRect					overDrawRects[] = {CGRectMake(10, 0, 1, theButton.frame.size.height), CGRectMake(theButton.frame.size.width - 11, 0, 1, theButton.frame.size.height)};
	
	[[UIColor clearColor] set];
	
	for (int i = 0; i < 2; i++) {
		UIRectFill(overDrawRects[i]);
		CGContextSaveGState(theContext);
		CGContextClipToRect(theContext, overDrawRects[i]);
		CGContextTranslateCTM(theContext, -1, 0);
		[theButton.layer renderInContext:theContext];
		CGContextRestoreGState(theContext);
	}
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	NSData *theData = UIImagePNGRepresentation(theImage);
	[theData writeToFile: filePath atomically:NO];
	UIGraphicsEndImageContext();	
}

-(IBAction) saveTapped:(id)sender {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	NSString *buttonFile = [documentsDirectory stringByAppendingPathComponent:@"button.png"];
	NSString *buttonHighlightFile = [documentsDirectory stringByAppendingPathComponent:@"button-highlight.png"]; 
	
	[self saveImageToFile: buttonFile];
	
	
	
	[theButton setHighlighted:YES];
	
	[self saveImageToFile: buttonHighlightFile];

	[theButton setHighlighted:NO];
	NSString *msg = [NSString stringWithFormat:@"Wrote files to %@", documentsDirectory];
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Done" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alertView show];
}

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
	UISlider *slider;
	
	if(textField == redValueField) slider = redSlider;
	else if(textField == greenValueField) slider = greenSlider;
	else if(textField == blueValueField) slider = blueSlider;
	else if(textField == widthField) slider = widthSlider;
	else if(textField == heightField) slider = heightSlider;
	
	if(slider) {
		slider.value = [textField.text intValue];
		[self updateButton];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
