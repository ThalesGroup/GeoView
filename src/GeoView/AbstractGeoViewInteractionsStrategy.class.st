Class {
	#name : #AbstractGeoViewInteractionsStrategy,
	#superclass : #BlEventListener,
	#instVars : [
		'geoView',
		'allowMapMoving',
		'allowMapScaling',
		'isMultipleSelection',
		'pickingRadius',
		'selectionFilterBlock'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
AbstractGeoViewInteractionsStrategy class >> defaultPickingRadius [

	^ 5
]

{ #category : #testing }
AbstractGeoViewInteractionsStrategy class >> isAbstract [ 

	^ self == AbstractGeoViewInteractionsStrategy 
]

{ #category : #map }
AbstractGeoViewInteractionsStrategy >> allowMapMoving [

	^ allowMapMoving ifNil:[ allowMapMoving := true ]
]

{ #category : #map }
AbstractGeoViewInteractionsStrategy >> allowMapMoving: anObject [

	allowMapMoving := anObject
]

{ #category : #map }
AbstractGeoViewInteractionsStrategy >> allowMapScaling [

	^ allowMapScaling ifNil:[ allowMapScaling := true ]
]

{ #category : #map }
AbstractGeoViewInteractionsStrategy >> allowMapScaling: anObject [

	allowMapScaling := anObject
]

{ #category : #'mouse handlers' }
AbstractGeoViewInteractionsStrategy >> clickEvent: anEvent [

	anEvent
		ifPrimary: [ self primaryClickEvent: anEvent ]
		secondary: [ self secondaryClickEvent: anEvent ]
		middle: [ self middleClickEvent: anEvent ]
		other: [ self otherClickEvent: anEvent ]
]

{ #category : #accessing }
AbstractGeoViewInteractionsStrategy >> geoView [

	^ geoView
]

{ #category : #accessing }
AbstractGeoViewInteractionsStrategy >> geoView: anObject [

	geoView := anObject
]

{ #category : #selection }
AbstractGeoViewInteractionsStrategy >> isMultipleSelection [

	^ isMultipleSelection ifNil:[ isMultipleSelection := true ]
]

{ #category : #selection }
AbstractGeoViewInteractionsStrategy >> isMultipleSelection: aBoolean [

	isMultipleSelection := aBoolean
]

{ #category : #'mouse handlers' }
AbstractGeoViewInteractionsStrategy >> middleClickEvent: anEvent [

	
]

{ #category : #'mouse handlers' }
AbstractGeoViewInteractionsStrategy >> otherClickEvent: anEvent [

	
]

{ #category : #picking }
AbstractGeoViewInteractionsStrategy >> pickingRadius [
	"Consider this radius as a device coordinates (i.e. pixels)"

	^ pickingRadius ifNil: [ pickingRadius := self class defaultPickingRadius ]
]

{ #category : #picking }
AbstractGeoViewInteractionsStrategy >> pickingRadius: aNumber [

	pickingRadius := aNumber
]

{ #category : #'mouse handlers' }
AbstractGeoViewInteractionsStrategy >> primaryClickEvent: anEvent [

	
]

{ #category : #'mouse handlers' }
AbstractGeoViewInteractionsStrategy >> secondaryClickEvent: anEvent [

	
]

{ #category : #selection }
AbstractGeoViewInteractionsStrategy >> selectionFilterBlock [

	^ selectionFilterBlock
]

{ #category : #selection }
AbstractGeoViewInteractionsStrategy >> selectionFilterBlock: aSelectFilterBlock [

	selectionFilterBlock := aSelectFilterBlock 
]
