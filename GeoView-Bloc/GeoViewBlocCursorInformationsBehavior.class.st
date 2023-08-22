Class {
	#name : #GeoViewBlocCursorInformationsBehavior,
	#superclass : #GeoViewEventBehavior,
	#instVars : [
		'isMapMoving',
		'previousPoint'
	],
	#category : #'GeoView-Bloc-Strategy'
}

{ #category : #'event handling' }
GeoViewBlocCursorInformationsBehavior >> informCursorPosition: aBlMouseEvent [
	| pos |
	pos := self geoViewManager getAbsoluteCoordinatesFromGlobalPoint: aBlMouseEvent position.
	self geoViewManager cursorPositionChanged: 1 -> pos
]

{ #category : #'event handling' }
GeoViewBlocCursorInformationsBehavior >> receiveEvent: aBlEvent [
	"Manage mouse move cursor information"
	self flag:'PLA : faire enter et exit aussi'.
	(aBlEvent isMouse and:[aBlEvent isMouseMove]) ifTrue: [ 
		self informCursorPosition: aBlEvent.
	].
]
