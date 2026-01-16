"
An UTMProjectionTest is a test class for testing the behavior of UTMProjection
"
Class {
	#name : #GeoViewUTMProjectionTest,
	#superclass : #TGeoViewMapProjectionTest,
	#category : #'GeoView-Tests-Projections'
}

{ #category : #running }
GeoViewUTMProjectionTest >> projectionClass [

	^ GeoViewUTMProjection 
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testAbsoluteCoordinates [

	projection := GeoViewUTMProjection absoluteCoordinates: AbsoluteCoordinates zero.
	self assert: projection zone equals: 31.
	self assert: projection isNorthernHemisphere
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testCentraleMeridian [

	self assert: projection centralMeridian equals: 3.
	
	projection zone: 1.
	self assert: projection centralMeridian equals: -177.
	
	projection zone: 30.
	self assert: projection centralMeridian equals: -3.
	
	projection zone: 60.
	self assert: projection centralMeridian equals: 177.
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testEpsgCode [

	"default code is 32631 for zone 31 and north"
	self assert: projection epsgCode equals: 32631.
	
	"Southern hemisphere zones"
	projection isNorthernHemisphere: false.
	self assert: projection epsgCode equals: 32731.
	
	projection isNorthernHemisphere: true.
	self assert: projection epsgCode equals: 32631.
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testEquatorCentralMeridian [

	| coord result |
	coord := AbsoluteCoordinates new
		         latitudeInDegrees: 0;
		         longitudeInDegrees: 3.

	result := projection projLatLonToCart: coord.
	self assert: (result xInMeters roundTo: 0.1) equals: 500000.
	self assert: (result yInMeters roundTo: 0.1) equals: 0
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testGeodesicCrossesValidDomainFromTo [

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
			
	self deny: (projection
			 geodesicCrossesValidDomainFrom: (AbsoluteCoordinates latitudeInDegrees: 5.08 longitudeInDegrees: -19.01)
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: 5.08 longitudeInDegrees: -19.00)).
			
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
GeoViewUTMProjectionTest >> testGeodesicCrossesZoneFromTo [

	self assert: (projection
			 geodesicCrossesZoneFrom: AbsoluteCoordinates zero
			 to:
			 (AbsoluteCoordinates latitudeInDegrees: 45 longitudeInDegrees: 100))
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testHighLatitude [

	| coord result |
	coord := AbsoluteCoordinates new
		         latitudeInDegrees: 83;
		         longitudeInDegrees: 0.

	result := projection projLatLonToCart: coord.

	self assert: result xInMeters isNumber.
	self assert: result yInMeters isNumber
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testIsAbsoluteCoordinatesOutsideProjectionLimit [

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
GeoViewUTMProjectionTest >> testIsNorthernHemisphere [

	self assert: projection isNorthernHemisphere
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testKey [

	self assert: projection key equals: #GeoViewUTMProjection
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testLongitudeMonotonicity [

	| coord1 coord2 r1 r2 |
	coord1 := AbsoluteCoordinates new
		          latitudeInDegrees: 45;
		          longitudeInDegrees: 0.

	coord2 := AbsoluteCoordinates new
		          latitudeInDegrees: 45;
		          longitudeInDegrees: 2.

	r1 := projection projLatLonToCart: coord1.
	r2 := projection projLatLonToCart: coord2.

	self assert: r2 xInMeters > r1 xInMeters
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testName [

	self assert: projection name equals: 'Universal Transverse Mercator'
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testProjCartToLatLon [
	"Test UTM to lat/lon conversion with known coordinates"
	
	| cartesian absolute |
	
	"Paris zone 31N: 451108E 5412852N"
	cartesian := CartesianCoordinates 
		xInMeters: 451108.226 
		yInMeters: 5412851.866.
	
	absolute := projection projCartToLatLon: cartesian.
	self assert: absolute notNil.
	self assert: (absolute latitudeInDegrees closeTo: 48.8667 precision: 0.0001).
	self assert: (absolute longitudeInDegrees closeTo: 2.33333 precision: 0.0001)
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testProjLatLonToCart [
	"Test specific known UTM coordinates"
	
	| coord cart |
	
	"Brest"
	projection zone: 30.
	coord := AbsoluteCoordinates frBrest.
	cart := projection projLatLonToCart: coord.
	self assert: (cart xInMeters between: 389000 and: 391000).
	self assert: (cart yInMeters between: 5360000 and: 5362000).
	
	"Paris"
	projection zone: 31.
	coord := AbsoluteCoordinates frParis.
	cart := projection projLatLonToCart: coord.
	self assert: (cart xInMeters between: 451000 and: 451200).
	self assert: (cart yInMeters between: 5412800 and: 5413000)
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testReverseProj [
	"Test that converting lat/lon -> UTM -> lat/lon gives back original coordinates"
	
	| coord cart coordBack latDiff lonDiff |
	
	coord := AbsoluteCoordinates frParis.
	
	cart := projection projLatLonToCart: coord.
	self assert: cart notNil.
	
	coordBack := projection projCartToLatLon: cart.
	self assert: coordBack notNil.
	
	latDiff := (coord latitudeInDegrees - coordBack latitudeInDegrees) abs.
	lonDiff := (coord longitudeInDegrees - coordBack longitudeInDegrees) abs.
	
	"Should be accurate to within 0.0001 degrees (~10 meters)"
	self assert: latDiff < 0.0001.
	self assert: lonDiff < 0.0001.
	
	"Test with Brest in zone 30"
	projection zone: 30.
	coord := AbsoluteCoordinates frBrest.
	cart := projection projLatLonToCart: coord.
	coordBack := projection projCartToLatLon: cart.
	
	latDiff := (coord latitudeInDegrees - coordBack latitudeInDegrees) abs.
	lonDiff := (coord longitudeInDegrees - coordBack longitudeInDegrees) abs.
	
	self assert: latDiff < 0.0001.
	self assert: lonDiff < 0.0001
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testSideOfAbsoluteCoordinates [

	self
		assert:
		(projection sideOfAbsoluteCoordinates: AbsoluteCoordinates zero)
		equals: GeoViewMapProjectionSide insideUTMZone.
	
	self
		assert:
		(projection sideOfAbsoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: -1))
		equals: GeoViewMapProjectionSide leftOfUTMZone.
	
	self
		assert:
		(projection sideOfAbsoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 20))
		equals: GeoViewMapProjectionSide rightOfUTMZone.
		
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

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testSouthernHemisphere [

	| coord result |
	projection isNorthernHemisphere: false.
	
	coord := AbsoluteCoordinates new
		         latitudeInDegrees: 0;
		         longitudeInDegrees: 3.
		
	result := projection projLatLonToCart: coord.
	self assert: (result xInMeters roundTo: 0.1) equals: 500000.
    self assert: (result yInMeters roundTo: 0.1) equals: 10000000.
]

{ #category : #tests }
GeoViewUTMProjectionTest >> testZone [

	self assert: projection zone equals: 31
]

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testZoneNumber [

	"Western Europe"
	self assert: (GeoViewUTMProjection zoneNumberFor: 2.3522) equals: 31.
	
	"Eastern USA"
	self assert: (GeoViewUTMProjection zoneNumberFor: -74.0060) equals: 18.
	
	"Japan"
	self assert: (GeoViewUTMProjection zoneNumberFor: 139.6917) equals: 54
]
