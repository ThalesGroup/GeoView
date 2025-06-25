"
This class define default user interactions (using Bloc event handler) with a geo view.
This class provided classical mouse and keyboard ergonomic to move, scale and select objets.
"
Class {
	#name : #GeoViewInteractionsStrategy,
	#superclass : #BlEventListener,
	#instVars : [
		'allowMapMoving',
		'allowMapScaling',
		'isMapMoving',
		'mouseDownPosition',
		'pickingRadius',
		'lastMouseMoveEventTimestamp'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewInteractionsStrategy >> allowMapMoving [

	^ allowMapMoving ifNil:[ allowMapMoving := true ]
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> allowMapMoving: anObject [

	allowMapMoving := anObject
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> allowMapScaling [

	^ allowMapScaling ifNil:[ allowMapScaling := true ]
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> allowMapScaling: anObject [

	allowMapScaling := anObject
]

{ #category : #'mouse handlers' }
GeoViewInteractionsStrategy >> clickEvent: anEvent [
	"pick the geoview on click"

	| element point pickingResult event |
	self flag:'laborde, need to report bloc bug because there is a click with a drag... patch with checking mouse down position'.
	self isMapMoving ifTrue:[^ self].
	
	element := anEvent currentTarget.
	point := anEvent position.
	
	pickingResult := element pickAt: point radius: self pickingRadius.

	"send picking event"
	event := GeoViewPickingEvent new.
	event pickingResult: pickingResult.
	element dispatchEvent: event.

	"process selection events"
	anEvent modifiers isCtrl
		ifTrue: [
			pickingResult isEmpty ifFalse: [ | selected notSelected |
				selected := OrderedCollection new.
				notSelected := OrderedCollection new.
				
				"When a minimum of 1 object is under the mouse with Ctrl key press, add all objets of the list in the selection"
				pickingResult results do:[ :e | e dShape isSelected ifTrue:[ selected add: e objectIndex ] ifFalse:[ notSelected add: e objectIndex ] ].
				
				notSelected ifNotEmpty: [ 
					event := GeoViewObjectSelectionAdded new.
					event objectIndexesList: notSelected.
					element dispatchEvent: event
				].
			
				selected ifNotEmpty: [ 
					event := GeoViewObjectSelectionRemoved new.
					event objectIndexesList: selected.
					element dispatchEvent: event
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
			element dispatchEvent: event ]
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
		duration := anEvent timestamp - lastMouseMoveEventTimestamp.
		duration < self pulsePeriodInMs ifTrue:[ ^ self ].  
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
	
	| element point mapProjection graphicProjection geoPoint geoPointPx geoCenterPx difPx geoPointPxNew newPointPx geoPointFinal |

	self allowMapScaling ifFalse:[ ^ self ].
	element := anEvent currentTarget.
	point := anEvent position.
	
	mapProjection := element mapProjection ifNil:[ ^ self ].
	graphicProjection := element displayToGraphicProjection ifNil:[ ^ self ].

	geoPoint := element absoluteCoordinatesFromGlobalPoint: point.
	geoPointPx := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: geoPoint).
	geoCenterPx := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: element geoCenter).
	
	geoPointPx ifNil:[ ^ self ].
	geoCenterPx ifNil:[ ^ self ].
	
	"Compute diff from mouse position to view center in pixel before scale"
	difPx := geoCenterPx - geoPointPx.
	
	"Scale"
	anEvent isScrollDown 
		ifTrue: [ element scaleDown ] 
		ifFalse:[ anEvent isScrollUp ifTrue: [ element scaleUp ] ifFalse:[ ^ self ] ].
	
	self allowMapMoving ifFalse:[ ^ self ].
	
	"compute new position in pixel for the mouse position before zoom"
	geoPointPxNew := graphicProjection projCartToPixel: (mapProjection projLatLonToCart: geoPoint).
	"add the previous diff in pixels to get new center in pixel"
	newPointPx := geoPointPxNew + difPx.
	"Compute new position in cartesian for new center"
	geoPointFinal := element absoluteCoordinatesFromGlobalPoint: newPointPx.
	element geoCenter: geoPointFinal.
]

{ #category : #'events - processing' }
GeoViewInteractionsStrategy >> moveMap: anEvent [ 

	| point difPx geoCenterPx element |
	
	self allowMapMoving ifFalse:[ ^ self ].
	element := anEvent currentTarget ifNil: [ ^ self ].

	point := anEvent position.
	difPx := self mouseDownPosition - point.
	difPx := difPx x @ difPx y.
	geoCenterPx := element globalPointFromAbsoluteCoordinates: element geoCenter.
	geoCenterPx ifNil: [ ^ self ].
	geoCenterPx := geoCenterPx + difPx.

	"Update mouse down position with this event"
	self mouseDownPosition: point copy.

	element centerOnGlobalPoint: geoCenterPx.
]

{ #category : #picking }
GeoViewInteractionsStrategy >> pickingRadius [
	"Consider this radius as a device coordinates (i.e. pixels)"

	^ pickingRadius ifNil: [ pickingRadius := 5 ]
]

{ #category : #picking }
GeoViewInteractionsStrategy >> pickingRadius: aNumber [

	pickingRadius := aNumber
]

{ #category : #accessing }
GeoViewInteractionsStrategy >> pulsePeriodInMs [
	"BlHostPulseLoop>>defaultPulsePeriod"

	^ 15 milliSecond
]

{ #category : #'events - processing' }
GeoViewInteractionsStrategy >> sendMouseCoordinatesChanged: anEvent [

	| element coordinates event |
	element := anEvent currentTarget.
	
	"Calculate the absolute coordinates (lat/lon) under the mouse cursor"
	coordinates := element absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil:[ ^ self ].
	
	event := GeoViewCursorCoordinatesChangedEvent new.
	event absoluteCoordinates: coordinates.
	element dispatchEvent: event.
]
