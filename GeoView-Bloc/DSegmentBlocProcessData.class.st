Class {
	#name : #DSegmentBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DSegmentBlocProcessData >> processCreatedData: aKey incoming: aDSegment with: aBlElement context: aContext [
	| point1 point2 blElement |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDSegment with: blElement context: aContext.
	
	point1 := self processor projection projCartToPixel: aDSegment coordinates.
	point2 := self processor projection projCartToPixel: aDSegment coordinates2.
	
	blElement := BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: point1);
		toAnchor: (BlAbsolutePositionAnchor position: point2);
		yourself.

	^blElement
]

{ #category : #processing }
DSegmentBlocProcessData >> processUpdatedData: aKey incoming: aDSegment with: aBlElement context: aContext [
	| point1 point2 |
	super processUpdatedData: aKey incoming: aDSegment with: aBlElement context: aContext.
	
	point1 := self processor projection projCartToPixel: aDSegment coordinates.
	point2 := self processor projection projCartToPixel: aDSegment coordinates2.
	
	aBlElement
		fromAnchor: (BlAbsolutePositionAnchor position: point1);
		toAnchor: (BlAbsolutePositionAnchor position: point2);
		border: (BlBorder paint: aDSegment fillColor width: aDSegment strokeWidth).
		
	^ aBlElement
]
