//
//  CustomSegmentedControl.m
//  42qu
//
//  Created by Alex Rezit on 12-6-16.
//  Copyright (c) 2012年 Seymour Dev. All rights reserved.
//

#import "CustomSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomSegmentedControl

@synthesize delegate = _delegate;

@synthesize animationType = _animationType;

@synthesize buttons = _buttons;
@synthesize segmentedIndex = _segmentedIndex;
@synthesize numberOfSegments = _numberOfSegments;
@synthesize titles = _titles;
@synthesize highlightedTitles = _highlightedTitles;
@synthesize selectedTitles = _selectedTitles;
@synthesize dividerImage = _dividerImage;
@synthesize highlightedBackgroundImage = _highlightedBackgroundImage;
@synthesize selectedBackgroundImage = _selectedBackgroundImage;
@synthesize highlightedBackgroundImageView = _highlightedBackgroundImageView;
@synthesize selectedBackgroundImageView = _selectedBackgroundImageView;
@synthesize normalImgs = _normalImgs;
@synthesize highlightedImgs = _highlightedImgs;
@synthesize selectImgs = _selectImgs;
@synthesize segmentType = _segmentType;
@synthesize leftNormalImage = _leftNormalImage;
@synthesize leftHighlightedBackgroundImage = _leftHighlightedBackgroundImage;
@synthesize leftSelectedBackgroundImage = _leftSelectedBackgroundImage;
@synthesize righNormalImage = _righNormalImage;
@synthesize rightHighlightedBackgroundImage = _rightHighlightedBackgroundImage;
@synthesize rightSelectedBackgroundImage = _rightSelectedBackgroundImage;

- (void)highlightButton:(UIButton *)button
{
    for (UIButton *oneButton in _buttons) {
        if (button == oneButton) {
            _highlightedBackgroundImageView.frame = oneButton.frame;
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.15f;
            [self.layer addAnimation:transition forKey:nil];
            [UIView animateWithDuration:0.15f animations:^{
                _highlightedBackgroundImageView.hidden = NO;
            }];
        }
    }
}

- (void)highlightButtonCancel:(UIButton *)button
{
    for (UIButton *oneButton in _buttons) {
        if (button == oneButton) {
            _highlightedBackgroundImageView.frame = oneButton.frame;
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.15f;
            [self.layer addAnimation:transition forKey:nil];
            [UIView animateWithDuration:0.15f animations:^{
                _highlightedBackgroundImageView.hidden = YES;
            }];
        }
    }
}

- (void)selectButton:(UIButton *)button
{
    for (UIButton *oneButton in _buttons) {
        if (button == oneButton) {
            if (_animationType == SegmentedControlAnimationTypeFade) {
                CATransition *transition = [CATransition animation];
                transition.type = kCATransitionFade;
                transition.duration = 0.2f;
                [self.layer addAnimation:transition forKey:nil];
                _selectedBackgroundImageView.hidden = YES;
                _selectedBackgroundImageView.frame = oneButton.frame;
                [UIView animateWithDuration:0.2f animations:^{
                    oneButton.selected = YES;
                    _selectedBackgroundImageView.hidden = NO;
                    _highlightedBackgroundImageView.hidden = YES;
                }];
            } else if (_animationType == SegmentedControlAnimationTypeMove) {
                [UIView animateWithDuration:0.2f animations:^{
                    oneButton.selected = YES;
                    _selectedBackgroundImageView.frame = oneButton.frame;
                    _highlightedBackgroundImageView.hidden = YES;
                }];
            } else {
                oneButton.selected = YES;
                _selectedBackgroundImageView.frame = oneButton.frame;
                _highlightedBackgroundImageView.hidden = YES;
            }
        } else {
            oneButton.selected = NO;
        }
    }
}

- (void)buttonTouchUpInside:(UIButton *)button
{
    [self selectButton:button];
    self.segmentedIndex = [_buttons indexOfObject:button];
    [self.delegate customSegmentedControl:self didSelectItemAtIndex:[_buttons indexOfObject:button]];
}

- (void)buttonTouchedDown:(UIButton *)button
{
    [self highlightButton:button];
}

- (void)buttonTouchedOther:(UIButton *)button
{
    [self highlightButtonCancel:button];
}

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andHighlightedTitles:(NSArray *)highlightedTitles andSelectedTitles:(NSArray *)selectedTitles andBackgroundImage:(UIImage *)backgroundImage andDividerImage:(UIImage *)dividerImage andHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage andSelectedBackgroundImage:(UIImage *)selectedBackgroundImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _animationType = SegmentedControlAnimationTypeMove;
        _segmentType = SegmentedTitleType;
        // Set the attributes
        self.titles = titles;
        self.highlightedTitles = highlightedTitles;
        self.selectedTitles = selectedTitles;
        self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        self.dividerImage = dividerImage;
        self.highlightedBackgroundImage = highlightedBackgroundImage;
        self.selectedBackgroundImage = selectedBackgroundImage;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNormalImages:(NSArray *)normalImgs andHighlightedImages:(NSArray *)highlightedImgs andSelectImage:(NSArray *)selectImages{
    self = [super initWithFrame:frame];
    if (self) {
        _segmentType = SegmentedImageType;
        self.normalImgs = normalImgs;
        self.numberOfSegments  = [normalImgs count];
        self.highlightedImgs = normalImgs;
        self.selectImgs = selectImages;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{

    [_buttons release];
    [_titles release];
    [_highlightedTitles release];
    [_selectedTitles release];
    [_dividerImage release];
    [_highlightedBackgroundImage release];
    [_selectedBackgroundImage release];
    [_highlightedBackgroundImageView release];
    [_selectedBackgroundImageView release];
    [_normalImgs release];
    [_highlightedImgs release];
    [_selectImgs release];
    [_leftNormalImage release];
    [_leftHighlightedBackgroundImage release];
    [_leftSelectedBackgroundImage release];
    [_righNormalImage release];
    [_rightHighlightedBackgroundImage release];
    [_rightSelectedBackgroundImage release];
    [super dealloc];
}
- (void)setUpSegmentedImage{
    if ([_normalImgs count] > 0 && [_selectImgs count] > 0) {
        if ([_normalImgs count] != [_selectImgs count]) {
            NSLog(@"Custom Segmented Control: normal count is not equals highlighted count . ");
            return;
        }
    }else{
        NSLog(@"Custom Segmented Control: normal or highlighted image is empty. ");
        return;
    }
    
    // Calculate the size
    CGRect frame = self.frame;
    CGFloat dividerWidth = _dividerImage?_dividerImage.size.width:0;
    CGFloat height = frame.size.height;
    CGFloat buttonWidth = (frame.size.width - dividerWidth * (_normalImgs.count - 1)) / _normalImgs.count;
    
    // Initialize horizontal offset
    CGFloat horizontalOffset = 0;
    
    // Create and add buttons
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:_normalImgs.count];
    for (NSUInteger i = 0; i < _normalImgs.count; i++) {
        // Button
        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(horizontalOffset, 0, buttonWidth, height)] autorelease];
        [button setImage:[UIImage imageNamed:[_normalImgs objectAtIndex:i]] forState:UIControlStateNormal];
        if (_highlightedImgs.count) {
            [button setImage:[UIImage imageNamed:[_highlightedImgs objectAtIndex:i]] forState:UIControlStateHighlighted];
        }
        if (_selectImgs.count) {
            [button setImage:[UIImage imageNamed:[_selectImgs objectAtIndex:i]] forState:UIControlStateSelected];
        }
        
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragOutside];
        [buttons addObject:button];
        [self addSubview:button];
        horizontalOffset += buttonWidth;
    }
    self.buttons = buttons;
    [buttons release];
    
    // Select the first button
    [self selectButton:[_buttons objectAtIndex:0]];
    
}
- (void)setUpSegmentedTitle{
    if (_titles.count > 0) { // When the number of buttons > 0, generate the segmented control
        if ((_highlightedTitles.count && _titles.count != _highlightedTitles.count) || (_selectedTitles.count && _titles.count != _selectedTitles.count)) { // When titles and highlighted/selected titles not match, return an empty view
            NSLog(@"Custom Segmented Control: Titles and highlighted titles not match");
            return;
        }
    } else { // When the titles is empty, return an empty view
        NSLog(@"Custom Segmented Control: Titles empty. ");
        return;
    }
    
    // Calculate the size
    CGRect frame = self.frame;
    CGFloat dividerWidth = _dividerImage?_dividerImage.size.width:0;
    CGFloat height = frame.size.height;
    CGFloat buttonWidth = (frame.size.width - dividerWidth * (_titles.count - 1)) / _titles.count;
    
    // Initialize horizontal offset
    CGFloat horizontalOffset = 0;
    
    // Create and add buttons
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    for (NSUInteger i = 0; i < _titles.count; i++) {
        // Button
        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(horizontalOffset, 0, buttonWidth, height)] autorelease];
        [button setTitle:[_titles objectAtIndex:i] forState:UIControlStateNormal];
        if (_highlightedTitles.count) {
            [button setTitle:[_highlightedTitles objectAtIndex:i] forState:UIControlStateHighlighted];
        }
        if (_selectedTitles.count) {
            [button setTitle:[_selectedTitles objectAtIndex:i] forState:UIControlStateSelected];
        }
        
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragOutside];
        [buttons addObject:button];
        [self addSubview:button];
        horizontalOffset += buttonWidth;
        
        // Divider
        if (_dividerImage && i != _titles.count - 1) {
            UIImageView *dividerImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(horizontalOffset, 0, dividerWidth, height)] autorelease];
            dividerImageView.image = _dividerImage;
            [self addSubview:dividerImageView];
            horizontalOffset += dividerWidth;
        }
    }
    self.buttons = buttons;
    [buttons release];
    
    // Initialize background views
    self.highlightedBackgroundImageView = [[[UIImageView alloc] initWithFrame:[(UIButton *)[_buttons objectAtIndex:0] frame]] autorelease];
    _highlightedBackgroundImageView.image = _highlightedBackgroundImage;
    _highlightedBackgroundImageView.hidden = YES;
    [self addSubview:_highlightedBackgroundImageView];
    
    self.selectedBackgroundImageView = [[[UIImageView alloc] initWithFrame:[(UIButton *)[_buttons objectAtIndex:0] frame]] autorelease];
    _selectedBackgroundImageView.image = _selectedBackgroundImage;
    [self addSubview:_selectedBackgroundImageView];
    [self sendSubviewToBack:_highlightedBackgroundImageView];
    [self sendSubviewToBack:_selectedBackgroundImageView];
    
    // Select the first button
    [self selectButton:[_buttons objectAtIndex:0]];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (_segmentType == SegmentedTitleType) {
        [self setUpSegmentedTitle];
    }else if (_segmentType == SegmentedImageType){
        [self setUpSegmentedImage];
    }
    
}

@end
