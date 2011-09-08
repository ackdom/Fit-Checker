//
//  AboutController.m
//  fit-checker
//
//  Created by Dominik Veselý on 9/8/11.
//  Copyright 2011 CTU. All rights reserved.
//

#import "AboutController.h"


@implementation AboutController
@synthesize imageView;

- (void)dealloc
{
    [imageView release];
    [super dealloc];
}



#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)] autorelease];
    
    recognizer.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:recognizer];
    
    
    [super viewDidLoad];
}

- (void) imageTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.codingwalrus.com"]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
