Class {
	#name : #DShapeGeoViewProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-GShape-ProcessData'
}

{ #category : #accessing }
DShapeGeoViewProcessData class >> isAbstract [ 

	^ self = DShapeGeoViewProcessData
]

{ #category : #processing }
DShapeGeoViewProcessData >> computePositionFor: aDShape context: aContext [
	
	aDShape coordinates ifNil:[ ^ nil ].
	self processor ifNil:[ ^ nil ].
	
	^ self processor projection projCartToPixel: aDShape coordinates
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
