//
//  ProfileViewController.m
//  Appointment
//
//  Created by Alex Ushakov on 02/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "ProfileViewController.h"
#import "Passport.h"
#import "ProfileCell.h"

@interface ProfileViewController () <UITextFieldDelegate>

@property (nonatomic, strong) Passport *passport;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.passport = [[Passport alloc] init];
    self.passport.name = @"Alex";
    self.passport.surname = @"Ushakov";
    self.passport.phoneNumber = @"+7(905) 337-51-79";
    self.passport.jobTitle = @"iOS Developer";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProfileCell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0)
    {
        if(row == 0)
        {
            cell.textLabel.text = @"Name:";
            cell.textField.text = self.passport.name;
        }
        else
        {
            cell.textLabel.text = @"Surname:";
            cell.textField.text = self.passport.surname;
        }
    }
    else
    {
        if(row == 0)
        {
            cell.textLabel.text = @"Phone:";
            cell.textField.text = self.passport.phoneNumber;
        }
        else
        {
            cell.textLabel.text = @"Job Title:";
            cell.textField.text = self.passport.jobTitle;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Personal Information";
    }
    else
    {
        return @"Job";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
