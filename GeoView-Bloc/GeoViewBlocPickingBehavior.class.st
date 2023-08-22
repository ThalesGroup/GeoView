"
Behavior for picking of geo objects on the view
"
Class {
	#name : #GeoViewBlocPickingBehavior,
	#superclass : #GeoViewEventBehavior,
	#instVars : [
		'isMapMoving',
		'previousPoint'
	],
	#category : #'GeoView-Bloc-Strategy'
}

{ #category : #'event handling' }
GeoViewBlocPickingBehavior >> receiveEvent: aBlEvent [

	| pickingResult |
	aBlEvent isMouse ifTrue: [

		"Do picking on click event"
		aBlEvent isClick ifTrue: [ 
			pickingResult := self geoViewManager pickAt: aBlEvent position.
			"Inspect result, during dev phase only"
			aBlEvent modifiers isShift ifTrue:[pickingResult inspect].
		].
	].
]
