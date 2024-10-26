Class {
	#name : #DCompositeShapeGeoViewProcessData,
	#superclass : #DShapeGeoViewProcessData,
	#traits : 'TSmockDCompositeShapeProcessData',
	#classTraits : 'TSmockDCompositeShapeProcessData classTrait',
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> processCreatedData: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext [

	| gComposite2D |
	gComposite2D := aGCompositeShape2D ifNil: [ SmockGCompositeShape2D id: aKey ].
	
	super processCreatedData: aKey incoming: aDCompositeShape with: gComposite2D context: aContext.
	self processCreatedDComposite: aKey incoming: aDCompositeShape with: gComposite2D context: aContext.
	self processUpdatedData: aKey incoming: aDCompositeShape with: gComposite2D context: aContext.
	
	^ gComposite2D
]

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> processRecycledData: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext [
	"clean the GShape"

	super processRecycledData: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext.
	self processRecycledDComposite: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext.

	^ aGCompositeShape2D
]

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> processUpdatedData: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext [

	super processUpdatedData: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext.
	self processUpdatedDComposite: aKey incoming: aDCompositeShape with: aGCompositeShape2D context: aContext.
	
	^ aGCompositeShape2D
]
