//
//  ContactVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 15/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "ContactVC.h"
#define MAX_LENGTH 500
@interface ContactVC ()
{
    NSMutableString *strTextViewContent;
}
@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    strTextViewContent = MString;
    [self.titleLabel setText:self.titleStr];
    [self initVC];
    
    [self.headerView setBackgroundColor:THEME_BG_COLOR];
    [self.doneButton setBackgroundColor:THEME_BG_COLOR];
}
-(void) initVC{
    self.sectionArray = [[NSMutableArray alloc] initWithObjects:@"From",@"Reason for contacting TestSqliteToReplaceContento",@"Message", nil];
    self.textFieldArray=[[NSMutableArray alloc] initWithObjects:@"Name",@"Email",@"Company",  nil];
    self.textViewArray=[[NSMutableArray alloc] initWithObjects:@"Comment", nil];
    //NSArray *pickerArray=[[NSArray alloc] initWithObjects: nil];
    
    self.pickerArray=[[NSMutableArray alloc] initWithObjects:@"Media Query or Conferences",@"Publication Request",@"Client-Server Inquiry",@"Other", nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionArray objectAtIndex:section];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.textFieldArray count];
    }
    else if (section==1) {
        return 1;
    }
    else if (section==2) {
        return [self.textViewArray count];
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        //
        CellTextField *cell=[tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        if(cell == nil)
        {
            cell = (CellTextField *) [[CellTextField alloc
                                       ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
        }
        
        [cell.inputField setPlaceholder:[self.textFieldArray objectAtIndex:indexPath.row]];
        cell.inputField.tag=(indexPath.row+11) + ((indexPath.row+11)*100);
        return cell;
    }
    else if (indexPath.section==2) {
        //
        CellTextView *cell=[tableView dequeueReusableCellWithIdentifier:@"textViewCell"];
        if(cell == nil)
        {
            cell = (CellTextView *) [[CellTextView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textViewCell"];
            
        }
        cell.inputField.delegate=self;
        cell.inputField.tag=10011;
        return cell;
    }
    else if (indexPath.section==1) {
        //
        CellPickerView *cell=[tableView dequeueReusableCellWithIdentifier:@"pickerViewCell"];
        if(cell == nil)
        {
            cell = (CellPickerView *) [[CellPickerView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickerViewCell"];
            
        }
        cell.pickerView.tag=20022;
        cell.pickerView.delegate=self;
        cell.pickerView.dataSource=self;
        return cell;
    }
    else{
        return [[UITableViewCell alloc] init];
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerArray count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerArray objectAtIndex:row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 44.0;
    }
    else if(indexPath.section==1){
        return 128.0;
    }
    else if(indexPath.section==2){
        return 165.0;
    }
    else{
        return 44.0;
    }
}
-(IBAction)btndoneMenu:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
-(IBAction)btndone:(id)sender{
    @try{
        BOOL isValid=true;
        NSString *name=@"", *email=@"",*company=@"",*subject=@"",*message=@"";
        for (int i=0; i<[self.textFieldArray count]; i++) {
            UITextField *temptextField=(UITextField *)[self.view viewWithTag:((i+11) + ((i+11)*100))];
            if(i==1){
                
                if (![Validations isValidEmail:temptextField.text ] && ![Validations checkMinLength:temptextField.text withLimit:4]) {
                    [Globals ShowAlertWithTitle:@"Error" Message:[NSString stringWithFormat:@"Please enter valid %@",[self.textFieldArray objectAtIndex:i]]];
                    isValid=false;
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    CellTextField *cell1=[self.tableView cellForRowAtIndexPath:indexPath];
                    [cell1.img setImage:[UIImage imageNamed:@"btnuncheck"]  ];
                    break;
                }
                else{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    CellTextField *cell1=[self.tableView cellForRowAtIndexPath:indexPath];
                    [cell1.img setImage:[UIImage imageNamed:@"btncheck"]  ];
                    email=temptextField.text;
                }
            }
            else if (![Validations isValidUnicodeName:temptextField.text ] && ![Validations checkMinLength:temptextField.text withLimit:4] && isValid) {
                [Globals ShowAlertWithTitle:@"Error" Message:[NSString stringWithFormat:@"Please enter valid %@",[self.textFieldArray objectAtIndex:i]]];
                isValid=false;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                CellTextField *cell1=[self.tableView cellForRowAtIndexPath:indexPath];
                [cell1.img setImage:[UIImage imageNamed:@"btnuncheck"]  ];
                break;
            }
            
            else if (!isValid){
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                CellTextField *cell1=[self.tableView cellForRowAtIndexPath:indexPath];
                [cell1.img setImage:[UIImage imageNamed:@"btnuncheck"]  ];
            }
            else{
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                CellTextField *cell1=[self.tableView cellForRowAtIndexPath:indexPath];
                [cell1.img setImage:[UIImage imageNamed:@"btncheck"]  ];
                if (i==0) {
                    name=temptextField.text;
                }
                if (i==2) {
                    company=temptextField.text;
                }
            }
        }
        UITextView *tempTextView=(UITextView *)[self.view viewWithTag:10011];
        tempTextView.delegate=self;
        
        if(!isValid){
            //        [self dismissViewControllerAnimated:YES completion:^{
            //            //
            //        }];
            return;
        }
        if (![Validations checkMinLength:tempTextView.text withLimit:10  ]) {
            [Globals ShowAlertWithTitle:@"Error" Message:[NSString stringWithFormat:@"Please enter valid %@",[self.textViewArray objectAtIndex:0]]];
            isValid=false;
        }
        UIPickerView *tempPickerView=(UIPickerView *)[self.view viewWithTag:20022];
        
        subject = [self.pickerArray objectAtIndex:[tempPickerView selectedRowInComponent:0]];
        if (isValid) {
            //
            Globals *sharedManager=[Globals sharedManager];
            CellTextView *cell1=(CellTextView *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
            message=cell1.inputField.text;
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            if([sharedManager isNotNull:name] )
                [dic setObject:name forKey:@"name"];
            if([sharedManager isNotNull:subject] )
                [dic setObject:subject forKey:@"subject"];
            if([sharedManager isNotNull:message] )
                [dic setObject:message forKey:@"message"];
            if([sharedManager isNotNull:email] )
                [dic setObject:email forKey:@"email"];
            if([sharedManager isNotNull:company] )
                [dic setObject:company forKey:@"company"];
            
            [APICall callPostWebService:API_CONTACT_US andDictionary:dic withToken:sharedManager.user.token completion:^(NSMutableDictionary *result, NSError *error, long code) {
                //
                if ([[result valueForKey:@"success"] boolValue]) {
                    //Success
                    [self dismissViewControllerAnimated:YES completion:^{
                        //
                    }];
                    
                }
                else{
                    //Error
                    [Globals ShowAlertWithTitle:@"Error" Message:@"Could not send your message. Try again later"];
                }
            }];
        }
    }
    @catch (NSException *exception) {
        //
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if(newLength <= MAX_LENGTH)
    {
        [self.sectionArray setObject:[NSString stringWithFormat: @"Message %lu/%d",(unsigned long)newLength,MAX_LENGTH] atIndexedSubscript:2];
        
        [self.tableView beginUpdates];
        CGRect frame=[self.tableView headerViewForSection:2].textLabel.frame;
        [self.tableView headerViewForSection:2].textLabel.frame=CGRectMake(frame.origin.x, frame.origin.y, self.view.frame.size.width, frame.size.height);
        [self.tableView headerViewForSection:2].textLabel.text = [NSString stringWithFormat: @"Message %lu/%d",(unsigned long)newLength,MAX_LENGTH];
        [self.tableView endUpdates];
        
        return YES;
    } else {
        NSUInteger emptySpace = MAX_LENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        [Globals ShowAlertWithTitle:@"Warning" Message:@"The message should be 500 Characters."];

        return NO;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text length] < 500) {
        return true;
    }
    else{
        return false;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Your Comments"]) {
        textView.text=@"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text=@"Your Comments";
    }
}
-(IBAction)btnclose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
