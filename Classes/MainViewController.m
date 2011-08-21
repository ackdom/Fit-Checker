//
//  MainViewController.m
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import "MainViewController.h"
#import "DetailController.h"


@implementation MainViewController
@synthesize spinner;
@synthesize urlData;
@synthesize courses,spinView,_reload;



- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"FIT-Checker"];
	
	[[NSBundle mainBundle] loadNibNamed:@"Spinner" owner:self options:nil];
	[spinView setCenter:CGPointMake(320/2.0, 320/2.0)]; 		
	_reload = YES;
	
	
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *user = [defaults objectForKey:@"username"];
	NSString *pass = [defaults objectForKey:@"password"];
	if (pass == nil || user == nil) {
		UIViewController *vc = [[[self tabBarController] viewControllers] objectAtIndex:2];
		UITabBarController *tb = [self tabBarController];
		[tb setSelectedViewController:vc];	
		return;
		
	}
	self.courses = (NSMutableArray*) [defaults objectForKey:@"courses"];

	if (_reload) {
		[self createConnection];		
	}
	_reload = 1;
}
- (void)createConnection {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
	
	self.tableView.allowsSelection = NO;
	[self.view addSubview:spinView]; 		
	
	NSString* content = @"authnProvider=2&u=XX&p=YY" ;
	
	NSMutableString *firstString = [content mutableCopy];
	
	[firstString replaceOccurrencesOfString:@"XX" withString:[defaults objectForKey:@"username"] options:NSLiteralSearch range:NSMakeRange(0, [firstString length])];
	[firstString replaceOccurrencesOfString:@"YY" withString:[defaults objectForKey:@"password"] options:NSLiteralSearch range:NSMakeRange(0, [firstString length])];
		
	NSURL* url = [NSURL URLWithString:@"https://edux.fit.cvut.cz/start?do=login"];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	
	
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[firstString dataUsingEncoding: NSASCIIStringEncoding]];	
	
	[[NSHTTPCookieStorage sharedHTTPCookieStorage]
	 setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
	
	[[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	self.urlData = [NSMutableData dataWithLength:0];
	
	[content release];
	[firstString release];
	[urlRequest release];
		
		
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
	self.tableView.allowsSelection = YES;
	[spinView removeFromSuperview];
	
	
	NSMutableString *str = [[[NSMutableString alloc] initWithData:self.urlData encoding:NSUTF8StringEncoding] autorelease];	

	NSRange range = [str rangeOfString:@"Zadané uživatelské jméno a heslo není správně." options:NSCaseInsensitiveSearch];
	
	BOOL match = range.location != NSNotFound;
	

	if(match) {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Chyba přihlášení"
								   message: @"Špatně zadané jméno nebo heslo."
								  delegate: self
						 cancelButtonTitle: @"Změnit"
						 otherButtonTitles: nil];
		[alert show];
		[alert release];		
	}
	
   [self.tableView reloadData];
	
}
/*

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSLog(@"kkk");
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *user = [defaults objectForKey:@"username"];
	NSString *pass = [defaults objectForKey:@"password"];
	if (pass == nil || user == nil) {
		UIViewController *vc = [[[self tabBarController] viewControllers] objectAtIndex:2];
		UITabBarController *tb = [self tabBarController];
		[tb setSelectedViewController:vc];	
		return;

	}
}*/

-(void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse*)response
{
    [urlData setLength:0];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}

-(void)connection:(NSURLConnection *)connection
   didReceiveData:(NSData*)incrementalData
{
    [self.urlData appendData:incrementalData];
	
   
}




 - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
 
 DetailController *trailDetailController = [[DetailController alloc] initWithNibName:@"DetailController" bundle:nil];
 [trailDetailController setTitleString:[self.courses objectAtIndex:indexPath.row]];
	 [trailDetailController setMainController:self];	 

 
 [[self navigationController] pushViewController:trailDetailController animated:YES];
 
 [trailDetailController release];
 
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 DetailController *trailDetailController = [[DetailController alloc] initWithNibName:@"DetailController" bundle:nil];
	 [trailDetailController setTitleString:[self.courses objectAtIndex:indexPath.row]];
 	 [trailDetailController setMainController:self];	 

	 [[self navigationController] pushViewController:trailDetailController animated:YES]; 
	 [trailDetailController release];
 
 }
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [courses objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{	
	return nil;	
}

#pragma mark 

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
		
}

- (void)doneLoadingTableViewData{	
	
}





#pragma mark navigationController
/*
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{

}

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
 //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}
*/

#pragma mark AlertDelegate

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex {
	[self.tabBarController setSelectedIndex:2];
} 


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	[urlData release];
	[spinView release];
	[spinner release];
	[courses release];
    [super dealloc];
}


@end

