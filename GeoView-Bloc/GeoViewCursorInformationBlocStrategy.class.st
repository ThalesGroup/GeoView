Class {
	#name : #GeoViewCursorInformationBlocStrategy,
	#superclass : #GeoViewBlocInputStrategy,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'as yet unclassified' }
GeoViewCursorInformationBlocStrategy >> processEvent: aSmockEventWrapper context: aSmockInputContext [

	| event coordinates geoViewMng |
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
