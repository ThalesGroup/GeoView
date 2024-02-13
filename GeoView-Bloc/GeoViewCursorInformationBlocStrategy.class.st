Class {
	#name : #GeoViewCursorInformationBlocStrategy,
	#superclass : #GeoViewBlocInputStrategy,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'event handling' }
GeoViewCursorInformationBlocStrategy >> processEvent: aSmockEventWrapper context: aSmockInputContext [

	| event coordinates geoViewMng |
	event := aSmockEventWrapper event.
	event isMouse ifFalse:[ ^ self ].
	event isMouseMove ifFalse: [ ^ self ].
	
	geoViewMng := aSmockInputContext controller ifNil:[ ^ self ].
	coordinates := geoViewMng getAbsoluteCoordinatesFromGlobalPoint: event position.
	coordinates ifNotNil:[ geoViewMng mouseCursorCoordinatesChanged: coordinates ].
	
	aSmockEventWrapper isConsumed: true
]
