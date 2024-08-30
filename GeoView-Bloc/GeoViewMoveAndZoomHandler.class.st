Class {
	#name : #GeoViewMoveAndZoomHandler,
	#superclass : #BlCustomEventHandler,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'api - accessing' }
GeoViewMoveAndZoomHandler >> eventsToHandle [

	^ { GeoViewCursorCoordinatesChangedEvent }
]
