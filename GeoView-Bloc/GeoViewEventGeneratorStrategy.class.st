Class {
	#name : #GeoViewEventGeneratorStrategy,
	#superclass : #BlEventListener,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'mouse handlers' }
GeoViewEventGeneratorStrategy >> mouseMoveEvent: anEvent [

	| element coordinates geoViewEvent |
	element := anEvent currentTarget.
	coordinates := element absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil:[ ^ self ].
	
	geoViewEvent := GeoViewCursorCoordinatesChangedEvent new.
	geoViewEvent absoluteCoordinates: coordinates.
	
	element dispatchEvent: geoViewEvent

]

{ #category : #'event handling' }
GeoViewEventGeneratorStrategy >> processEvent: aSmockEventWrapper context: aSmockInputContext [

	| event coordinates geoViewMng |
	self deprecated: 'not used'.
	event := aSmockEventWrapper event.
	event isMouse ifFalse:[ ^ self ].
	event isMouseMove ifFalse: [ ^ self ].
	
	geoViewMng := aSmockInputContext controller ifNil:[ ^ self ].
	coordinates := geoViewMng absoluteCoordinatesFromGlobalPoint: event position.
	coordinates ifNotNil:[ 
		self flag:'labordep : faire une notification GeoView (avec event handler) ici pour savoir que le curseur a changé'.
		(geoViewMng isKindOf: GeoViewManager) ifTrue:[ geoViewMng mouseCursorCoordinatesChanged: coordinates ]. 
	].
	
	aSmockEventWrapper isConsumed: true
]
