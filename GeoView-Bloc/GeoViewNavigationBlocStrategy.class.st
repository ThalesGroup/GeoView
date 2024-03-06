Class {
	#name : #GeoViewNavigationBlocStrategy,
	#superclass : #GeoViewBlocInputStrategy,
	#instVars : [
		'isMapMoving',
		'previousPoint'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #accessing }
GeoViewNavigationBlocStrategy >> isMapMoving [

	^ isMapMoving ifNil:[ isMapMoving := false ]
]

{ #category : #accessing }
GeoViewNavigationBlocStrategy >> isMapMoving: anObject [

	isMapMoving := anObject
]

{ #category : #'event handling' }
GeoViewNavigationBlocStrategy >> keyDown: aSmockEventWrapper context: aSmockInputContext [
	
	self flag:'labordep: todo'.
]

{ #category : #'event handling' }
GeoViewNavigationBlocStrategy >> keyUp: aSmockEventWrapper context: aSmockInputContext [
	
	self flag:'labordep: todo'.
]

{ #category : #'event handling' }
GeoViewNavigationBlocStrategy >> moveMap: aSmockEventWrapper context: aSmockInputContext [
	| point difPx geoCenterPx geoViewMng |
	
	geoViewMng := aSmockInputContext controller ifNil:[ ^ self ].
	
	point := aSmockEventWrapper event position.
	difPx := self previousPoint - point.
	difPx := (difPx x) @ (difPx y negated).
	geoCenterPx := geoViewMng getGlobalPointFromAbsoluteCoordinates: geoViewMng getGeoCenter.
	geoCenterPx ifNil:[ ^ self ].
	
	geoCenterPx := geoCenterPx + difPx.
	geoViewMng centerOnPoint: geoCenterPx.
	
	self previousPoint: point copy.
	aSmockEventWrapper isConsumed: true. 
]

{ #category : #accessing }
GeoViewNavigationBlocStrategy >> previousPoint [

	^ previousPoint
]

{ #category : #accessing }
GeoViewNavigationBlocStrategy >> previousPoint: anObject [

	previousPoint := anObject
]

{ #category : #'event handling' }
GeoViewNavigationBlocStrategy >> processEvent: aSmockEventWrapper context: aSmockInputContext [
	"Manage mouse cursor"
	
	| event |
	event := aSmockEventWrapper event.
	
	event isMouse ifTrue: [ 
		event isMouseMove ifTrue: [ 
			self isMapMoving 
				ifTrue: [ self moveMap: aSmockEventWrapper context: aSmockInputContext. "stop event processing and consume event" ^true ].
			^false
		].	

		"manage zoom on wheel"
		event class = BlMouseWheelEvent ifTrue: [ 
			event isScrollDown ifTrue: [self scrollDown: aSmockEventWrapper context: aSmockInputContext. "stop event processing and consume event" ^true].
			event isScrollUp ifTrue: [self scrollUp: aSmockEventWrapper context: aSmockInputContext. "stop event processing and consume event" ^true].
		].
	
		"manage geocenter on drag'n'drop"
		event isMouseDown ifTrue: [ 
			self previousPoint: event position copy. 
			self isMapMoving: true. 
			^self 
		].
		event isMouseUp ifTrue: [ 
			self isMapMoving: false. 
			^self 
		].
	].

	"manage position on key push"
	event isKeyboard ifTrue:[
		"manage zoom on wheel" 
		event class = BlKeyDownEvent ifTrue:[self keyDown: aSmockEventWrapper context: aSmockInputContext. ^self].
		event class = BlKeyUpEvent ifTrue:[self keyUp: aSmockEventWrapper context: aSmockInputContext. ^self].
	].
]

{ #category : #'event handling' }
GeoViewNavigationBlocStrategy >> scrollDown: aSmockEventWrapper context: aSmockInputContext [
	| point geoPoint projection projection2D geoPointPx geoPointPxNew geoCenterPx difPx newPointPx geoPointFinal geoViewMng |
	
	geoViewMng := aSmockInputContext controller ifNil:[ ^ self ].
	point := aSmockEventWrapper event position.

	projection := geoViewMng getMapProjectionManagerServicesProvider getProjection.
	projection ifNil:[ ^ self ].
	
	projection2D := geoViewMng view displayToGraphicProjection.

	geoPoint := geoViewMng getAbsoluteCoordinatesFromGlobalPoint: point.
	geoPointPx := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	geoCenterPx := projection2D projCartToPixel: (projection projLatLonToCart: geoViewMng getGeoCenter).
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	geoViewMng scaleDown.
	
	"compute new position in pixel for the mouse position before zoom"
	geoPointPxNew := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := geoViewMng getAbsoluteCoordinatesFromGlobalPoint: newPointPx.
	geoViewMng setGeoCenter: geoPointFinal.
	
	aSmockEventWrapper isConsumed: true. 
]

{ #category : #'event handling' }
GeoViewNavigationBlocStrategy >> scrollUp: aSmockEventWrapper context: aSmockInputContext [
	| point geoPoint projection projection2D geoPointPx geoPointPxNew geoCenterPx difPx newPointPx geoPointFinal geoViewMng |
	
	geoViewMng := aSmockInputContext controller ifNil:[ ^ self ].
	point := aSmockEventWrapper event position.

	projection := geoViewMng getMapProjectionManagerServicesProvider getProjection.
	projection ifNil:[ ^ self ].
	
	projection2D := geoViewMng view displayToGraphicProjection.

	geoPoint := geoViewMng getAbsoluteCoordinatesFromGlobalPoint: point.
	geoPointPx := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	geoCenterPx := projection2D projCartToPixel: (projection projLatLonToCart: geoViewMng getGeoCenter).
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	geoViewMng scaleUp.
	
	"compute new position in pixel for the mouse position before zoom"
	geoPointPxNew := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := geoViewMng getAbsoluteCoordinatesFromGlobalPoint: newPointPx.
	geoViewMng setGeoCenter: geoPointFinal.
	
	aSmockEventWrapper isConsumed: true. 
]
