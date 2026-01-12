"
A MercatorProjectionTest is a test class for testing the behavior of MercatorProjection
"
Class {
	#name : #GeoViewMercatorProjectionTest,
	#superclass : #TGeoViewMapProjectionTest,
	#category : #'GeoView-Tests-Projections'
}

{ #category : #running }
GeoViewMercatorProjectionTest >> projectionClass [
	
	^ GeoViewMercatorProjection 
]

{ #category : #tests }
GeoViewMercatorProjectionTest >> testEpsgCode [

	self assert: projection epsgCode equals: 3395
]

{ #category : #tests }
GeoViewMercatorProjectionTest >> testKey [

	self assert: projection key equals: #GeoViewMercatorProjection
]

{ #category : #tests }
GeoViewMercatorProjectionTest >> testName [

	self assert: projection name equals: 'Mercator'
]

{ #category : #'tests-accessing' }
GeoViewMercatorProjectionTest >> testReverseProj [

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
