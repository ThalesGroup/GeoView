Class {
	#name : #DShapeGeoViewProcessData,
	#superclass : #SmockProcessData,
	#traits : 'TSmockDShapeProcessData',
	#classTraits : 'TSmockDShapeProcessData classTrait',
	#category : #'GeoView-ProcessDatas'
}

{ #category : #accessing }
DShapeGeoViewProcessData class >> isAbstract [ 

	^ self = DShapeGeoViewProcessData
]

{ #category : #computing }
DShapeGeoViewProcessData >> computePositionFor: aDShape context: aContext [

	| offset isDeviceCoordinates |
	aDShape coordinates ifNil: [ ^ aDShape coordinatesDeviceOffset ].
	self processor ifNil: [ ^ nil ].

	offset := aDShape coordinatesDeviceOffset ifNil: [ 0 @ 0 ].

	isDeviceCoordinates := aDShape coordinates isPoint.
	(aDShape isComposite not and: [ aDShape isDrawModeDevice and:[ isDeviceCoordinates ] ] ) ifTrue: [
		^ aDShape coordinates + offset
	].

	^ (self processor projection projCartToPixel: (aDShape coordinates))
	  + offset
]

{ #category : #processing }
DShapeGeoViewProcessData >> processCreatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	(aDShape isNil or: [ aGShape2D isNil ]) ifTrue: [ ^ nil ].
	self processCreatedDShape: aKey incoming: aDShape with: aGShape2D context: aContext.
	
	^ aGShape2D
]

{ #category : #processing }
DShapeGeoViewProcessData >> processDeletedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	^ aGShape2D
]

{ #category : #processing }
DShapeGeoViewProcessData >> processRecycledData: aKey incoming: aDShape with: aGShape2D context: aContext [
	"clean the GShape"

	self processRecycledDShape: aKey incoming: aDShape with: aGShape2D context: aContext.

	^ aGShape2D
]

{ #category : #processing }
DShapeGeoViewProcessData >> processStateChanged: aKey state: aState value: aValueOrNil with: aProducedData context: aContext [

	"do nothing"
]

{ #category : #processing }
DShapeGeoViewProcessData >> processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	| position |
	(aDShape isNil or: [ aGShape2D isNil ]) ifTrue: [ ^ nil ].
	self processUpdatedDShape: aKey incoming: aDShape with: aGShape2D context: aContext.
	
	"Update geo position"
	position := self computePositionFor: aDShape context: aContext.	
	aGShape2D position: (position ifNil:[ 0@0 ]).
	
	^ aGShape2D
]
