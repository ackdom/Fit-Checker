    //
//  SettingsController.m
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import "SettingsController.h"
#import "FirstViewController.h"
#import "AddCourse.h"


@implementation SettingsController

@synthesize table;
@synthesize courses;


/* // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		NSLog(@"init");
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	[self setTitle:@"Předměty"];
	[super loadView];

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.courses = (NSMutableArray*) [defaults objectForKey:@"courses"];	
	if (self.courses == nil) {
		self.courses = [[NSMutableArray alloc] initWithCapacity:2];
	}
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
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark
#pragma mark tableDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
	cell.textLabel.text = (NSString*)[courses objectAtIndex:indexPath.row];
    return cell;	
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [self.courses count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	
    NSString *stringToMove = [[self.courses objectAtIndex:sourceIndexPath.row] retain];
	
    [self.courses removeObjectAtIndex:sourceIndexPath.row];
	
    [self.courses insertObject:stringToMove atIndex:destinationIndexPath.row];
	
    [stringToMove release];
	
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//return [NSString stringWithString:@"Předměty"];
}*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
    [super setEditing:editing animated:animated];
	if(!editing) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:self.courses forKey:@"courses"];		
		[defaults synchronize];
	}
    [table setEditing:editing animated:YES];
	
   	
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        [courses removeObjectAtIndex:indexPath.row];		
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
					 withRowAnimation:UITableViewRowAnimationFade];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:self.courses forKey:@"courses"];		
		[defaults synchronize];
		
    }
	
}

/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"aaaaaa");
	FirstViewController *trailDetailController = [[FirstViewController alloc] init];
	
	
    [[self navigationController] pushViewController:trailDetailController animated:YES];
	
    [trailDetailController release];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"lol");
	FirstViewController *trailDetailController = [[FirstViewController alloc] init];
	
	
    [[self navigationController] pushViewController:trailDetailController animated:YES];
	
    [trailDetailController release];
	
}
*/



- (IBAction)add {	
	AddCourse *addcourse  = [[AddCourse alloc] init];
	addcourse.delegate = self;
	[self presentModalViewController:addcourse animated:YES];	
}

- (void) updateCourses:(NSString *)string {
	
	[self.courses addObject:string];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.courses forKey:@"courses"];		
	[defaults synchronize];
	[self.table reloadData];
}

- (void)dealloc {
	[courses release];
		[table release];
    [super dealloc];
}


@end
