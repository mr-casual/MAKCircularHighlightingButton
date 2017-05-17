//
//  MAKCircularHighlightingButton.h
//  MAKCircularHighlightingButton
//
//  Created by Martin Kloepfel on 06.12.14.
//  Copyright (c) 2014 Martin Klöpfel. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A simple button with an animated circular highlighting on press.
 */
@interface MAKCircularHighlightingButton : UIButton

/// The color of the circular highlighting
@property (nonatomic, strong) UIColor *highlightColor;

/** Assign the corner radius of the button to this property!
 @note This also changes the layer's corner radius, but we need this to clip the circular highlighting on the borders of the button.
 */
@property (nonatomic) CGFloat cornerRadius;

@end
