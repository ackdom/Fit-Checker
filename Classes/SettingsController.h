//
//  SettingsController.h
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCourse.h"


@interface SettingsController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddCourseDelegate> {
	
	IBOutlet UITableView *table;	
	NSMutableArray *courses;
}

- (IBAction)add;

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) NSMutableArray *courses;

@end
