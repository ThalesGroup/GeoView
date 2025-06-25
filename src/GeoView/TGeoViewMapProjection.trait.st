"
I am Map Projection, convert absolute coordinates to cartesian coordinates.
"
Trait {
	#name : #TGeoViewMapProjection,
	#category : #'GeoView-Projections'
}

{ #category : #testing }
TGeoViewMapProjection >> geodesicExitsValidDomainFrom: aFromAbsoluteCoordinates to: aToAbsoluteCoordinates [
	"return a boolean if a segment between two points need to be cut, used in case of changement of the projection side"
	
	self shouldBeImplemented 
]

{ #category : #testing }
TGeoViewMapProjection >> isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates [
	"Sometimes coordinates can be correct from a geographic point of view but outside of the map projection"
	
	self shouldBeImplemented 
]

{ #category : #accessing }
TGeoViewMapProjection >> key [

	self shouldBeImplemented 
]

{ #category : #projection }
TGeoViewMapProjection >> projCartToLatLon: aCartesianCoordinates [

	self shouldBeImplemented 
]

{ #category : #projection }
TGeoViewMapProjection >> projLatLonToCart: anAbsoluteCoordinates [

	self shouldBeImplemented 
]

{ #category : #testing }
TGeoViewMapProjection >> sideOfAbsoluteCoordinates: anAbsolutePosition [
	"return the side (a symbol, i.e.: #top, #bottom, #left, #right, etc.) of an absolution position (lat, lon). Sides symbols depend of the nature of the projection"
	
	self shouldBeImplemented 
]
