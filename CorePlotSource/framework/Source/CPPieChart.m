#import "CPMutableNumericData.h"
#import "CPNumericData.h"
#import "CPPieChart.h"
#import "CPPlotArea.h"
#import "CPPlotSpace.h"
#import "CPPlotSpaceAnnotation.h"
#import "CPColor.h"
#import "CPFill.h"
#import "CPUtilities.h"
#import "CPTextLayer.h"
#import "CPLineStyle.h"

NSString * const CPPieChartBindingPieSliceWidthValues = @"sliceWidths";		///< Pie slice widths.

/**	@cond */
@interface CPPieChart ()

@property (nonatomic, readwrite, copy) NSArray *sliceWidths;

-(void)updateNormalizedData;
-(CGFloat)radiansForPieSliceValue:(CGFloat)pieSliceValue;
-(CGFloat)normalizedPosition:(CGFloat)rawPosition;
-(BOOL)angle:(CGFloat)touchedAngle betweenStartAngle:(CGFloat)startingAngle endAngle:(CGFloat)endingAngle;

-(void)addSliceToPath:(CGMutablePathRef)slicePath centerPoint:(CGPoint)center startingAngle:(CGFloat)startingAngle finishingAngle:(CGFloat)finishingAngle;
-(void)drawSliceInContext:(CGContextRef)context centerPoint:(CGPoint)centerPoint radialOffset:(CGFloat)radialOffset startingValue:(CGFloat)startingValue width:(CGFloat)sliceWidth fill:(CPFill *)sliceFill;
-(void)drawOverlayInContext:(CGContextRef)context centerPoint:(CGPoint)centerPoint;

@end
/**	@endcond */

#pragma mark -

/** @brief A pie chart.
 **/
@implementation CPPieChart

@dynamic sliceWidths;

/** @property pieRadius
 *	@brief The radius of the overall pie chart. Defaults to 80% of the initial frame size.
 **/
@synthesize pieRadius;

/** @property pieInnerRadius
 *	@brief The inner radius of the pie chart, used to create a "donut hole". Defaults to 0.
 **/
@synthesize pieInnerRadius;

/** @property sliceLabelOffset
 *	@brief The radial offset of the slice labels from the edge of each slice. Defaults to 10.0
 *	@deprecated This property has been replaced by the CPPlot::labelOffset property.
 **/
@dynamic sliceLabelOffset;

/** @property startAngle
 *	@brief The starting angle for the first slice in radians. Defaults to pi/2.
 **/
@synthesize startAngle;

/** @property sliceDirection
 *	@brief Determines whether the pie slices are drawn in a clockwise or counter-clockwise
 *	direction from the starting point. Defaults to clockwise.
 **/
@synthesize sliceDirection;

/** @property centerAnchor
 *	@brief The position of the center of the pie chart with the x and y coordinates
 *	given as a fraction of the width and height, respectively. Defaults to (0.5, 0.5).
 **/
@synthesize centerAnchor;

/** @property borderLineStyle
 *	@brief The line style used to outline the pie slices.  If nil, no border is drawn.  Defaults to nil.
 **/
@synthesize borderLineStyle;

/** @property overlayFill
 *	@brief A fill drawn on top of the pie chart. 
 *  Can be used to add shading/gloss effects. Defaults to nil.
 **/
@synthesize overlayFill;


#pragma mark -
#pragma mark Convenience Factory Methods

static CGFloat colorLookupTable[10][3] = 
{    
	{1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {0.0, 0.0, 1.0}, {1.0, 1.0, 0.0}, {0.25, 0.5, 0.25},   
	{1.0, 0.0, 1.0}, {0.5, 0.5, 0.5}, {0.25, 0.5, 0.0}, {0.25, 0.25, 0.25}, {0.0, 1.0, 1.0}
};

/** @brief Creates and returns a CPColor that acts as the default color for that pie chart index.
 *	@param pieSliceIndex The pie slice index to return a color for.
 *	@return A new CPColor instance corresponding to the default value for this pie slice index.
 **/

+(CPColor *)defaultPieSliceColorForIndex:(NSUInteger)pieSliceIndex;
{
	return [CPColor colorWithComponentRed:(colorLookupTable[pieSliceIndex % 10][0] + (CGFloat)(pieSliceIndex / 10) * 0.1) green:(colorLookupTable[pieSliceIndex % 10][1] + (CGFloat)(pieSliceIndex / 10) * 0.1) blue:(colorLookupTable[pieSliceIndex % 10][2] + (CGFloat)(pieSliceIndex / 10) * 0.1) alpha:1.0];	
}

#pragma mark -
#pragma mark Initialization

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#else
+(void)initialize
{
	if ( self == [CPPieChart class] ) {
		[self exposeBinding:CPPieChartBindingPieSliceWidthValues];	
	}
}
#endif

-(id)initWithFrame:(CGRect)newFrame
{
	if ( self = [super initWithFrame:newFrame] ) {
		pieRadius = 0.8 * (MIN(newFrame.size.width, newFrame.size.height) / 2.0);
		pieInnerRadius = 0.0;
		startAngle = M_PI_2;	// pi/2
		sliceDirection = CPPieDirectionClockwise;
		centerAnchor = CGPointMake(0.5, 0.5);
		borderLineStyle = nil;
		
		self.labelOffset = 10.0;
		self.labelField = CPPieChartFieldSliceWidth;
	}
	return self;
}

-(id)initWithLayer:(id)layer
{
	if ( self = [super initWithLayer:layer] ) {
		CPPieChart *theLayer = (CPPieChart *)layer;
		
		pieRadius = theLayer->pieRadius;
		pieInnerRadius = theLayer->pieInnerRadius;
		startAngle = theLayer->startAngle;
		sliceDirection = theLayer->sliceDirection;
		centerAnchor = theLayer->centerAnchor;
		borderLineStyle = [theLayer->borderLineStyle retain];
	}
	return self;
}

-(void)dealloc
{
	[borderLineStyle release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Data Loading

-(void)reloadDataInIndexRange:(NSRange)indexRange
{
	[super reloadDataInIndexRange:indexRange];
	
    // Pie slice widths
	if ( self.dataSource ) {
		// Grab all values from the data source
		id rawSliceValues = [self numbersFromDataSourceForField:CPPieChartFieldSliceWidth recordIndexRange:indexRange];
		[self cacheNumbers:rawSliceValues forField:CPPieChartFieldSliceWidth atRecordIndex:indexRange.location];
    }
	else {
		[self cacheNumbers:nil forField:CPPieChartFieldSliceWidth];
	}
	
	[self updateNormalizedData];
}

-(void)deleteDataInIndexRange:(NSRange)indexRange
{
	[super deleteDataInIndexRange:indexRange];
	[self updateNormalizedData];
}

-(void)updateNormalizedData
{
	// Normalize these widths to 1.0 for the whole pie
	NSUInteger sampleCount = self.cachedDataCount;
	if ( sampleCount > 0 ) {
		CPMutableNumericData *rawSliceValues = [self cachedNumbersForField:CPPieChartFieldSliceWidth];
		if ( self.doublePrecisionCache ) {
			double valueSum = 0.0;
			const double *dataBytes = (const double *)rawSliceValues.bytes;
			const double *dataEnd = dataBytes + sampleCount;
			while ( dataBytes < dataEnd ) {
				double currentWidth = *dataBytes++;
				if ( !isnan(currentWidth) ) {
					valueSum += currentWidth;
				}
			}
			
			CPNumericDataType dataType = CPDataType(CPFloatingPointDataType, sizeof(double), CFByteOrderGetCurrent());
			
			CPMutableNumericData *normalizedSliceValues = [[CPMutableNumericData alloc] initWithData:[NSData data] dataType:dataType shape:nil];
			((NSMutableData *)normalizedSliceValues.data).length = sampleCount * sizeof(double);
			CPMutableNumericData *cumulativeSliceValues = [[CPMutableNumericData alloc] initWithData:[NSData data] dataType:dataType shape:nil];
			((NSMutableData *)cumulativeSliceValues.data).length = sampleCount * sizeof(double);
			
			double cumulativeSum = 0.0;
			
			dataBytes = (const double *)rawSliceValues.bytes;
			double *normalizedBytes = normalizedSliceValues.mutableBytes;
			double *cumulativeBytes = cumulativeSliceValues.mutableBytes;
			while ( dataBytes < dataEnd ) {
				double currentWidth = *dataBytes++;
				if ( isnan(currentWidth) ) {
					*normalizedBytes++ = NAN;
				}
				else {
					*normalizedBytes++ = currentWidth / valueSum;
					cumulativeSum += currentWidth;
				}
				*cumulativeBytes++ = cumulativeSum / valueSum;
			}
			[self cacheNumbers:normalizedSliceValues forField:CPPieChartFieldSliceWidthNormalized];
			[self cacheNumbers:cumulativeSliceValues forField:CPPieChartFieldSliceWidthSum];
			[normalizedSliceValues release];
			[cumulativeSliceValues release];
		}
		else {
			NSDecimal valueSum = CPDecimalFromInteger(0);
			const NSDecimal *dataBytes = (const NSDecimal *)rawSliceValues.bytes;
			const NSDecimal *dataEnd = dataBytes + sampleCount;
			while ( dataBytes < dataEnd ) {
				NSDecimal currentWidth = *dataBytes++;
				if ( !NSDecimalIsNotANumber(&currentWidth) ) {
					valueSum = CPDecimalAdd(valueSum, *dataBytes++);
				}
			}
			
			CPNumericDataType dataType = CPDataType(CPDecimalDataType, sizeof(NSDecimal), CFByteOrderGetCurrent());
			
			CPMutableNumericData *normalizedSliceValues = [[CPMutableNumericData alloc] initWithData:[NSData data] dataType:dataType shape:nil];
			((NSMutableData *)normalizedSliceValues.data).length = sampleCount * sizeof(NSDecimal);
			CPMutableNumericData *cumulativeSliceValues = [[CPMutableNumericData alloc] initWithData:[NSData data] dataType:dataType shape:nil];
			((NSMutableData *)cumulativeSliceValues.data).length = sampleCount * sizeof(NSDecimal);
			
			NSDecimal cumulativeSum = CPDecimalFromInteger(0);
			
			NSDecimal decimalNAN = CPDecimalNaN();
			dataBytes = (const NSDecimal *)rawSliceValues.bytes;
			NSDecimal *normalizedBytes = normalizedSliceValues.mutableBytes;
			NSDecimal *cumulativeBytes = cumulativeSliceValues.mutableBytes;
			while ( dataBytes < dataEnd ) {
				NSDecimal currentWidth = *dataBytes++;
				if ( NSDecimalIsNotANumber(&currentWidth) ) {
					*normalizedBytes++ = decimalNAN;
				}
				else {
					*normalizedBytes++ = CPDecimalDivide(currentWidth, valueSum);
					cumulativeSum = CPDecimalAdd(cumulativeSum, currentWidth);
				}
				*cumulativeBytes++ = CPDecimalDivide(cumulativeSum, valueSum);
			}
			[self cacheNumbers:normalizedSliceValues forField:CPPieChartFieldSliceWidthNormalized];
			[self cacheNumbers:cumulativeSliceValues forField:CPPieChartFieldSliceWidthSum];
			[normalizedSliceValues release];
			[cumulativeSliceValues release];
		}
	}
	else {
		[self cacheNumbers:nil forField:CPPieChartFieldSliceWidthNormalized];
		[self cacheNumbers:nil forField:CPPieChartFieldSliceWidthSum];
	}
	
	// Labels
	[self relabelIndexRange:NSMakeRange(0, [self.dataSource numberOfRecordsForPlot:self])];
}

#pragma mark -
#pragma mark Drawing

-(void)renderAsVectorInContext:(CGContextRef)context
{
	NSUInteger sampleCount = self.cachedDataCount;
	if ( sampleCount == 0 ) return;
	
	[super renderAsVectorInContext:context];
	CGRect plotAreaBounds = self.plotArea.bounds;
	CGPoint anchor = self.centerAnchor;
	CGPoint centerPoint = CGPointMake(plotAreaBounds.origin.x + plotAreaBounds.size.width * anchor.x,
									  plotAreaBounds.origin.y + plotAreaBounds.size.height * anchor.y);
	centerPoint = [self convertPoint:centerPoint fromLayer:self.plotArea];
	centerPoint = CPAlignPointToUserSpace(context, centerPoint);
	
	// TODO: Add NSDecimal rendering path
	
	NSUInteger currentIndex = 0;
	CGFloat startingWidth = 0.0;
	id <CPPieChartDataSource> theDataSource = (id <CPPieChartDataSource>)self.dataSource;
	BOOL dataSourceProvidesFills = [theDataSource respondsToSelector:@selector(sliceFillForPieChart:recordIndex:)];
    BOOL dataSourceProvidesRadialOffsets = [theDataSource respondsToSelector:@selector(radialOffsetForPieChart:recordIndex:)];
	
	while ( currentIndex < sampleCount ) {
		CGFloat currentWidth = [self cachedDoubleForField:CPPieChartFieldSliceWidthNormalized recordIndex:currentIndex];
		
		if ( !isnan(currentWidth) ) {
			CPFill *currentFill = nil;
			if ( dataSourceProvidesFills ) {
				CPFill *dataSourceFill = [theDataSource sliceFillForPieChart:self recordIndex:currentIndex];
				if ( nil != dataSourceFill ) currentFill = dataSourceFill;
			}
			else {
				currentFill = [CPFill fillWithColor:[CPPieChart defaultPieSliceColorForIndex:currentIndex]];
			}
            
            CGFloat radialOffset = 0.0;
            if ( dataSourceProvidesRadialOffsets ) {
                radialOffset = [theDataSource radialOffsetForPieChart:self recordIndex:currentIndex];
            }
			
			[self drawSliceInContext:context centerPoint:centerPoint radialOffset:radialOffset startingValue:startingWidth width:currentWidth fill:currentFill];
			
			startingWidth += currentWidth;
		}
		currentIndex++;
	}
    
    [self drawOverlayInContext:context centerPoint:centerPoint];
}	

-(CGFloat)radiansForPieSliceValue:(CGFloat)pieSliceValue
{
	CGFloat angle = self.startAngle;
	switch ( self.sliceDirection ) {
		case CPPieDirectionClockwise:
			angle -= pieSliceValue * M_PI * 2.0;
			break;
		case CPPieDirectionCounterClockwise:
			angle += pieSliceValue * M_PI * 2.0;
			break;
	}
	return angle;
}

-(void)addSliceToPath:(CGMutablePathRef)slicePath centerPoint:(CGPoint)center startingAngle:(CGFloat)startingAngle finishingAngle:(CGFloat)finishingAngle
{
	bool direction = (self.sliceDirection == CPPieDirectionClockwise) ? true : false;
	CGFloat innerRadius = self.pieInnerRadius;
    if ( innerRadius > 0.0 ) {
		CGPathAddArc(slicePath, NULL, center.x, center.y, self.pieRadius, startingAngle, finishingAngle, direction);
		CGPathAddArc(slicePath, NULL, center.x, center.y, innerRadius, finishingAngle, startingAngle, !direction);
	}
	else {
		CGPathMoveToPoint(slicePath, NULL, center.x, center.y);
		CGPathAddArc(slicePath, NULL, center.x, center.y, self.pieRadius, startingAngle, finishingAngle, direction);
	}    
}

-(void)drawSliceInContext:(CGContextRef)context centerPoint:(CGPoint)centerPoint radialOffset:(CGFloat)radialOffset startingValue:(CGFloat)startingValue width:(CGFloat)sliceWidth fill:(CPFill *)sliceFill;
{
    CGContextSaveGState(context);
	
    CGFloat startingAngle = [self radiansForPieSliceValue:startingValue];
    CGFloat finishingAngle = [self radiansForPieSliceValue:startingValue + sliceWidth];
    
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    if ( radialOffset != 0.0 ) {
        CGFloat medianAngle = 0.5 * (startingAngle + finishingAngle);
#if CGFLOAT_IS_DOUBLE
        xOffset = round(cos(medianAngle) * radialOffset);
        yOffset = round(sin(medianAngle) * radialOffset);
#else
        xOffset = roundf(cosf(medianAngle) * radialOffset);
        yOffset = roundf(sinf(medianAngle) * radialOffset);
#endif
    }
    
    CGFloat centerX = centerPoint.x + xOffset;
    CGFloat centerY = centerPoint.y + yOffset;
	
	CGMutablePathRef slicePath = CGPathCreateMutable();
    [self addSliceToPath:slicePath centerPoint:CGPointMake(centerX, centerY) startingAngle:startingAngle finishingAngle:finishingAngle];
	CGPathCloseSubpath(slicePath);
	
	if ( sliceFill ) {
		CGContextBeginPath(context);
		CGContextAddPath(context, slicePath);
		[sliceFill fillPathInContext:context]; 
	}
	
	// Draw the border line around the slice
	CPLineStyle *borderStyle = self.borderLineStyle;
	if ( borderStyle ) {
		CGContextBeginPath(context);
		CGContextAddPath(context, slicePath);
		[borderStyle setLineStyleInContext:context];
		CGContextStrokePath(context);
	}
	
	CGPathRelease(slicePath);
	CGContextRestoreGState(context);
}

-(void)drawOverlayInContext:(CGContextRef)context centerPoint:(CGPoint)centerPoint
{
	if ( !overlayFill ) return;
    
    CGContextSaveGState(context);
    
	CGMutablePathRef fillPath = CGPathCreateMutable();
    [self addSliceToPath:fillPath centerPoint:CGPointMake(centerPoint.x, centerPoint.y) startingAngle:0.0f finishingAngle:2*M_PI];
	CGPathCloseSubpath(fillPath);
    
    CGContextBeginPath(context);
    CGContextAddPath(context, fillPath);
    [overlayFill fillPathInContext:context]; 
    
    CGPathRelease(fillPath);
    CGContextRestoreGState(context);
}

#pragma mark -
#pragma mark Fields

-(NSUInteger)numberOfFields 
{
    return 1;
}

-(NSArray *)fieldIdentifiers 
{
    return [NSArray arrayWithObject:[NSNumber numberWithUnsignedInt:CPPieChartFieldSliceWidth]];
}

-(NSArray *)fieldIdentifiersForCoordinate:(CPCoordinate)coord 
{
	return nil;
}

#pragma mark -
#pragma mark Data Labels

-(void)positionLabelAnnotation:(CPPlotSpaceAnnotation *)label forIndex:(NSUInteger)index
{
	if ( label.contentLayer ) {
		CGRect plotAreaBounds = self.plotArea.bounds;
		CGPoint anchor = self.centerAnchor;
		CGPoint centerPoint = CGPointMake(plotAreaBounds.origin.x + plotAreaBounds.size.width * anchor.x,
										  plotAreaBounds.origin.y + plotAreaBounds.size.height * anchor.y);
		
		NSDecimal plotPoint[2];
		[self.plotSpace plotPoint:plotPoint forPlotAreaViewPoint:centerPoint];
		NSDecimalNumber *xValue = [[NSDecimalNumber alloc] initWithDecimal:plotPoint[CPCoordinateX]];
		NSDecimalNumber *yValue = [[NSDecimalNumber alloc] initWithDecimal:plotPoint[CPCoordinateY]];
		label.anchorPlotPoint = [NSArray arrayWithObjects:xValue, yValue, nil];
		[xValue release];
		[yValue release];
		
		id <CPPieChartDataSource> theDataSource = (id <CPPieChartDataSource>)self.dataSource;
		BOOL dataSourceProvidesRadialOffsets = [theDataSource respondsToSelector:@selector(radialOffsetForPieChart:recordIndex:)];
		CGFloat radialOffset = 0.0;
		if ( dataSourceProvidesRadialOffsets ) {
			radialOffset = [theDataSource radialOffsetForPieChart:self recordIndex:index];
		}
		
		CGFloat labelRadius = self.pieRadius + self.labelOffset + radialOffset;
		
		double startingWidth = 0.0;
		if ( index > 0 ) {
			startingWidth = [self cachedDoubleForField:CPPieChartFieldSliceWidthSum recordIndex:index - 1];
		}
		double currentWidth = [self cachedDoubleForField:CPPieChartFieldSliceWidthNormalized recordIndex:index];
		double labelAngle = [self radiansForPieSliceValue:startingWidth + currentWidth / 2.0];
#if CGFLOAT_IS_DOUBLE
		label.displacement = CGPointMake(labelRadius * cos(labelAngle), labelRadius * sin(labelAngle));
#else
		label.displacement = CGPointMake(labelRadius * cosf(labelAngle), labelRadius * sinf(labelAngle));
#endif
		
		label.contentLayer.hidden = isnan(currentWidth);
	}
	else {
		label.anchorPlotPoint = nil;
		label.displacement = CGPointZero;
	}

}

#pragma mark -
#pragma mark Responder Chain and User interaction

-(CGFloat)normalizedPosition:(CGFloat)rawPosition
{
	CGFloat result = rawPosition;
#if CGFLOAT_IS_DOUBLE
	result /= 2.0 * M_PI;
	if ( result < 0.0 ) {
		result += 1.0;
	}
	result = fmod(result, 1.0);
#else
	result /= 2.0f * (float)M_PI;
	if ( result < 0.0f ) {
		result += 1.0f;
	}
	result = fmodf(result, 1.0f);
#endif
	return result;
}

-(BOOL)angle:(CGFloat)touchedAngle betweenStartAngle:(CGFloat)startingAngle endAngle:(CGFloat)endingAngle
{
	switch ( self.sliceDirection ) {
		case CPPieDirectionClockwise:
			if ( (touchedAngle <= startingAngle) && (touchedAngle >= endingAngle) ) {
				return YES;
			}
			else if ( (endingAngle < 0.0) && (touchedAngle - 1.0 >= endingAngle) ) {
				return YES;
			}
			break;
			
		case CPPieDirectionCounterClockwise:
			if ( (touchedAngle >= startingAngle) && (touchedAngle <= endingAngle) ) {
				return YES;
			}
			else if ( (endingAngle > 1.0) && (touchedAngle + 1.0 <= endingAngle) ) {
				return YES;
			}
			break;
	}
	return NO;
}

-(BOOL)pointingDeviceDownEvent:(id)event atPoint:(CGPoint)interactionPoint
{
	BOOL result = NO;
	CPGraph *theGraph = self.graph;
	CPPlotArea *thePlotArea = self.plotArea;
	if ( !theGraph || !thePlotArea ) return NO;
	
	id <CPPieChartDelegate> theDelegate = self.delegate;
	if ( [theDelegate respondsToSelector:@selector(pieChart:sliceWasSelectedAtRecordIndex:)] ) {
    	// Inform delegate if a slice was hit
        CGPoint plotAreaPoint = [theGraph convertPoint:interactionPoint toLayer:thePlotArea];
		
		NSUInteger sampleCount = self.cachedDataCount;
		if ( sampleCount == 0 ) return NO;
		
		CGRect plotAreaBounds = thePlotArea.bounds;
		CGPoint anchor = self.centerAnchor;
		CGPoint centerPoint = CGPointMake(plotAreaBounds.origin.x + plotAreaBounds.size.width * anchor.x,
										  plotAreaBounds.origin.y + plotAreaBounds.size.height * anchor.y);
		centerPoint = [self convertPoint:centerPoint fromLayer:thePlotArea];
		
		id <CPPieChartDataSource> theDataSource = (id <CPPieChartDataSource>)self.dataSource;
		BOOL dataSourceProvidesRadialOffsets = [theDataSource respondsToSelector:@selector(radialOffsetForPieChart:recordIndex:)];
		
		CGFloat chartRadius = self.pieRadius;
		CGFloat chartRadiusSquared = chartRadius * chartRadius;
		CGFloat chartInnerRadius = self.pieInnerRadius;
		CGFloat chartInnerRadiusSquared = chartInnerRadius * chartInnerRadius;
		CGFloat dx = plotAreaPoint.x - centerPoint.x;
		CGFloat dy = plotAreaPoint.y - centerPoint.y;
		CGFloat distanceSquared = dx * dx + dy * dy;
		
#if CGFLOAT_IS_DOUBLE
		CGFloat touchedAngle = [self normalizedPosition:atan2(dy, dx)];
#else
		CGFloat touchedAngle = [self normalizedPosition:atan2f(dy, dx)];
#endif
		CGFloat startingAngle = [self normalizedPosition:self.startAngle];
		
		switch ( self.sliceDirection ) {
			case CPPieDirectionClockwise:
				for ( NSUInteger currentIndex = 0; currentIndex < sampleCount; currentIndex++ ) {
					// calculate angles for this slice
					CGFloat width = [self cachedDoubleForField:CPPieChartFieldSliceWidthNormalized recordIndex:currentIndex];
					if ( isnan(width) ) continue;
					CGFloat endingAngle = startingAngle - width;
					
					// offset the center point of the slice if needed
					CGFloat offsetTouchedAngle = touchedAngle;
					CGFloat offsetDistanceSquared = distanceSquared;
					CGFloat radialOffset = 0.0;
					if ( dataSourceProvidesRadialOffsets ) {
						radialOffset = [theDataSource radialOffsetForPieChart:self recordIndex:currentIndex];
						
						if ( radialOffset != 0.0 ) {
							CGPoint offsetCenter;
							CGFloat medianAngle = M_PI * (startingAngle + endingAngle);
#if CGFLOAT_IS_DOUBLE
							offsetCenter = CGPointMake(centerPoint.x + cos(medianAngle) * radialOffset,
													   centerPoint.y + sin(medianAngle) * radialOffset);
#else
							offsetCenter = CGPointMake(centerPoint.x + cosf(medianAngle) * radialOffset,
													   centerPoint.y + sinf(medianAngle) * radialOffset);
#endif
							dx = plotAreaPoint.x - offsetCenter.x;
							dy = plotAreaPoint.y - offsetCenter.y;
#if CGFLOAT_IS_DOUBLE
							offsetTouchedAngle = [self normalizedPosition:atan2(dy, dx)];
#else
							offsetTouchedAngle = [self normalizedPosition:atan2f(dy, dx)];
#endif
							offsetDistanceSquared = dx * dx + dy * dy;
						}
					}

					// check angles
					BOOL angleInSlice = NO;
					if ( [self angle:touchedAngle betweenStartAngle:startingAngle endAngle:endingAngle] ) {
						if ( [self angle:offsetTouchedAngle betweenStartAngle:startingAngle endAngle:endingAngle] ) {
							angleInSlice = YES;
						}
						else {
							return NO;
						}
					}
					
					// check distance
					if ( angleInSlice && (offsetDistanceSquared >= chartInnerRadiusSquared) && (offsetDistanceSquared <= chartRadiusSquared) ) {
						[theDelegate pieChart:self sliceWasSelectedAtRecordIndex:currentIndex];
						return YES;
					}
					
					// save angle for the next slice
					startingAngle = endingAngle;
				}
				break;
			case CPPieDirectionCounterClockwise:
				for ( NSUInteger currentIndex = 0; currentIndex < sampleCount; currentIndex++ ) {
					// calculate angles for this slice
					CGFloat width = [self cachedDoubleForField:CPPieChartFieldSliceWidthNormalized recordIndex:currentIndex];
					if ( isnan(width) ) continue;
					CGFloat endingAngle = startingAngle + width;
					
					// offset the center point of the slice if needed
					CGFloat offsetTouchedAngle = touchedAngle;
					CGFloat offsetDistanceSquared = distanceSquared;
					CGFloat radialOffset = 0.0;
					if ( dataSourceProvidesRadialOffsets ) {
						radialOffset = [theDataSource radialOffsetForPieChart:self recordIndex:currentIndex];
						
						if ( radialOffset != 0.0 ) {
							CGPoint offsetCenter;
							CGFloat medianAngle = M_PI * (startingAngle + endingAngle);
#if CGFLOAT_IS_DOUBLE
							offsetCenter = CGPointMake(centerPoint.x + cos(medianAngle) * radialOffset,
													   centerPoint.y + sin(medianAngle) * radialOffset);
#else
							offsetCenter = CGPointMake(centerPoint.x + cosf(medianAngle) * radialOffset,
													   centerPoint.y + sinf(medianAngle) * radialOffset);
#endif
							dx = plotAreaPoint.x - offsetCenter.x;
							dy = plotAreaPoint.y - offsetCenter.y;
#if CGFLOAT_IS_DOUBLE
							offsetTouchedAngle = [self normalizedPosition:atan2(dy, dx)];
#else
							offsetTouchedAngle = [self normalizedPosition:atan2f(dy, dx)];
#endif
							offsetDistanceSquared = dx * dx + dy * dy;
						}
					}
					
					// check angles
					BOOL angleInSlice = NO;
					if ( [self angle:touchedAngle betweenStartAngle:startingAngle endAngle:endingAngle] ) {
						if ( [self angle:offsetTouchedAngle betweenStartAngle:startingAngle endAngle:endingAngle] ) {
							angleInSlice = YES;
						}
						else {
							return NO;
						}
					}
					
					// check distance
					if ( angleInSlice && (offsetDistanceSquared >= chartInnerRadiusSquared) && (offsetDistanceSquared <= chartRadiusSquared) ) {
						[theDelegate pieChart:self sliceWasSelectedAtRecordIndex:currentIndex];
						return YES;
					}
					
					// save angle for the next slice
					startingAngle = endingAngle;
				}
				break;
			default:
				break;
		}
	}
    else {
        result = [super pointingDeviceDownEvent:event atPoint:interactionPoint];
    }
    
	return result;
}

#pragma mark -
#pragma mark Accessors

-(NSArray *)sliceWidths {
    return [[self cachedNumbersForField:CPPieChartFieldSliceWidthNormalized] sampleArray];
}

-(void)setSliceWidths:(NSArray *)newSliceWidths 
{
    [self cacheNumbers:newSliceWidths forField:CPPieChartFieldSliceWidthNormalized];
	[self updateNormalizedData];
}

-(void)setPieRadius:(CGFloat)newPieRadius 
{
    if ( pieRadius != newPieRadius ) {
        pieRadius = ABS(newPieRadius);
        [self setNeedsDisplay];
		[self setNeedsRelabel];
    }
}

-(void)setPieInnerRadius:(CGFloat)newPieRadius 
{
    if ( pieInnerRadius != newPieRadius ) {
        pieInnerRadius = ABS(newPieRadius);
        [self setNeedsDisplay];
    }
}

-(void)setStartAngle:(CGFloat)newAngle
{
    if ( newAngle != startAngle ) {
        startAngle = newAngle;
        [self setNeedsDisplay];
        [self setNeedsRelabel];
    }
}

-(void)setSliceDirection:(CPPieDirection)newDirection
{
    if ( newDirection != sliceDirection ) {
        sliceDirection = newDirection;
        [self setNeedsDisplay];
        [self setNeedsRelabel];
    }
}

-(void)setBorderLineStyle:(CPLineStyle *)newStyle
{
	if ( borderLineStyle != newStyle ) {
		[borderLineStyle release];
		borderLineStyle = [newStyle copy];
		[self setNeedsDisplay];
	}	
}

-(void)setCenterAnchor:(CGPoint)newCenterAnchor 
{
    if ( !CGPointEqualToPoint(centerAnchor, newCenterAnchor) ) {
        centerAnchor = newCenterAnchor;
        [self setNeedsDisplay];
		[self setNeedsRelabel];
    }
}

-(CGFloat)sliceLabelOffset
{
	return self.labelOffset;
}

-(void)setSliceLabelOffset:(CGFloat)newOffset 
{
    self.labelOffset = newOffset;
}

@end
