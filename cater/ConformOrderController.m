//
//  ConformOrderController.m
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "ConformOrderController.h"
#import "UIViewController+Strong.h"
#import <QuartzCore/QuartzCore.h>
#import "UserDataManager.h"
@interface ConformOrderController (){
    NSMutableDictionary *dictionary;
    
    UIDatePicker *datePicker;
    //底部导航栏
    UIToolbar *toolbar;
    //显示时间
    UITextField *timeField;
    //用餐人数
    UITextField *peopleNumField;
    //给商家留言
    UITextView *messageTextView;
    //取消按钮
    UIBarButtonItem *cancelBtn;
    //确定按钮
    UIBarButtonItem *sureBtn;
}
@end

@implementation ConformOrderController
-(void)afterLoadView{
    self.grouped = YES;
    [super afterLoadView];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    
    //改变tableView的背景
    self.tableView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"buy_car_bg"]];
    self.tableView.backgroundView =nil;
    
    dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSArray arrayWithObjects:@"",nil],int2str(0), [NSArray arrayWithObjects:@"客户信息：", @"联系方式：",@"用餐人数：",nil],int2str(1),[NSArray arrayWithObjects:@"就餐地点：",@"到店时间：", nil],int2str(2),[NSArray arrayWithObjects:@"共点菜：",@"总计：", nil],int2str(3),[NSArray arrayWithObjects:@"", nil],int2str(5),[NSArray arrayWithObjects:@"", nil],int2str(4), nil];
    [self.tableView reloadData];
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//监听返回
- (void) buttonClick:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 实现父类的方法
- (NSInteger)numberOfSections{
    return [dictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictionary objectForKey:int2str(section)] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"商家提示";
    }else if (section == 1) {
        return @"联系人信息";
    } else if (section == 2) {
        return @"餐厅信息";
    } else if (section == 3) {
        return @"点菜信息";
    }else if (section == 4) {
        return @"给商家留言";
    }
    return @"";
}
#pragma mark - Table view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (datePicker) {
        [self startAnimation:datePicker frame:CGRectMake(0,IPHONE_HEIGHT,IPHONE_WIDTH, datePicker.frame.size.height) delegate:self action:@selector(animationFinished)];
        [self startAnimation:toolbar frame:CGRectMake(0,IPHONE_HEIGHT,IPHONE_WIDTH, toolbar.frame.size.height) delegate:self action:@selector(animationFinished)];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    if (section == 2 && row == 1) {
        if (datePicker)return;
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; 
        CGPoint offset = self.tableView.contentOffset;
        if (offset.y < 308) {
            [self.tableView setContentOffset:CGPointMake(0, 308) animated:YES];
        }
        [self createDatePicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [self initCell:indexPath];
    [self renderCell:cell indexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4 || indexPath.section == 0) {
        return 100;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
#pragma mark - 初始化cell
- (UITableViewCell *)initCell:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    int row = indexPath.row;
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:IDENTIFIER] autorelease];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = GLOBAL_FONT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (section == 0) { //商家提示
        UITextView *textView=[[[UITextView alloc] initWithFrame:CGRectMake(ZERO,ZERO,cell.frame.size.width - 30, 100)] autorelease];
        textView.showsVerticalScrollIndicator = NO;
        textView.editable = NO;
        textView.text = @"俏江南LOGO中的脸谱取自于川剧变脸人物刘宗敏，他是李自成手下的大将军，勇猛彪捍，机智过人，被民俏江南LOGO[1]间百姓誉为武财神，寓意招财进宝，驱恶辟邪，而俏江南选用经过世界著名平面设计大师再创作的此脸谱为公司LOGO，旨在用现代的精神去继承和光大中国五千年悠久的美食文化，并在公司成长过程中通过智慧，勇气，意志力去打造中国餐饮行业的世界品牌。";
        [textView.layer setShadowColor:[UIColor whiteColor].CGColor];
        [textView.layer setShadowOffset:CGSizeMake(.6, .6)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setFont:GLOBAL_FONT];
        [cell.contentView addSubview:textView];
    }else if (section == 1) { //联系人信息
        if (row != 2) {
             UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-120, cell.frame.size.height) text:@"潘康醒" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
            textField.enabled = NO;
            if (row == 1) {
                textField.text = @"13554867904";
            }
             [cell.contentView addSubview:textField];
        } else {
            peopleNumField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-120, cell.frame.size.height) text:@"6" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
            peopleNumField.delegate = self;
            peopleNumField.placeholder = @"请填写";
            peopleNumField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:peopleNumField];
        }
       
    } else if (section == 2) { //餐厅信息
        if (row == 0) {
            UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"聚牛叉公司" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
            textField.enabled = NO;
            [cell.contentView addSubview:textField];
        } else {
            timeField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
            timeField.enabled = NO;
            timeField.delegate = self;
            timeField.placeholder = @"请选择";
            
            NSDate *date = [ NSDate date];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:date];
            [dateFormatter release];
            timeField.text = currentDateStr;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:timeField];
        }
    } else if (section == 3) { //点菜信息
        NSString *text = row == 0?[NSString stringWithFormat:@"%d 道",[UserDataManager totalCount]]:[NSString stringWithFormat:@"%.2f元",[UserDataManager totalPrice]];
        UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:text tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
        textField.enabled = NO;
        [cell.contentView addSubview:textField];
    } else if (section == 5){ //确定下单
        UIButton *button =  [self createButton:CGRectMake(ZERO,ZERO,300, BAR_HEIGHT) title:@"付  款" normalImage:@"pay_button_normal" hightlightImage:@"pay_button_pressed" controller:self selector:@selector(btnClick:) tag:ZERO];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:button];
    } else if (section == 4){
        messageTextView=[[[UITextView alloc] initWithFrame:CGRectMake(ZERO,ZERO,cell.frame.size.width - 30, 100)] autorelease];
        messageTextView.delegate = self;
        messageTextView.showsVerticalScrollIndicator = NO;
        [messageTextView.layer setShadowColor:[UIColor whiteColor].CGColor];
        [messageTextView.layer setShadowOffset:CGSizeMake(.6, .6)];
        [messageTextView setBackgroundColor:[UIColor clearColor]];
        [messageTextView setFont:GLOBAL_FONT];
        messageTextView.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:messageTextView];
    }
    return cell;
}
//监听确认下单
-(void)btnClick:(UIButton *)button{
    [self.navigationController pushViewController:[self getControllerFromClass:@"PayController" title:@"付款"] animated:YES];
}

#pragma mark - 创建时间选择器
-(void)createDatePicker{
    // 初始化UIDatePicker
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, IPHONE_WIDTH, 216)];
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.view addSubview:datePicker];
    [datePicker release];
    
    //底部导航栏
    toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 156,
                                                                    [[UIScreen mainScreen] bounds].size.width, BAR_HEIGHT)] autorelease];
    toolbar.barStyle = UIBarStyleBlack;
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    //取消按钮
    cancelBtn = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(barItemClick:)] autorelease] ;
    
    //确定按钮
    sureBtn = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonSystemItemCancel target:self action:@selector(barItemClick:)] autorelease] ;
    [items addObject:cancelBtn];
    [items addObject:flexItem];
    [items addObject:sureBtn];
    
    [toolbar setItems:items];
    [self.view addSubview:toolbar];
}
- (void)barItemClick:(UIBarButtonItem *)item{
    if (item == sureBtn) {
        NSDate *date = datePicker.date;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        timeField.text = currentDateStr;
    }
    [self startAnimation:datePicker frame:CGRectMake(0,IPHONE_HEIGHT,IPHONE_WIDTH, datePicker.frame.size.height) delegate:self action:@selector(animationFinished)];
    [self startAnimation:toolbar frame:CGRectMake(0,IPHONE_HEIGHT,IPHONE_WIDTH, toolbar.frame.size.height) delegate:self action:@selector(animationFinished)];
    
}
#pragma mark - 动画结束执行
-(void)animationFinished{
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = nil;
    datePicker = nil;
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    int section = [indexPath section];
    int row = [indexPath row];
    NSArray *array = [dictionary objectForKey:int2str(section)];
    cell.textLabel.text = [array objectAtIndex:row];
}
#pragma mark - uitextfield delegate 方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint offset = self.tableView.contentOffset;
    if (textField == peopleNumField) {
        if (offset.y < 128) {
            [self.tableView setContentOffset:CGPointMake(0, 128) animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
#pragma mark - uitextview delegate 方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.tableView setContentOffset:CGPointMake(0, 580) animated:YES];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self.tableView setContentOffset:CGPointMake(0, 410) animated:YES];
        return NO;
    }
    return YES;
}
-(void) dealloc{
    [dictionary release];
    dictionary = nil;
    [super dealloc];
}
@end
