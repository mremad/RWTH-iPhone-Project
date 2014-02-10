//
//  ScheduleViewController.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ScheduleViewController.h"

#define ViewContentHeight (TIME_HEIGHT*(24-4))
#define SLIDER_VIEW_START_POSITION DAY_HEIGHT
#define ViewContentXStart 64 + SLIDER_VIEW_START_POSITION



@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
{
    
    UILabel * dayLabels[NUMBER_DAYS];
    UIView  * verticalLineLabels[NUMBER_DAYS];
    CGPoint dayLabelOriginalPositions[NUMBER_DAYS];
    
    SlotStatus fullSchedule[NUMBER_WEEKS][NUMBER_DAYS][NUMBER_HOURS*4]; //TODO: increase schedule to accommodate for more weeks not a single one
    BOOL createdSchedules[NUMBER_WEEKS];
    SlotStatus dummySchedule[NUMBER_DAYS][NUMBER_HOURS*4]; //TODO: to be removed after implementing the fullschedule with week support

    NSMutableDictionary* allWeeksSchedules;
    
    ScheduleScrollView* bufferedSchedules[NUM_BUFFERED_SCHEDULES];
    
    NSMutableArray* availableWeeks;
    NSInteger currentDisplayedWeekNum;
    
    UIView* loadingView;
    UIActivityIndicatorView* loadingIndicator;

}

-(void) shakeGroupCreationActionRecieved:(NSInteger)groupID
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)addWeekLabels
{
    self.view.opaque = NO;
    self.view.clipsToBounds = YES;
    
    
    
    NSArray *weekDays = @[@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa",@"Su"];
    for(int i=0;i<NUMBER_DAYS;i++)
    {
        UILabel *label =[[UILabel alloc] init];
        label.text=[NSString stringWithFormat:@"%@", [weekDays objectAtIndex:i]];
        label.bounds = CGRectMake(0,0 ,DAY_WIDTH, DAY_HEIGHT);
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.center=CGPointMake(DAY_STARTING_CENTER_POINT+i*((int)DAY_WIDTH) + DAY_WIDTH/4,UIVIEWS_STARTING_YPOSITION+ (DAY_HEIGHT/2));
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        label.textColor = [UIColor colorWithHue:29 saturation:100 brightness:100 alpha:1];
        dayLabels[i] = label;
        dayLabelOriginalPositions[i] = label.center;
        [self.view addSubview:label];
        
        CGFloat borderWidth = 0.5;
        UIColor *borderColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.6 alpha:0.7];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(TIME_WIDTH +i*((int)DAY_WIDTH),UIVIEWS_STARTING_YPOSITION+(DAY_HEIGHT/2),borderWidth,self.view.frame.size.height-14)];
        topView.opaque = YES;
        topView.backgroundColor = borderColor;
        verticalLineLabels[i] = topView;
        [self.view addSubview:topView];
        
    }
    
    CGFloat borderWidth = 0.5;
    UIColor *borderColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.6 alpha:0.7];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.layer.bounds.size.width-14, borderWidth)];
    topView.center = CGPointMake(self.view.frame.size.width/2,UIVIEWS_STARTING_YPOSITION+ (DAY_HEIGHT));
    topView.opaque = YES;
    topView.backgroundColor = borderColor;
    [self.view addSubview:topView];
}

-(void) displaySchedule
{
    availableWeeks = [[NSMutableArray alloc] initWithObjects:nil];
    allWeeksSchedules = [[NSMutableDictionary alloc] initWithObjects:nil forKeys:nil];
    //set scrollView
    
    [self setAvailableWeeks];
    
    for(int i = 0;i<NUM_BUFFERED_SCHEDULES;i++)
    {
        
        [self createScheduleForWeek:[[availableWeeks objectAtIndex:i] integerValue]];
        
        bufferedSchedules[i] = [[ScheduleScrollView alloc] initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)
                                                            withSchedule:fullSchedule[[[availableWeeks objectAtIndex:i] integerValue]]];
        
        bufferedSchedules[i].contentSize = CGSizeMake(320, ViewContentHeight);
        bufferedSchedules[i].delegate = (id)self;
        bufferedSchedules[i].backgroundColor=[UIColor clearColor];
        
        
        if(i == ((int)(NUM_BUFFERED_SCHEDULES/2)))
        {
            
            _scrollView = bufferedSchedules[i];
            [self.view addSubview:_scrollView];
            
            currentDisplayedWeekNum = i;
        }
        
        
        for(int j = 0;j<NUMBER_DAYS;j++)
        {
            [bufferedSchedules[i] setDayLabel:dayLabels[j] forIndex:j];
            [bufferedSchedules[i] setVerticalLineLabel:verticalLineLabels[j] forIndex:j];
            [bufferedSchedules[i] setDayLabelOriginalPosition:dayLabelOriginalPositions[j] forIndex:j];
        }
    }
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:swipeRight];
    [[self view] addGestureRecognizer:swipeLeft];
    
    NSDate* randDate = ((Slot*)[[allWeeksSchedules objectForKey:[NSNumber numberWithInt:[[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue]]] objectAtIndex:0]).startTime;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:randDate];
    
    [comps setWeekday:2];
    NSDate* firstDayOfTheWeek = [calendar dateFromComponents:comps];
    
    [comps setWeekday:7];
    NSDate* lastDayOfTheWeek = [calendar dateFromComponents:comps];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* title = [NSString stringWithFormat:@"%@ <-> %@",[dateFormatter stringFromDate:firstDayOfTheWeek],[dateFormatter stringFromDate:lastDayOfTheWeek]];
    
    [self.navigationItem setTitle:title];

}

-(void)scheduleFinishedLoading
{
    [loadingIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [loadingView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    [loadingIndicator performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(displaySchedule) withObject:nil waitUntilDone:NO];
    
    self.view.userInteractionEnabled = YES;
}

-(void) initSchedule
{
    [self addWeekLabels];
    
    self.view.userInteractionEnabled = NO;
    
    loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor grayColor];
    loadingView.alpha = 0.5;
    [self.view addSubview:loadingView];
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    for(int i = 0;i<NUMBER_WEEKS;i++)
    {
        createdSchedules[i] = FALSE;
        
        for(int j = 0;j<NUMBER_DAYS;j++)
            for(int k = 0;k<NUMBER_HOURS*4;k++)
                fullSchedule[i][j][k] = SlotStateFree;
    }
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ServerConnection sharedServerConnection].delegatenotificationsView = self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initSchedule];
    
    
}

-(void)switchViewsToLeft
{
    ScheduleScrollView* oldScrollView = _scrollView;
    
 
   
    if(currentDisplayedWeekNum == [availableWeeks count] - 1)
        return;
    
    for(int i = 0;i<NUM_BUFFERED_SCHEDULES;i++)
    {
        if(i == NUM_BUFFERED_SCHEDULES-1)
            bufferedSchedules[i] = nil;
        else
            bufferedSchedules[i] = bufferedSchedules[i+1];
    }
    
    currentDisplayedWeekNum++;
   
    int weekNum = [[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue];
    
    if(!createdSchedules[weekNum])
        [self createScheduleForWeek:weekNum];
    
    if(currentDisplayedWeekNum < [availableWeeks count]-1)
    {
        int buffWeekNum = [[availableWeeks objectAtIndex:currentDisplayedWeekNum+1] intValue];
        
        if(!createdSchedules[buffWeekNum])
            [self createScheduleForWeek:buffWeekNum];
        
        bufferedSchedules[NUM_BUFFERED_SCHEDULES-1] = [[ScheduleScrollView alloc]
                                                       initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)
                                                       withSchedule:fullSchedule[buffWeekNum]];
        
        bufferedSchedules[NUM_BUFFERED_SCHEDULES-1].contentSize = CGSizeMake(320, ViewContentHeight);
        bufferedSchedules[NUM_BUFFERED_SCHEDULES-1].delegate = (id)self;
        bufferedSchedules[NUM_BUFFERED_SCHEDULES-1].backgroundColor=[UIColor clearColor];
        for(int j = 0;j<NUMBER_DAYS;j++)
        {
            [bufferedSchedules[NUM_BUFFERED_SCHEDULES-1] setDayLabel:dayLabels[j] forIndex:j];
            [bufferedSchedules[NUM_BUFFERED_SCHEDULES-1] setVerticalLineLabel:verticalLineLabels[j] forIndex:j];
            [bufferedSchedules[NUM_BUFFERED_SCHEDULES-1] setDayLabelOriginalPosition:dayLabelOriginalPositions[j] forIndex:j];
        }
    }
    
    _scrollView = bufferedSchedules[((int)(NUM_BUFFERED_SCHEDULES/2))];
    

    
    [UIView transitionFromView:oldScrollView toView:_scrollView duration:0.5 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL res){ }];
    
    NSDate* randDate = ((Slot*)[[allWeeksSchedules objectForKey:[NSNumber numberWithInt:[[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue]]] objectAtIndex:0]).startTime;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:randDate];
    
    [comps setWeekday:2];
    NSDate* firstDayOfTheWeek = [calendar dateFromComponents:comps];
    
    [comps setWeekday:7];
    NSDate* lastDayOfTheWeek = [calendar dateFromComponents:comps];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* title = [NSString stringWithFormat:@"%@ <-> %@",[dateFormatter stringFromDate:firstDayOfTheWeek],[dateFormatter stringFromDate:lastDayOfTheWeek]];
    
    [self.navigationItem setTitle:title];
    
    
    //TODO: update the fullschedule accordingly and fetch more weeks
    
    
}

-(void)switchViewsToRight
{
    
    ScheduleScrollView* oldScrollView = _scrollView;
    

    
    
    if(currentDisplayedWeekNum == 0)
        return;
    for(int i = NUM_BUFFERED_SCHEDULES-1;i>=0;i--)
    {
        if(i == 0)
            bufferedSchedules[i] = nil;
        else
            bufferedSchedules[i] = bufferedSchedules[i-1];
    }
    currentDisplayedWeekNum--;
   
    int weekNum = [[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue];
    
    if(!createdSchedules[weekNum])
        [self createScheduleForWeek:weekNum];
    
    if(currentDisplayedWeekNum > 0)
    {
        int buffWeekNum = [[availableWeeks objectAtIndex:currentDisplayedWeekNum-1] intValue];
        
        if(!createdSchedules[buffWeekNum])
            [self createScheduleForWeek:buffWeekNum];
        
        bufferedSchedules[0] = [[ScheduleScrollView alloc]
                                                       initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)
                                                       withSchedule:fullSchedule[buffWeekNum]];
        
        bufferedSchedules[0].contentSize = CGSizeMake(320, ViewContentHeight);
        bufferedSchedules[0].delegate = (id)self;
        bufferedSchedules[0].backgroundColor=[UIColor clearColor];
        
        for(int j = 0;j<NUMBER_DAYS;j++)
        {
            [bufferedSchedules[0] setDayLabel:dayLabels[j] forIndex:j];
            [bufferedSchedules[0] setVerticalLineLabel:verticalLineLabels[j] forIndex:j];
            [bufferedSchedules[0] setDayLabelOriginalPosition:dayLabelOriginalPositions[j] forIndex:j];
        }
    }
    
    _scrollView = bufferedSchedules[((int)(NUM_BUFFERED_SCHEDULES/2))];
    
    [UIView transitionFromView:oldScrollView toView:_scrollView duration:0.5 options:UIViewAnimationOptionTransitionCurlDown completion:nil];
    
    NSDate* randDate = ((Slot*)[[allWeeksSchedules objectForKey:[NSNumber numberWithInt:[[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue]]] objectAtIndex:0]).startTime;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:randDate];
    
    [comps setWeekday:2];
    NSDate* firstDayOfTheWeek = [calendar dateFromComponents:comps];
    
    [comps setWeekday:7];
    NSDate* lastDayOfTheWeek = [calendar dateFromComponents:comps];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* title = [NSString stringWithFormat:@"%@ <-> %@",[dateFormatter stringFromDate:firstDayOfTheWeek],[dateFormatter stringFromDate:lastDayOfTheWeek]];
    
    [self.navigationItem setTitle:title];
    
    
    //TODO: update the fullschedule accordingly and fetch more weeks
}

-(void)leftSwipe:(UISwipeGestureRecognizer*)sender
{
    [self switchViewsToLeft];
}

-(void)rightSwipe:(UISwipeGestureRecognizer*)sender
{
    [self switchViewsToRight];
}

- (void)reserveMeetingAtStartingHour:(int)startingHour
                         startingMin:(int)startingMin
                          endingHour:(int)endingHour
                           endingMin:(int)endingMin
                                 day:(Day)meetingDay
{
    
    BOOL selectedFreeArea = TRUE;
    
    int startIndex = ((startingHour - STARTING_HOUR)*4) + (startingMin/15);
    int endIndex = ((endingHour - STARTING_HOUR)*4) + (endingMin/15);
    
    int weekNum = [[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue];
    
    for(int i = startIndex;i<=endIndex;i++)
    {
        if(fullSchedule[weekNum][(int)meetingDay][i] == SlotStateBusy || fullSchedule[weekNum][(int)meetingDay][i] == SlotStateMeeting)
        {
            selectedFreeArea = FALSE;
            break;
        }
    }
    
    if(!selectedFreeArea)
        return;
    
     NSDate* randDate = ((Slot*)[[allWeeksSchedules objectForKey:[NSNumber numberWithInt:[[availableWeeks objectAtIndex:currentDisplayedWeekNum] intValue]]] objectAtIndex:0]).startTime;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* comps = [gregorian components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:randDate];
    
    [comps setWeekday:2];
    NSDate* firstDayOfTheWeek = [gregorian dateFromComponents:comps];
    NSDateComponents *firstDayComponents =[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |NSWeekdayCalendarUnit) fromDate:firstDayOfTheWeek];
    
    NSInteger year = [firstDayComponents year];
    NSInteger month = [firstDayComponents month];
    NSInteger randDay = [firstDayComponents day];
    
    randDay += meetingDay;
    
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            if(randDay > 31)
            {
                randDay -= 31;
                month++;
                if(month>12)
                {
                    month = 1;
                    year++;
                }
            }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            if(randDay > 30)
            {
                randDay -= 30;
                month++;
                if(month>12)
                {
                    month = 1;
                    year++;
                }
            }
            break;
        case 2:
            if(randDay > 28)
            {
                randDay -= 28;
                month++;
                if(month>12)
                {
                    month = 1;
                    year++;
                }
            }
            break;
            break;
        default:
            break;
    }
    
    NSLog(@"Start Date: %d %d %d %d:%d",year,month,randDay,startingHour,startingMin);
    NSLog(@"End Date: %d %d %d %d:%d",year,month,randDay,endingHour,endingMin);


    NSDateComponents *comp =[[NSDateComponents alloc] init];
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:randDay];
    [comp setHour:startingHour];
    [comp setMinute:startingMin];
    // [comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *startingDate =[gregorian dateFromComponents:comp];
    
    NSDateComponents *compEnd =[[NSDateComponents alloc] init];
    [compEnd setYear:year];
    [compEnd setMonth:month];
    [compEnd setDay:randDay];
    [compEnd setHour:endingHour];
    [compEnd setMinute:endingMin];
    //[compEnd setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *endingDate =[gregorian dateFromComponents:compEnd];
    
    ServerConnection* sharedConnection = [ServerConnection sharedServerConnection];
    [sharedConnection createMeeting:[sharedConnection getGroupGivenGroupId:_groupID] fromTimeSlot:startingDate toTimeSlot:endingDate];
    
    for(int i = startIndex;i<=endIndex;i++)
    {
        fullSchedule[weekNum][(int)meetingDay][i] = SlotStateMeeting;
    }
    
    [_scrollView updateViewForNewMeeting];
    
}

- (void)setAvailableWeeks
{
    ServerConnection* sharedConnection = [ServerConnection sharedServerConnection];
    NSMutableArray* schedToDisplay = [sharedConnection getGroupGivenGroupId:_groupID].groupSchedule;

    
    BOOL inserted = false;
    for(Slot* slot in schedToDisplay)
    {
        inserted = false;
        
        NSNumber* weekNumObj = [NSNumber numberWithInt:slot.weekNum];
        
        NSMutableArray* weekSlots = [allWeeksSchedules objectForKey:weekNumObj];
        
        if(weekSlots)
        {
            [weekSlots addObject:slot];
        }
        else
        {
            weekSlots = [[NSMutableArray alloc] initWithObjects:slot, nil];
            [allWeeksSchedules setObject:weekSlots forKey:weekNumObj];
        }
        
        if([availableWeeks indexOfObject:[NSNumber numberWithInt:slot.weekNum]] == NSNotFound)
        {
            for(int i = 0;i<[availableWeeks count];i++)
            {
                if(slot.weekNum < [[availableWeeks objectAtIndex:i] intValue])
                {
                    [availableWeeks insertObject:[NSNumber numberWithInt:slot.weekNum] atIndex:i];
                    inserted = true;
                    break;
                }
            }
            
            if(!inserted)
                [availableWeeks addObject:[NSNumber numberWithInt:slot.weekNum]];
        }
        
        
        
        
    }
    
    
}

- (void)createScheduleForWeek:(int)weekNum
{
    

    NSMutableArray* schedToDisplay = [allWeeksSchedules objectForKey:[NSNumber numberWithInt:weekNum]];
    
    for(Slot* slot in schedToDisplay)
    {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:slot.startTime];
        
        int hour = [components hour];
        int minute = [components minute];
        
        
        
        int hourIndex = ((hour - STARTING_HOUR)*4) + (minute/15);
        int dayIndex = (int)slot.day;
        
        
        
        SlotStatus slotStatus = slot.slotStatus;
        
        fullSchedule[weekNum][dayIndex][hourIndex] = slotStatus;
        
        
    }
    
    createdSchedules[weekNum] = TRUE;
    

}

- (void) cancelMeetingAtDay:(NSDate*)meetingDate
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
