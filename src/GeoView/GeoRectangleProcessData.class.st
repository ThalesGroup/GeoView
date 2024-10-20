Class {
	#name : #GeoRectangleProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
GeoRectangleProcessData >> processCreatedData: aKey incoming: aGeoRectangle with: aDRectangle context: aContext [
	| dRectangle |
	dRectangle := aDRectangle ifNil:[SmockDRectangle new].
	super processCreatedData: aKey incoming: aGeoRectangle with: dRectangle context: aContext.
	self processUpdatedData: aKey incoming: aGeoRectangle with: dRectangle context: aContext.
	^dRectangle
]

{ #category : #processing }
GeoRectangleProcessData >> processUpdatedData: aKey incoming: aGeoRectangle with: aDRectangle context: aContext [
	| dRectangle length1 length2 |
	dRectangle := aDRectangle.
	super processUpdatedData: aKey incoming: aGeoRectangle with: dRectangle context: aContext.
	
	length1 := GeodesicUtilities
		          projectedRadiusInMCenter:
		          aGeoRectangle absoluteCoordinates
		          radius: aGeoRectangle lengthInMeters1
		          azimuth: 90
		          projection: self processor projection.
	dRectangle length1: length1.

	length2 := GeodesicUtilities
		          projectedRadiusInMCenter:
		          aGeoRectangle absoluteCoordinates
		          radius: aGeoRectangle lengthInMeters2
		          azimuth: 180
		          projection: self processor projection.
	dRectangle length2: length2.
	
	^dRectangle
]
