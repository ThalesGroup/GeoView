Class {
	#name : #GeoViewEventLogger,
	#superclass : #BlCustomEventHandler,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'api - accessing' }
GeoViewEventLogger >> eventsToHandle [

	^ {
		  GeoViewCursorCoordinatesChangedEvent.
		  GeoViewCenterChangedEvent.
		  GeoViewScaleChangedEvent }
]

{ #category : #events }
GeoViewEventLogger >> geoViewCenterChangedEvent: anEvent [

	anEvent traceCr.
]

{ #category : #events }
GeoViewEventLogger >> geoViewCursorCoordinatesChangedEvent: anEvent [

	anEvent traceCr.
]

{ #category : #events }
GeoViewEventLogger >> geoViewScaleChangedEvent: anEvent [

	anEvent traceCr.
]
