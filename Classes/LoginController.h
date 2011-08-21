//
//  LoginController.h
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginController : UIViewController {
	
	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	IBOutlet UIButton *btnSave;
	

}

- (IBAction)save;

@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UIButton *btnSave;
@end
