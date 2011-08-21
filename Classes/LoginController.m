//
//  LoginController.m
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import "LoginController.h"


@implementation LoginController
@synthesize btnSave;
@synthesize username;
@synthesize password;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *user = (NSString*) [defaults  objectForKey:@"username"];
	NSString *pass = (NSString*) [defaults  objectForKey:@"password"];
	
	password.text = pass;
	username.text = user;
	[user release];
	[pass release];
	
}


- (void) loadView {
	[super loadView];
	[self setTitle:@"Přihlášení"];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark
#pragma mark touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [[event allTouches] anyObject];
    if ([password isFirstResponder] && [touch view] != password) {
        [password resignFirstResponder];
	}	
	if([username isFirstResponder] && [touch view] != username) {
        [username resignFirstResponder];		
    }
    [super touchesBegan:touches withEvent:event];
}


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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	[username resignFirstResponder];
	[password resignFirstResponder];
	[self save];
	return YES;
}

#pragma mark
#pragma mark Actions

- (IBAction)save {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username.text forKey:@"username"];
	[defaults setObject:password.text forKey:@"password"];
	
	[defaults synchronize];
	[password resignFirstResponder];
	[username resignFirstResponder];
	[[[[self tabBarController] viewControllers] objectAtIndex:0] popToRootViewControllerAnimated:NO];
	[self.tabBarController setSelectedIndex:1];
}



- (void)dealloc {
	[password release];
	[username release];
	[btnSave release];	
    [super dealloc];
}


@end
