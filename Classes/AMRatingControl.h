//
//  AMRatingControl.h
//  RatingControl
//


#import <UIKit/UIKit.h>


@interface AMRatingControl : UIControl

/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (nonatomic, retain) UIColor *emptyColor;
@property (nonatomic, retain) UIColor *solidColor;
@property (nonatomic, retain) UIImage *emptyImage;
@property (nonatomic, retain) UIImage *solidImage;
@property (nonatomic, retain) NSNumber *rating;
@property (nonatomic, retain) NSNumber *maxRating;

@property (nonatomic, retain) NSNumber *starWidthOverride;
@property (nonatomic, retain) NSNumber *starFontSize;
@property (nonatomic, readwrite) NSUInteger starSpacing;

/**************************************************************************************************/
#pragma mark - Birth & Death

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyColor & solidColor
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyImage & solidImage can both be nil, or not even a dot or a star (a any images you want!)
 * If either of these parameters are nil, the class will draw its own stars
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating;



@end
