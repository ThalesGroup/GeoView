Class {
	#name : #DArcBandBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DArcBandBlocProcessData >> processCreatedData: aKey incoming: aDArcBand with: aBlElement context: aContext [
	| blSector radiusMin radiusMax angle orientation blElement position |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDArcBand with: blElement context: aContext.
	
	radiusMin := self processor projection metersByPixel * aDArcBand radiusMin.
	radiusMax := self processor projection metersByPixel * aDArcBand radiusMax.
	angle := aDArcBand aperture radiansToDegrees.
	orientation := aDArcBand orientation radiansToDegrees - 90.
	
	blSector := BlArcBand
		startRadius: radiusMin
		endRadius: radiusMax
		sweepAngle: angle
		orientation: orientation.
	blElement geometry: blSector.
	
	aDArcBand coordinates isNil ifFalse:[
		position := self processor projection projCartToPixel: aDArcBand coordinates.
		blElement relocate: position.
	].

	^blElement
]

{ #category : #processing }
DArcBandBlocProcessData >> processUpdatedData: aKey incoming: aDArcBand with: aBlElement context: aContext [
	| blSector radiusMin radiusMax angle orientation |
	super processUpdatedData: aKey incoming: aDArcBand with: aBlElement context: aContext.
	
	blSector := aBlElement geometry.
	
	radiusMin := self processor projection metersByPixel * aDArcBand radiusMin.
	radiusMax := self processor projection metersByPixel * aDArcBand radiusMax.
	angle := aDArcBand aperture radiansToDegrees.
	orientation := aDArcBand orientation radiansToDegrees - 90.
	blSector 
		startRadius: radiusMin;
		endRadius: radiusMax;
		sweepAngle: angle;
		orientation: orientation.
	aBlElement size: blSector size.
	
	aDArcBand coordinates isNil
		ifFalse: [ aBlElement relocate: (self processor projection projCartToPixel: aDArcBand coordinates) ]
		ifTrue: [ aBlElement relocate: 0 @ 0 ].
		
	^ aBlElement
]
