"
Behavior for navigation and manipulation of the view (zoom and pan)
"
Class {
	#name : #GeoViewBlocMapNavigationBehavior,
	#superclass : #GeoViewEventBehavior,
	#instVars : [
		'isMapMoving',
		'previousPoint'
	],
	#category : #'GeoView-Bloc-Strategy'
}

{ #category : #accessing }
GeoViewBlocMapNavigationBehavior >> initialize [
	super initialize.
	isMapMoving := false.
]

{ #category : #accessing }
GeoViewBlocMapNavigationBehavior >> isMapMoving [
	^ isMapMoving
]

{ #category : #accessing }
GeoViewBlocMapNavigationBehavior >> isMapMoving: anObject [
	isMapMoving := anObject
]

{ #category : #'event processing' }
GeoViewBlocMapNavigationBehavior >> keyDown: aPenEvent [
	"self geoViewManager scaleDown.
	aPenEvent isConsumed: true. "
]

{ #category : #'event processing' }
GeoViewBlocMapNavigationBehavior >> keyUp: aPenEvent [
	"self geoViewManager scaleDown.
	aPenEvent isConsumed: true. "
]

{ #category : #'event processing' }
GeoViewBlocMapNavigationBehavior >> moveMap: aBlMouseMoveEvent [
	| point difPx geoCenterPx |
	
	point := aBlMouseMoveEvent position.
	difPx := self previousPoint - point.
	difPx := (difPx x) @ (difPx y negated).
	geoCenterPx := self geoViewManager getGlobalPointFromAbsoluteCoordinates: self geoViewManager getGeoCenter.
	geoCenterPx := geoCenterPx + difPx.
	self geoViewManager centerOnPoint: geoCenterPx.
	self previousPoint: point copy.
	
	aBlMouseMoveEvent consumed: true. 
]

{ #category : #accessing }
GeoViewBlocMapNavigationBehavior >> previousPoint [
	^ previousPoint
]

{ #category : #accessing }
GeoViewBlocMapNavigationBehavior >> previousPoint: anObject [
	previousPoint := anObject
]

{ #category : #'event handling' }
GeoViewBlocMapNavigationBehavior >> receiveEvent: aBlEvent [
	"manage mouse move cursor information"

	aBlEvent isMouse ifTrue: [ 
		aBlEvent isMouseMove ifTrue: [ 
			self isMapMoving 
				ifTrue: [ self moveMap: aBlEvent. "stop event processing and consume event" ^true ].
			^false
		].	

		"manage zoom on wheel"
		aBlEvent class = BlMouseWheelEvent ifTrue: [ 
			aBlEvent isScrollDown ifTrue: [self scrollDown: aBlEvent. "stop event processing and consume event" ^true].
			aBlEvent isScrollUp ifTrue: [self scrollUp: aBlEvent. "stop event processing and consume event" ^true].
		].
	
		"manage geocenter on drag'n'drop"
		aBlEvent isMouseDown ifTrue: [ 
			self previousPoint: aBlEvent position copy. 
			self isMapMoving: true. 
			^self 
		].
		aBlEvent isMouseUp ifTrue: [ 
			self isMapMoving: false. 
			^self 
		].
	].

	"manage position on key push"
	aBlEvent isKeyboard ifTrue:[
		"manage zoom on wheel" 
		aBlEvent class = BlKeyDownEvent ifTrue:[self keyDown: aBlEvent. ^self].
		aBlEvent class = BlKeyUpEvent ifTrue:[self keyUp: aBlEvent. ^self].
	].
	
]

{ #category : #'event processing' }
GeoViewBlocMapNavigationBehavior >> scrollDown: aBlEvent [
	| point geoPoint projection projection2D geoPointPx geoPointPxNew geoCenterPx difPx newPointPx geoPointFinal |
	point := aBlEvent position.

	projection := self geoViewManager getMapProjectionManagerServicesProvider getProjection.
	projection2D := self geoViewManager view displayToGraphicProjection.

	geoPoint := self geoViewManager getAbsoluteCoordinatesFromGlobalPoint: point.
	geoPointPx := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	geoCenterPx := projection2D projCartToPixel: (projection projLatLonToCart: self geoViewManager getGeoCenter).
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	self geoViewManager scaleDown.
	
	"compute new position in pixel for the mouse position before zoom"
	geoPointPxNew := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := self geoViewManager getAbsoluteCoordinatesFromGlobalPoint: newPointPx.
	self geoViewManager setGeoCenter: geoPointFinal.
	
	aBlEvent consumed: true. 
]

{ #category : #'event processing' }
GeoViewBlocMapNavigationBehavior >> scrollUp: aBlEvent [
	| point geoPoint projection projection2D geoPointPx geoCenterPx difPx newPointPx geoPointFinal geoPointPxNew |
	point := aBlEvent position.

	projection := self geoViewManager getMapProjectionManagerServicesProvider getProjection.
	projection2D := self geoViewManager view displayToGraphicProjection.

	geoPoint := self geoViewManager getAbsoluteCoordinatesFromGlobalPoint: point.
	geoPointPx := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	geoCenterPx := projection2D projCartToPixel: (projection projLatLonToCart: self geoViewManager getGeoCenter).
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	self geoViewManager scaleUp.
	
	"compute new position in pixel for the mouse position before zoom"
	geoPointPxNew := projection2D projCartToPixel: (projection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := self geoViewManager getAbsoluteCoordinatesFromGlobalPoint: newPointPx.
	self geoViewManager setGeoCenter: geoPointFinal.
	
	aBlEvent consumed: true. 
]
