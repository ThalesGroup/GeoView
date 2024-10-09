"
This class define default user interactions (using Bloc event handler) with a geo view.
This class provided classical mouse and keyboard ergonomic to move, scale and select objets.
"
Class {
	#name : #GeoViewDefaultInteractionsStrategy,
	#superclass : #BlEventListener,
	#instVars : [
		'allowMapMoving',
		'allowMapScaling',
		'isMapMoving',
		'mouseDownPosition',
		'pickingRadius'
	],
	#category : #'GeoView-Bloc'
}

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> allowMapMoving [

	^ allowMapMoving ifNil:[ allowMapMoving := true ]
]

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> allowMapMoving: anObject [

	allowMapMoving := anObject
]

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> allowMapScaling [

	^ allowMapScaling ifNil:[ allowMapScaling := true ]
]

{ #category : #accessing }
GeoViewDefaultInteractionsStrategy >> allowMapScaling: anObject [

	allowMapScaling := anObject
]

{ #category : #'mouse handlers' }
GeoViewDefaultInteractionsStrategy >> clickEvent: anEvent [
	"pick the geoview on click"

	| element point pickingResult geoViewEvent |

	self flag:'laborde, need to report bloc bug because there is a click with a drag... patch with checking mouse down position'.
	self isMapMoving ifTrue:[^ self].
	
	element := anEvent currentTarget.
	point := anEvent position.
	
	pickingResult := element pickAt: point radius: self pickingRadius.

	"send picking event"
	geoViewEvent := GeoViewPickingEvent new.
	geoViewEvent pickingResult: pickingResult.
	element dispatchEvent: geoViewEvent.

	"process selection events"
	anEvent modifiers isCtrl
		ifTrue: [
			pickingResult isEmpty ifFalse: [ | selected notSelected |
				selected := OrderedCollection new.
				notSelected := OrderedCollection new.
				
				"When a minimum of 1 object is under the mouse with Ctrl key press, add all objets of the list in the selection"
				pickingResult results do:[ :e | e dShape isSelected ifTrue:[ selected add: e objectIndex ] ifFalse:[ notSelected add: e objectIndex ] ].
				
				notSelected ifNotEmpty: [ 
					geoViewEvent := GeoViewObjectSelectionAdded new.
					geoViewEvent objectIndexesList: notSelected.
					element dispatchEvent: geoViewEvent
				].
			
				selected ifNotEmpty: [ 
					geoViewEvent := GeoViewObjectSelectionRemoved new.
					geoViewEvent objectIndexesList: selected.
					element dispatchEvent: geoViewEvent
				].
				
			] ifTrue:[ "doing nothing here : stay the selection" ] ] 
		ifFalse: [
			pickingResult isEmpty
				ifTrue: [ 
					"When no objects are under the mouse, clear the selection" 
					geoViewEvent := GeoViewObjectSelectionCleared new ]
				ifFalse: [
					"When a minimum of 1 object is under the mouse (without Ctrl key press), select only the first object"
					geoViewEvent := GeoViewObjectSelectionChanged new.
					geoViewEvent objectIndexesList: (OrderedCollection with: pickingResult firstElement objectIndex) ].
			element dispatchEvent: geoViewEvent ]
]

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

	self allowMapScaling ifFalse:[ ^ self ].
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
GeoViewDefaultInteractionsStrategy >> moveMap: anEvent [ 

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
GeoViewDefaultInteractionsStrategy >> pickingRadius [
	"Consider this radius as a device coordinates (i.e. pixels)"
	
	^ pickingRadius ifNil:[ pickingRadius := 5 ]
]

{ #category : #picking }
GeoViewDefaultInteractionsStrategy >> pickingRadius: aNumber [

	pickingRadius := aNumber
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
