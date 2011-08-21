//
//  AddCourse.h
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCourseDelegate

- (void) updateCourses:(NSString*)string;

@end


@interface AddCourse : UIViewController {
	
	id <AddCourseDelegate> delegate;
	IBOutlet UITextField *courseName;
	IBOutlet UISegmentedControl *program;

}


- (IBAction)save;
- (IBAction)close;
@property (nonatomic, retain) id <AddCourseDelegate> delegate;
@property (nonatomic, retain) UITextField *courseName;
@property (nonatomic, retain) UISegmentedControl *program;

@end
