//
//  AddCourse.m
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import "AddCourse.h"


@implementation AddCourse
@synthesize delegate;
@synthesize program;
@synthesize courseName;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction) save {
	NSMutableString* p = [NSMutableString stringWithString:[program titleForSegmentAtIndex:[program selectedSegmentIndex]]];
	NSString* str = [[p stringByAppendingFormat:@"-%@",courseName.text] uppercaseString];
	[delegate updateCourses:str];
	[self dismissModalViewControllerAnimated:true];
	
}

- (IBAction) close {

	[self dismissModalViewControllerAnimated:true];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	[courseName resignFirstResponder];
	[self save];
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [[event allTouches] anyObject];
    if ([courseName isFirstResponder] && [touch view] != courseName) {
        [courseName resignFirstResponder];
	}	
	
    [super touchesBegan:touches withEvent:event];
}

- (void)dealloc {
	[courseName release];
	[program release];
	//[delegate release];
    [super dealloc];
}


@end
