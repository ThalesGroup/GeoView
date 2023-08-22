Class {
	#name : #DSectorBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DSectorBlocProcessData >> processCreatedData: aKey incoming: aDSector with: aBlElement context: aContext [
	| blSector radius angle orientation blElement |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDSector with: blElement context: aContext.
	
	radius := self processor projection metersByPixel * aDSector radius.
	angle := aDSector aperture radiansToDegrees.
	orientation := aDSector orientation radiansToDegrees - 90.
	
	blSector := BlArcBand
		radius: radius
		sweepAngle: angle
		orientation: orientation.
	blElement geometry: blSector.
	
	aDSector coordinates isNil ifFalse:[
		blElement relocate: (self processor projection projCartToPixel: aDSector coordinates).
	].

	^blElement
]

{ #category : #processing }
DSectorBlocProcessData >> processUpdatedData: aKey incoming: aDSector with: aBlElement context: aContext [
	| blSector radius angle orientation |
	super processUpdatedData: aKey incoming: aDSector with: aBlElement context: aContext.
	
	blSector := aBlElement geometry.
	
	radius := self processor projection metersByPixel * aDSector radiusMin.
	angle := aDSector aperture radiansToDegrees.
	orientation := aDSector orientation radiansToDegrees - 90.
	blSector 
		endRadius: radius;
		angle: angle;
		orientation: orientation.
	aBlElement size: blSector size.
	
	aDSector coordinates isNil
		ifFalse: [ aBlElement relocate: (self processor projection projCartToPixel: aDSector coordinates) ]
		ifTrue: [ aBlElement relocate: 0 @ 0 ].
		
	^ aBlElement
]
