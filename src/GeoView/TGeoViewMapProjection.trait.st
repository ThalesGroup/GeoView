"
I am Map Projection, convert absolute coordinates to cartesian coordinates.
"
Trait {
	#name : #TGeoViewMapProjection,
	#category : #'GeoView-Projections'
}

{ #category : #accessing }
TGeoViewMapProjection >> epsgCode [
	"Return the EPSG code identifying the projection coordinate reference system"

	self explicitRequirement 
]

{ #category : #testing }
TGeoViewMapProjection >> geodesicExitsValidDomainFrom: aFromAbsoluteCoordinates to: aToAbsoluteCoordinates [
	"return a boolean if a segment between two points need to be cut, used in case of changement of the projection side"
	
	self explicitRequirement 
]

{ #category : #testing }
TGeoViewMapProjection >> isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates [
	"Sometimes coordinates can be correct from a geographic point of view but outside of the map projection"
	
	self explicitRequirement 
]

{ #category : #accessing }
TGeoViewMapProjection >> key [

	self explicitRequirement 
]

{ #category : #accessing }
TGeoViewMapProjection >> name [

	self explicitRequirement 
]

{ #category : #printing }
TGeoViewMapProjection >> printOn: aStream [

	aStream
		nextPutAll: (self name asString);
		space;
		nextPut: $(;
		nextPutAll: 'EPSG: ';
		nextPutAll: (self epsgCode asString);
		nextPut: $)
]

{ #category : #projection }
TGeoViewMapProjection >> projCartToLatLon: aCartesianCoordinates [

	self explicitRequirement 
]

{ #category : #projection }
TGeoViewMapProjection >> projLatLonToCart: anAbsoluteCoordinates [

	self explicitRequirement
]

{ #category : #testing }
TGeoViewMapProjection >> sideOfAbsoluteCoordinates: anAbsolutePosition [
	"return the side (a symbol, i.e.: #top, #bottom, #left, #right, etc.) of an absolution position (lat, lon). Sides symbols depend of the nature of the projection"

	self explicitRequirement
]
