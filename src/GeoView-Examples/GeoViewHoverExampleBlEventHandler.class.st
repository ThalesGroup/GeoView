Class {
	#name : #GeoViewHoverExampleBlEventHandler,
	#superclass : #BlEventHandler,
	#instVars : [
		'geoView',
		'hoveredIndex'
	],
	#category : #'GeoView-Examples-Utils'
}

{ #category : #initialization }
GeoViewHoverExampleBlEventHandler >> doAction: anEvent [

	| globalPoint pickingResult firstElement |
	self geoView ifNil:[ ^ self ].
	
	globalPoint := anEvent position.
	pickingResult := self geoView pickAt: globalPoint radius: 10. 
	firstElement := pickingResult firstElement.

	firstElement ifNil:[ 
		self hoveredIndex ifNotNil:[
			"reset hovered index"
			self geoView clearStateObjectIndexes: #hover.
			self hoveredIndex: nil 
		].
	] ifNotNil:[ | newIndex |
		newIndex := firstElement objectIndex.
		self geoView updateState: #hover withObjectIndexes: (Set with: newIndex).
		self hoveredIndex: newIndex 
	].
	
]

{ #category : #accessing }
GeoViewHoverExampleBlEventHandler >> geoView [

	^ geoView
]

{ #category : #accessing }
GeoViewHoverExampleBlEventHandler >> geoView: anObject [

	geoView := anObject
]

{ #category : #accessing }
GeoViewHoverExampleBlEventHandler >> hoveredIndex [

	^ hoveredIndex
]

{ #category : #accessing }
GeoViewHoverExampleBlEventHandler >> hoveredIndex: anObject [

	hoveredIndex := anObject
]

{ #category : #initialization }
GeoViewHoverExampleBlEventHandler >> initialize [ 

	super initialize.
	
	self eventClass: BlMouseMoveEvent.
	self action:[ :event | self doAction: event ].
]
