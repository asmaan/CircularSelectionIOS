//
//  ViewController.m
//  CircularSelectionIOS
//
//  Created by A S Maan on 6/14/15.
//  Copyright (c) 2015 ASMaan. All rights reserved.
//


#import "AMCircularControl.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )
@interface AMCircularControl(){
    UITextField *_textField;
    int radius;
    UIImageView *baseDial;
}
@end
@implementation AMCircularControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        
        //Define the circle radius taking into account the safe area
//        radius = self.frame.size.width/2 - TB_SAFEAREA_PADDING;
        
        //Initialize the Angle at 0
        self.angle = 360;
        
        
        //Define the Font
//        UIFont *font = [UIFont systemFontOfSize:10.0f];
        //Calculate font size needed to display 3 numbers
//        CGSize fontSize = CGSizeMake(100, 20);
//        
//        //Using a TextField area we can easily modify the control to get user input from this field
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(frame.origin.x,
                                                                  frame.origin.y+30,
                                                                  frame.size.width,
                                                                  30)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor redColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.text = [NSString stringWithFormat:@"%d",self.angle];
        _textField.enabled = NO;
        UIImageView *base = [[UIImageView alloc] initWithFrame:frame];
        [base setUserInteractionEnabled:NO];
        [base setImage:[UIImage imageNamed:@"dial-base"]];
        baseDial = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+42,frame.origin.y+42,AM_DIALER_SIZE,AM_DIALER_SIZE)];
        [baseDial setImage:[UIImage imageNamed:@"dial"]];
        [baseDial setUserInteractionEnabled:NO];
        [_textField setUserInteractionEnabled:NO];
        [self addSubview:base];
        [self addSubview:baseDial];
        [self bringSubviewToFront:baseDial];
        [self addSubview:_textField];
    }
    
    return self;
}
#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}

-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);

    //Store the new angle
    self.angle = 360 - angleInt;
    float temp = ToRad(self.angle);
    temp = temp - 2.0;
    [UIView animateWithDuration:1.0 animations:^{
        [baseDial setTransform:CGAffineTransformMakeRotation((temp*-1))];
    }];

    //Update the textfield
    _textField.text =  [NSString stringWithFormat:@"%d", self.angle];
    //Redraw
    [self setNeedsDisplay];
}

/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - TB_LINE_WIDTH/2, self.frame.size.height/2 - TB_LINE_WIDTH/2);
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    
    return result;
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end
