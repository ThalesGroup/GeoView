"
This class define default user interactions (using Bloc event handler) with a geo view.
This class provided classical mouse and keyboard ergonomic to move, scale and select objets.
"
Class {
	#name : #GeoViewInteractionsStrategy,
	#superclass : #AbstractGeoViewInteractionsStrategy,
	#instVars : [
		'isMapMoving',
		'mouseDownPosition',
		'lastMouseMoveEventTimestamp'
	],
	#category : #'GeoView-Events'
}

{ #category : #map }
GeoViewInteractionsStrategy >> allowMapMoving: anObject [

	super allowMapMoving: anObject.
	self isMapMoving: nil
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> isMapMoving [

	^ isMapMoving ifNil: [ isMapMoving := false ]
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> isMapMoving: aBoolean [

	isMapMoving := aBoolean
]

{ #category : #'mouse handlers' }
GeoViewInteractionsStrategy >> mouseDownEvent: anEvent [

	self mouseDownPosition: anEvent position.
	self isMapMoving: true
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> mouseDownPosition [

	^ mouseDownPosition
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> mouseDownPosition: aPoint [

	mouseDownPosition := aPoint
]

{ #category : #'mouse handlers' }
GeoViewInteractionsStrategy >> mouseMoveEvent: anEvent [

	"optimize mouse event processing"
	lastMouseMoveEventTimestamp ifNotNil:[ | duration |
		self flag:'labordep: use SmockCommandRunner to sample events'.
		duration := anEvent timestamp - lastMouseMoveEventTimestamp.
		"BlHostPulseLoop>>defaultPulsePeriod"
		duration < 15 milliSecond ifTrue:[ ^ self ].  
	].
	lastMouseMoveEventTimestamp := anEvent timestamp copy.

	self sendMouseCoordinatesChanged: anEvent.
	
	"Process mouse map moving"
	self isMapMoving ifTrue:[ self moveMap: anEvent ].

]

{ #category : #'mouse handlers' }
GeoViewInteractionsStrategy >> mouseUpEvent: anEvent [
	
	self isMapMoving: false
]

{ #category : #'mouse handlers' }
GeoViewInteractionsStrategy >> mouseWheelEvent: anEvent [
	"Scale the map(zoom in or zoom out) but stay centered behind the mouse position"
	
	| point mapProjection graphicProjection geoPoint geoPointPx geoCenterPx difPx geoPointPxNew newPointPx geoPointFinal |

	self allowMapScaling ifFalse:[ ^ self ].

	anEvent consume.

	point := self geoView localPointFromGlobalPoint: anEvent position.
	
	mapProjection := self geoView mapProjection ifNil:[ ^ self ].
	graphicProjection := self geoView displayToGraphicProjection ifNil:[ ^ self ].

	geoPoint := self geoView absoluteCoordinatesFromLocalPoint: point.
	geoPointPx := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: geoPoint).
	geoCenterPx := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: self geoView geoCenter).
	
	geoPointPx ifNil:[ ^ self ].
	geoCenterPx ifNil:[ ^ self ].
	
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	anEvent isScrollDown 
		ifTrue: [ self geoView scaleDown ] 
		ifFalse:[ anEvent isScrollUp ifTrue: [ self geoView scaleUp ] ifFalse:[ ^ self ] ].
	
	self allowMapMoving ifFalse:[ ^ self ].
	
	"compute new position in pixel for the mouse position before zoom"
	
	geoPointPxNew := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := self geoView absoluteCoordinatesFromLocalPoint: newPointPx.
	self geoView geoCenter: geoPointFinal.
]

{ #category : #'events - processing' }
GeoViewInteractionsStrategy >> moveMap: anEvent [ 

	| point difPx geoCenterPx |
	
	self allowMapMoving ifFalse:[ ^ self ].

	anEvent consume.

	point := anEvent position.
	difPx := self mouseDownPosition - point.
	difPx := difPx x @ difPx y.
	geoCenterPx := self geoView globalPointFromAbsoluteCoordinates: self geoView geoCenter.
	geoCenterPx ifNil: [ ^ self ].
	geoCenterPx := geoCenterPx + difPx.

	"Update mouse down position with this event"
	self mouseDownPosition: point copy.

	self geoView centerOnGlobalPoint: geoCenterPx.
]

{ #category : #'mouse handlers' }
GeoViewInteractionsStrategy >> primaryClickEvent: anEvent [
	"pick the geoview on click"

	| point pickingResult event |
	self flag:'laborde, need to report bloc bug because there is a click with a drag... patch with checking mouse down position'.
	self isMapMoving ifTrue:[^ self].
	
	point := anEvent position.
	
	pickingResult := self geoView pickAt: point radius: self pickingRadius.
	self selectionFilterBlock ifNotNil:[
		pickingResult := pickingResult applyFilter: self selectionFilterBlock
	].

	"send picking event"
	event := GeoViewPickingEvent new.
	event pickingResult: pickingResult.
	self geoView dispatchEvent: event.

	"process selection events"
	(anEvent modifiers isCtrl and:[ self isMultipleSelection ])
		ifTrue: [
			pickingResult isEmpty ifFalse: [ | selected notSelected |
				selected := OrderedCollection new.
				notSelected := OrderedCollection new.
				
				"When a minimum of 1 object is under the mouse with Ctrl key press, add all objets of the list in the selection"
				pickingResult results do:[ :e | e dShape isSelected ifTrue:[ selected add: e objectIndex ] ifFalse:[ notSelected add: e objectIndex ] ].
				
				notSelected ifNotEmpty: [ 
					event := GeoViewObjectSelectionAdded new.
					event objectIndexesList: notSelected.
					self geoView dispatchEvent: event
				].
			
				selected ifNotEmpty: [ 
					event := GeoViewObjectSelectionRemoved new.
					event objectIndexesList: selected.
					self geoView dispatchEvent: event
				].
				
			] ifTrue:[ "doing nothing here : stay the selection" ] ] 
		ifFalse: [
			pickingResult isEmpty
				ifTrue: [ 
					"When no objects are under the mouse, clear the selection" 
					event := GeoViewObjectSelectionCleared new ]
				ifFalse: [
					"When a minimum of 1 object is under the mouse (without Ctrl key press), select only the first object"
					event := GeoViewObjectSelectionChanged new.
					event objectIndexesList: (OrderedCollection with: pickingResult firstElement objectIndex) ].
			self geoView dispatchEvent: event ]
]

{ #category : #'events - processing' }
GeoViewInteractionsStrategy >> sendMouseCoordinatesChanged: anEvent [

	| coordinates event |
	
	"Calculate the absolute coordinates (lat/lon) under the mouse cursor"
	coordinates := self geoView absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil:[ ^ self ].
	
	event := GeoViewCursorCoordinatesChangedEvent new.
	event absoluteCoordinates: coordinates.
	self geoView dispatchEvent: event.
]
