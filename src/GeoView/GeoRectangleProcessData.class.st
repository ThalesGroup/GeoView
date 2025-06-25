Class {
	#name : #GeoRectangleProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #dShape }
GeoRectangleProcessData >> createDShapeInstance [

	^ SmockDRectangle new
]

{ #category : #processing }
GeoRectangleProcessData >> processCreatedData: aKey incoming: aGeoRectangle with: aDRectangle context: aContext [
	| dRectangle |
	
	dRectangle := aDRectangle.
	dRectangle := super processCreatedData: aKey incoming: aGeoRectangle with: dRectangle context: aContext.
	
	self processUpdatedData: aKey incoming: aGeoRectangle with: dRectangle context: aContext.
	
	^dRectangle
]

{ #category : #processing }
GeoRectangleProcessData >> processUpdatedData: aKey incoming: aGeoRectangle with: aDRectangle context: aContext [
	| dRectangle length1 length2 |
	
	dRectangle := aDRectangle.
	super processUpdatedData: aKey incoming: aGeoRectangle with: dRectangle context: aContext.
	
	length1 := GeoViewProjectionUtils 
		          projectedCartesianRadiusFromCenter:
		          aGeoRectangle absoluteCoordinates
		          radiusInMeters: aGeoRectangle lengthInMeters1
		          azimuthInDegrees: 90
		          projection: self processor projection.
	dRectangle length1: length1.

	length2 := GeoViewProjectionUtils 
		          projectedCartesianRadiusFromCenter:
		          aGeoRectangle absoluteCoordinates
		          radiusInMeters: aGeoRectangle lengthInMeters2
		          azimuthInDegrees: 180
		          projection: self processor projection.
	dRectangle length2: length2.
	
	^dRectangle
]
