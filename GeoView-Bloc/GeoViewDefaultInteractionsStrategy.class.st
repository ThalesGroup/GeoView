Class {
	#name : #GeoViewDefaultInteractionsStrategy,
	#superclass : #BlEventListener,
	#instVars : [
		'isMapMoving',
		'mouseDownPosition'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> isMapMoving [

	^ isMapMoving ifNil: [ isMapMoving := false ]
]

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> isMapMoving: aBoolean [

	isMapMoving := aBoolean
]

{ #category : #'mouse handlers' }
GeoViewDefaultInteractionsStrategy >> mouseDownEvent: anEvent [

	self mouseDownPosition: anEvent position.
	self isMapMoving: true
]

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> mouseDownPosition [

	^ mouseDownPosition
]

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> mouseDownPosition: aPoint [

	mouseDownPosition := aPoint
]

{ #category : #'mouse handlers' }
GeoViewDefaultInteractionsStrategy >> mouseMoveEvent: anEvent [

	self sendMouseCoordinatesChanged: anEvent.
	
	"Process mouse map moving"
	self isMapMoving ifTrue:[ self moveMap: anEvent ].

]

{ #category : #'mouse handlers' }
GeoViewDefaultInteractionsStrategy >> mouseUpEvent: anEvent [

	self isMapMoving: false
]

{ #category : #'mouse handlers' }
GeoViewDefaultInteractionsStrategy >> mouseWheelEvent: anEvent [
	"Scale the map(zoom in or zoom out) but stay centered behind the mouse position"
	
	| element point mapProjection graphicProjection geoPoint geoPointPx geoCenterPx difPx geoPointPxNew newPointPx geoPointFinal |

	element := anEvent currentTarget.
	point := anEvent position.
	
	mapProjection := element mapProjection ifNil:[ ^ self ].
	graphicProjection := element displayToGraphicProjection ifNil:[ ^ self ].

	geoPoint := element absoluteCoordinatesFromGlobalPoint: point.
	geoPointPx := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: geoPoint).
	geoCenterPx := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: element geoCenter).
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	anEvent isScrollDown 
		ifTrue: [ element scaleDown ] 
		ifFalse:[ anEvent isScrollUp ifTrue: [ element scaleUp ] ifFalse:[ ^ self ] ].
	
	"compute new position in pixel for the mouse position before zoom"
	geoPointPxNew := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := element absoluteCoordinatesFromGlobalPoint: newPointPx.
	element geoCenter: geoPointFinal.
]

{ #category : #'events - processing' }
GeoViewDefaultInteractionsStrategy >> moveMap: anEvent [ 

	| point difPx geoCenterPx element |
	element := anEvent currentTarget ifNil: [ ^ self ].

	point := anEvent position.
	difPx := self mouseDownPosition - point.
	difPx := difPx x @ difPx y negated.
	geoCenterPx := element globalPointFromAbsoluteCoordinates: element geoCenter.
	geoCenterPx ifNil: [ ^ self ].
	geoCenterPx := geoCenterPx + difPx.

	"Update mouse down position with this event"
	self mouseDownPosition: point copy.

	element centerOnGlobalPoint: geoCenterPx.
]

{ #category : #'events - processing' }
GeoViewDefaultInteractionsStrategy >> sendMouseCoordinatesChanged: anEvent [

	| element coordinates geoViewEvent |
	element := anEvent currentTarget.
	
	"Calculate the absolute coordinates (lat/lon) under the mouse cursor"
	coordinates := element absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil:[ ^ self ].
	
	geoViewEvent := GeoViewCursorCoordinatesChangedEvent new.
	geoViewEvent absoluteCoordinates: coordinates.
	element dispatchEvent: geoViewEvent.
]
