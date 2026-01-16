"
A GeoViewWebMercatorProjectionTest is a test class for testing the behavior of GeoViewWebMercatorProjection
"
Class {
	#name : #GeoViewWebMercatorProjectionTest,
	#superclass : #TGeoViewMapProjectionTest,
	#category : #'GeoView-Tests-Projections'
}

{ #category : #running }
GeoViewWebMercatorProjectionTest >> projectionClass [

	^ GeoViewWebMercatorProjection 
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testEpsgCode [

	self assert: projection epsgCode equals: 3857
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testGeodesicCrossesValidDomainFromTo [

	self deny: (projection
			 geodesicCrossesValidDomainFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: 45 longitudeInDegrees: 100)).

	self deny: (projection
			 geodesicCrossesValidDomainFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0)).
	
	self deny: (projection
			 geodesicCrossesValidDomainFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: (projection latitudeMax) longitudeInDegrees: 180)).
			
	self deny: (projection
			 geodesicCrossesValidDomainFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: (projection latitudeMin) longitudeInDegrees: 180)).
			
	"projection limits"
	self assert: (projection
			 geodesicCrossesValidDomainFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: 90 longitudeInDegrees: 100)).
			
	self assert: (projection
			 geodesicCrossesValidDomainFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: -90 longitudeInDegrees: 100)).
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testIsAbsoluteCoordinatesOutsideProjectionLimit [

	self deny: (projection isAbsoluteCoordinatesOutsideProjectionLimit:
			 AbsoluteCoordinates zero).

	self deny: (projection isAbsoluteCoordinatesOutsideProjectionLimit:
			 AbsoluteCoordinates frBrest).

	"out"
	self assert:
		(projection isAbsoluteCoordinatesOutsideProjectionLimit:
			 AbsoluteCoordinates new).

	self assert:
		(projection isAbsoluteCoordinatesOutsideProjectionLimit:
			 (AbsoluteCoordinates latitudeInDegrees: -90 longitudeInDegrees: 0)).
			
	self assert:
		(projection isAbsoluteCoordinatesOutsideProjectionLimit:
			 (AbsoluteCoordinates latitudeInDegrees: 90 longitudeInDegrees: 0))
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testKey [

	self assert: projection key equals: #GeoViewWebMercatorProjection
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testName [

	self assert: projection name equals: 'Web Mercator'
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testProjCartToLatLon [

	"Brest"
	| cartesian absolute reference |
	reference := AbsoluteCoordinates frBrest.
	cartesian := CartesianCoordinates xInMeters: -499083 yInMeters: 6171933.
	absolute := projection projCartToLatLon: cartesian.
	self assert: (absolute latitudeInDegrees closeTo: (reference latitudeInDegrees) precision: 0.0001).
	self assert: (absolute longitudeInDegrees closeTo: (reference longitudeInDegrees) precision: 0.0001).
	
	"Paris"
	reference := AbsoluteCoordinates frParis.
	cartesian := CartesianCoordinates xInMeters: 259745 yInMeters: 6252273.
	absolute := projection projCartToLatLon: cartesian.
	self assert: (absolute latitudeInDegrees closeTo: (reference latitudeInDegrees) precision: 0.0001).
	self assert: (absolute longitudeInDegrees closeTo: (reference longitudeInDegrees) precision: 0.0001).
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testProjLatLonToCart [

	"Brest"
	| coord cart |
	coord := AbsoluteCoordinates frBrest.
	cart := projection projLatLonToCart: coord.
	self assert: (cart xInMeters closeTo: -499083 precision: 1).
	self assert: (cart yInMeters closeTo: 6171933 precision: 1).
	self assert: (cart zInMeters closeTo: 52 precision: 0.01).
	
	"Paris"
	coord := AbsoluteCoordinates frParis.
	cart := projection projLatLonToCart: coord.
	self assert: (cart xInMeters closeTo: 259745 precision: 1).
	self assert: (cart yInMeters closeTo: 6252273 precision: 1).
	self assert: (cart zInMeters closeTo: 79 precision: 0.01)
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testReverseProj [

	| absoluteCoordinates cartesianCoordinates absoluteCoordinatesRes random precision |
	random := Random seed: 42.
	precision := 1e-12. "Precision at 1e-12 degree"

	10 timesRepeat: [
			absoluteCoordinates := AbsoluteCoordinates
				                       latitudeInDegrees: random next * 180 - 90
				                       longitudeInDegrees: random next * 360 - 180.
			cartesianCoordinates := projection projLatLonToCart:
				                        absoluteCoordinates.
			absoluteCoordinatesRes := projection projCartToLatLon:
				                          cartesianCoordinates.
			self assert: (absoluteCoordinatesRes latitudeInDegrees
					 closeTo: absoluteCoordinates latitudeInDegrees
					 precision: precision).
			self assert: (absoluteCoordinatesRes longitudeInDegrees
					 closeTo: absoluteCoordinates longitudeInDegrees
					 precision: precision) ]
]

{ #category : #tests }
GeoViewWebMercatorProjectionTest >> testSideOfAbsoluteCoordinates [

	self
		assert:
		(projection sideOfAbsoluteCoordinates: AbsoluteCoordinates zero)
		equals: GeoViewMapProjectionSide leftOfZeroMeridian.
	
	self
		assert:
		(projection sideOfAbsoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: -1))
		equals: GeoViewMapProjectionSide leftOfZeroMeridian.
	
	self
		assert:
		(projection sideOfAbsoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 1))
		equals: GeoViewMapProjectionSide rightOfZeroMeridian.
		
	"limits"
	self
		assert:
		(projection sideOfAbsoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 90 longitudeInDegrees: 0))
		equals: GeoViewMapProjectionSide outsideLatitudeLimitTop.
		
	self
		assert:
		(projection sideOfAbsoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -90 longitudeInDegrees: 0))
		equals: GeoViewMapProjectionSide outsideLatitudeLimitBottom.
		
	"out"
	self
		assert:
		(projection sideOfAbsoluteCoordinates: AbsoluteCoordinates new)
		equals: GeoViewMapProjectionSide outOfProjection
		.
]
