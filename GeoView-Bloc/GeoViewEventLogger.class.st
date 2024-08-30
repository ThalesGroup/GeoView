Class {
	#name : #GeoViewEventLogger,
	#superclass : #BlCustomEventHandler,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'api - accessing' }
GeoViewEventLogger >> eventsToHandle [

	^ { GeoViewCursorCoordinatesChangedEvent }
]

{ #category : #'as yet unclassified' }
GeoViewEventLogger >> geoViewCursorCoordinatesChangedEvent: aGeoViewCursorCoordinatesChangedEvent [

	"Print lat/lon coordinates on the transcript"
	aGeoViewCursorCoordinatesChangedEvent absoluteCoordinates printString traceCr.
]
