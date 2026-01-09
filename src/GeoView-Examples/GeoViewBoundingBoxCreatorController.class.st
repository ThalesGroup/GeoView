Class {
	#name : #GeoViewBoundingBoxCreatorController,
	#superclass : #BlEventListener,
	#instVars : [
		'isOnCreation',
		'boundingBox',
		'helperShape',
		'geoView',
		'key'
	],
	#category : #'GeoView-Examples-Utils'
}

{ #category : #'dnd handlers' }
GeoViewBoundingBoxCreatorController >> dragEvent: anEvent [

	| coordinates width height formulas stream |
	self isOnCreation ifFalse: [ ^ self ].

	anEvent consume.

	coordinates := geoView absoluteCoordinatesFromGlobalPoint:
		               anEvent position.
	coordinates ifNil: [ ^ self ].

	boundingBox ifNil: [
			boundingBox := GeoBoundingBox new key: self getNewKey.
			boundingBox strokeStyle: (Color random asSmockStrokeStyle width: 2).
			boundingBox topLeftAbsoluteCoordinates: coordinates.
			geoView addObject: boundingBox ].

	boundingBox bottomRightAbsoluteCoordinates: coordinates.
	geoView updateObject: boundingBox.
	
	"update helper"
	(boundingBox notNil and:[ boundingBox isValid ]) ifFalse: [ ^ self ].
	
	formulas := GeodesicVincentyFormulas new.
	width := formulas distanceInMetersFrom: boundingBox topLeftAbsoluteCoordinates to: boundingBox topRightAbsoluteCoordinates.
	height := formulas distanceInMetersFrom: boundingBox topLeftAbsoluteCoordinates to: boundingBox bottomLeftAbsoluteCoordinates.
	
	stream := ReadWriteStream on: String new.
	stream 
		nextPutAll: (width rounded) printString;
		nextPutAll: 'm x'; space;
		nextPutAll: (height rounded) printString;
		nextPutAll: 'm'.
	
	helperShape 
		text: stream contents; 
		coordinates: ((geoView localPointFromAbsoluteCoordinates: boundingBox topLeftAbsoluteCoordinates)).
	
	self helpersLayer updateDShape: helperShape.
]

{ #category : #'dnd handlers' }
GeoViewBoundingBoxCreatorController >> dragStartEvent: anEvent [

	self isOnCreation ifFalse:[ ^ self ].

	anEvent consume.
]

{ #category : #'dnd handlers' }
GeoViewBoundingBoxCreatorController >> dropEvent: anEvent [
	
	self isOnCreation ifFalse:[ ^ self ].

	anEvent consume.

	(boundingBox topLeftAbsoluteCoordinates isValid and: [
		 boundingBox bottomRightAbsoluteCoordinates isValid ]) ifFalse: [
			geoView removeObject: boundingBox.
			key := key - 1 ].

	self stopCreation
]

{ #category : #private }
GeoViewBoundingBoxCreatorController >> getNewKey [

	key ifNil:[ key := 0 ].
	key := key + 1.
	^ key
]

{ #category : #private }
GeoViewBoundingBoxCreatorController >> helpersLayer [

	^ geoView getLayer: #helpers
]

{ #category : #accessing }
GeoViewBoundingBoxCreatorController >> isOnCreation [

	^ isOnCreation ifNil: [ isOnCreation := false ]
]

{ #category : #accessing }
GeoViewBoundingBoxCreatorController >> isOnCreation: anObject [

	isOnCreation := anObject
]

{ #category : #'keyboard handlers' }
GeoViewBoundingBoxCreatorController >> keyUpEvent: anEvent [

	self isOnCreation ifFalse: [ ^ self ].
	anEvent key = KeyboardKey escape ifFalse: [ ^ self ].
	
	anEvent consume.
	self stopCreation
]

{ #category : #'mouse handlers' }
GeoViewBoundingBoxCreatorController >> mouseMoveEvent: anEvent [

	| coordinates stream |
	self isOnCreation ifFalse:[ ^ self ].
	
	coordinates := geoView absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil:[ ^ self ].

	stream := ReadWriteStream on: String new.
	stream nextPutAll: 'Create from:'; space.
	coordinates printOn: stream.
	
	helperShape coordinates: ((geoView localPointFromAbsoluteCoordinates: coordinates) + (0@ -20)).
	helperShape text: stream contents.

	self helpersLayer updateDShape: helperShape
]

{ #category : #'api - hooks' }
GeoViewBoundingBoxCreatorController >> onInstalledIn: aGeoView [

	super onInstalledIn: aGeoView.
	
	geoView := aGeoView
]

{ #category : #'api - hooks' }
GeoViewBoundingBoxCreatorController >> onUninstalledIn: aGeoView [

	self stopCreation.
	geoView := nil.
	
	super onUninstalledIn: aGeoView.
]

{ #category : #API }
GeoViewBoundingBoxCreatorController >> startCreation [
	"the object to create"

	self isOnCreation: true.
	geoView interactionsStrategy allowMapMoving: false.
	
	geoView focused: true.
	
	"the object to help user (show a text)"
	helperShape ifNil: [ helperShape := SmockDText new key: #helper ].
	helperShape
		text: nil;
		setDrawModeDevice;
		smockFont: (SmockFont defaultFont fontSize: 10);
		fillColor: Color white;
		effect: (SmockBackgroundEffect new
				 fillColor: (Color black alpha: 0.66);
				 padding: (SmockInsets all: 3)).

	self helpersLayer addDShape: helperShape
]

{ #category : #API }
GeoViewBoundingBoxCreatorController >> stopCreation [

	self isOnCreation: false.
	self helpersLayer removeAllDShapes. 
	boundingBox := nil.
	
	geoView interactionsStrategy allowMapMoving: true.
]
