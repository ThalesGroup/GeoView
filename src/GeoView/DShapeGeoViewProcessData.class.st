Class {
	#name : #DShapeGeoViewProcessData,
	#superclass : #SmockProcessData,
	#traits : 'TSmockDShapeProcessData',
	#classTraits : 'TSmockDShapeProcessData classTrait',
	#category : #'GeoView-ProcessDatas'
}

{ #category : #accessing }
DShapeGeoViewProcessData class >> isAbstract [ 

	^ self == DShapeGeoViewProcessData
]

{ #category : #computing }
DShapeGeoViewProcessData >> computePositionFor: aDShape context: aContext [
	"Compute the position of DShape and return it considering all additional properties"
	| offset position |
	
	"device offset is a graphic translation of the dShape (in graphics coordinates, i.e. pixel), by default the shape is not translated"
	offset := aDShape coordinatesDeviceOffset ifNil: [ 0 @ 0 ].
	
	"when the shape haven't coordinates, that mean the shape is managed by a parent (i.e. a dComposite), return an offset if exists"
	aDShape coordinates ifNil: [ ^ offset ].
	self processor ifNil: [ ^ nil ].

	"Return device coordinates only for draw mode device and position not managed by the parent"
	(aDShape isDrawModeDevice and: [ aDShape isTranslatedByParent ])
		ifTrue: [ ^ aDShape coordinates + offset ].

	"projection the position from cartesian (after the map projection) to the graphic coordinates (screen)"
	position := (self processor projection projCartToPixel:
		             aDShape coordinates) ifNil: [ 0 @ 0 ].
	
	"add offset if needed"
	^ position + offset
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
	
	^ aProducedData
]

{ #category : #processing }
DShapeGeoViewProcessData >> processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	| position |
	(aDShape isNil or: [ aGShape2D isNil ]) ifTrue: [ ^ nil ].
	self processUpdatedDShape: aKey incoming: aDShape with: aGShape2D context: aContext.
	
	"Update geo position"
	position := self computePositionFor: aDShape context: aContext.	
	aGShape2D position: position.
	
	"Compute display mask"
	self processor displayFilter ifNotNil:[ :displayFilter | 
		displayFilter processDShape: aDShape toGShape: aGShape2D.
	].

	"Inject effect pointer"
	aGShape2D effect: aDShape effect.
	
	^ aGShape2D
]
