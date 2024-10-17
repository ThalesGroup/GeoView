Class {
	#name : #DShapeGeoViewProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #accessing }
DShapeGeoViewProcessData class >> isAbstract [ 

	^ self = DShapeGeoViewProcessData
]

{ #category : #processing }
DShapeGeoViewProcessData >> computePositionFor: aDShape context: aContext [

	| offset |
	aDShape coordinates ifNil: [ ^ aDShape coordinatesDeviceOffset ].
	self processor ifNil: [ ^ nil ].

	offset := aDShape coordinatesDeviceOffset ifNil: [ 0 @ 0 ].

	(aDShape isComposite not and: [ aDShape isDrawModeDevice ]) ifTrue: [
		^ aDShape coordinates + offset ].

	^ (self processor projection projCartToPixel: aDShape coordinates)
	  + offset
]

{ #category : #processing }
DShapeGeoViewProcessData >> processCreatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	(aDShape isNil or: [ aGShape2D isNil ]) ifTrue: [ ^ nil ].
	aGShape2D id: aKey asString.
	^ aGShape2D
]

{ #category : #processing }
DShapeGeoViewProcessData >> processDeletedData: aKey incoming: aDShape with: aGShape2D context: aContext [

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
	aGShape2D isVisible: aDShape isVisible.
	aGShape2D properties: (aDShape properties copy).
	aGShape2D isTranslatedByParent: aDShape isTranslatedByParent.
	position := self computePositionFor: aDShape context: aContext.	
	aGShape2D position: (position ifNil:[ 0@0 ]).
	
	^ aGShape2D
]
