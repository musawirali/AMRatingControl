//
//  AMRatingControl.m
//  RatingControl
//


#import "AMRatingControl.h"


// Constants :
static const CGFloat kFontSize = 20;
static const NSInteger kStarWidthAndHeight = 20;
static const NSInteger kStarSpacing = 0;

static const NSString *kDefaultEmptyChar = @"☆";
static const NSString *kDefaultSolidChar = @"★";


@interface AMRatingControl (Private)

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;

- (void)adjustFrame;
- (void)handleTouch:(UITouch *)touch;

@end


@implementation AMRatingControl


/**************************************************************************************************/
#pragma mark - Getters & Setters
@synthesize emptyColor = _emptyColor;
@synthesize solidColor = _solidColor;
@synthesize emptyImage = _emptyImage;
@synthesize solidImage = _solidImage;
@synthesize rating = _rating;
@synthesize maxRating = _maxRating;
@synthesize starWidthOverride = _starWidthOverride;
@synthesize starFontSize = _starFontSize;
@synthesize starSpacing = _starSpacing;

- (void)setRating:(NSNumber *)rating
{
    _rating = [NSNumber numberWithInteger:MIN([self.maxRating integerValue], MAX(0, [rating integerValue]))];
    [self setNeedsDisplay];
}

- (void)setStarSpacing:(NSUInteger)starSpacing
{
    _starSpacing = starSpacing;
    [self adjustFrame];
    [self setNeedsDisplay];
}

/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:nil
                       solidImage:nil
                       emptyColor:nil
                       solidColor:nil
                     andMaxRating:maxRating];
}

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating
{
	return [self initWithLocation:location
                       emptyImage:emptyImageOrNil
                       solidImage:solidImageOrNil
                       emptyColor:nil
                       solidColor:nil
                     andMaxRating:maxRating];
}

- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:nil
                       solidImage:nil
                       emptyColor:emptyColor
                       solidColor:solidColor
                     andMaxRating:maxRating];
}


/**************************************************************************************************/
#pragma mark - View Lifecycle

- (void)drawRect:(CGRect)rect
{
	CGPoint currPoint = CGPointZero;
	
    NSInteger width;
	for (int i = 0; i < [self.rating integerValue]; i++)
	{
		if (_solidImage)
        {
            [_solidImage drawAtPoint:currPoint];
            width = _solidImage.size.width;
        }
		else
        {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), _solidColor.CGColor);
            [kDefaultSolidChar drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]];
            width = [kDefaultSolidChar sizeWithFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]].width;
        }
        if (self.starWidthOverride)
            width = [self.starWidthOverride integerValue];

		currPoint.x += (width + _starSpacing);
	}
	
	NSInteger remaining = [self.maxRating integerValue] - [self.rating integerValue];
	
	for (int i = 0; i < remaining; i++)
	{
		if (_emptyImage)
        {
			[_emptyImage drawAtPoint:currPoint];
            width = _emptyImage.size.width;
        }
		else
        {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), _emptyColor.CGColor);
			[kDefaultEmptyChar drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]];
            width = [kDefaultEmptyChar sizeWithFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]].width;
        }
        if (self.starWidthOverride)
            width = [self.starWidthOverride integerValue];

		currPoint.x += (width + _starSpacing);
	}
}


/**************************************************************************************************/
#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self handleTouch:touch];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self handleTouch:touch];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}


/**************************************************************************************************/
#pragma mark - Private Methods

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating
{
    
    NSInteger width = MAX([kDefaultEmptyChar sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize]].width, [kDefaultSolidChar sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize]].width);
    NSInteger height = MAX([kDefaultEmptyChar sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize]].height, [kDefaultSolidChar sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize]].height);
    
    if (emptyImageOrNil)
    {
        width = MAX(width, emptyImageOrNil.size.width);
        height = MAX(height, emptyImageOrNil.size.height);
    }
    if (solidImageOrNil)
    {
        width = MAX(width, solidImageOrNil.size.width);
        height = MAX(height, solidImageOrNil.size.height);
    }

    if (self = [self initWithFrame:CGRectMake(location.x,
                                              location.y,
                                              (maxRating * width),
                                              height)])
	{
		self.rating = [NSNumber numberWithInteger:0];
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		_emptyImage = emptyImageOrNil;
		_solidImage = solidImageOrNil;
        _emptyColor = emptyColor;
        _solidColor = solidColor;
        _maxRating = [NSNumber numberWithInteger:maxRating];
        _starFontSize = [NSNumber numberWithInteger:kFontSize];
        _starSpacing = kStarSpacing;
	}
	
	return self;
}

- (NSInteger)starWidth
{
    NSInteger width = MAX([kDefaultEmptyChar sizeWithFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]].width, [kDefaultSolidChar sizeWithFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]].width);

    if (_emptyImage)
        width = MAX(width, _emptyImage.size.width);

    if (_solidImage)
        width = MAX(width, _solidImage.size.width);
    
    return width;
}

- (NSInteger)starHeight
{
    NSInteger height = MAX([kDefaultEmptyChar sizeWithFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]].height, [kDefaultSolidChar sizeWithFont:[UIFont boldSystemFontOfSize:[self.starFontSize integerValue]]].height);
    
    if (_emptyImage)
        height = MAX(height, _emptyImage.size.height);
    
    if (_solidImage)
        height = MAX(height, _solidImage.size.height);
    
    return height;
}

- (void)adjustFrame
{
    CGRect newFrame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y,
                                 [self.maxRating integerValue] * [self starWidth] + ([self.maxRating integerValue] - 1) * _starSpacing,
                                 [self starHeight]);
    self.frame = newFrame;
}

- (void)handleTouch:(UITouch *)touch
{
    CGFloat width = self.frame.size.width;
	CGRect section = CGRectMake(0, 0, [self starWidth], self.frame.size.height);
	
	CGPoint touchLocation = [touch locationInView:self];
	
	if (touchLocation.x < 0)
	{
		if ([self.rating integerValue] != 0)
		{
       		self.rating = [NSNumber numberWithInteger:0];
			[self sendActionsForControlEvents:UIControlEventEditingChanged];
		}
	}
	else if (touchLocation.x > width)
	{
		if (![self.rating isEqualToNumber:self.maxRating])
		{
            self.rating = [self.maxRating copy];
			[self sendActionsForControlEvents:UIControlEventEditingChanged];
		}
	}
	else
	{
		for (int i = 0 ; i < [self.maxRating integerValue] ; i++)
		{
			if ((touchLocation.x > section.origin.x) && (touchLocation.x < (section.origin.x + [self starWidth])))
			{
				if ([self.rating integerValue] != (i+1))
				{
              		self.rating = [NSNumber numberWithInteger:i+1];
					[self sendActionsForControlEvents:UIControlEventEditingChanged];
				}
				break;
			}
			section.origin.x += ([self starWidth] + _starSpacing);
		}
	}
	[self setNeedsDisplay];
}

@end
