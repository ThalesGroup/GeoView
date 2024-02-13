Class {
	#name : #DShapeGeoViewAeProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-Bloc-Alexandrie-GShape-ProcessData'
}

{ #category : #accessing }
DShapeGeoViewAeProcessData class >> isAbstract [ 

	^ self = DShapeGeoViewAeProcessData
]

{ #category : #processing }
DShapeGeoViewAeProcessData >> computePositionFor: aDShape context: aContext [
	
	aDShape coordinates ifNil:[ ^ nil ].
	self processor ifNil:[ ^ nil ].
	
	^ self processor projection projCartToPixel: aDShape coordinates
]

{ #category : #processing }
DShapeGeoViewAeProcessData >> processCreatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	(aDShape isNil or: [ aGShape2D isNil ]) ifTrue: [ ^ nil ].
	aGShape2D id: aKey asString.
	^ aGShape2D
]

{ #category : #processing }
DShapeGeoViewAeProcessData >> processDeletedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	^ aGShape2D
]

{ #category : #processing }
DShapeGeoViewAeProcessData >> processStateChanged: aKey state: aState value: aValueOrNil with: aProducedData context: aContext [

	"do nothing"
]

{ #category : #processing }
DShapeGeoViewAeProcessData >> processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	| position |
	(aDShape isNil or: [ aGShape2D isNil ]) ifTrue: [ ^ nil ].
	aGShape2D isVisible: aDShape isVisible.
	aGShape2D properties: (aDShape properties copy).

	position := self computePositionFor: aDShape context: aContext.	
	aGShape2D position: (position ifNil:[ 0@0 ]).
	
	^ aGShape2D
]
