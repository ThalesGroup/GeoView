"
A MercatorProjectionTest is a test class for testing the behavior of MercatorProjection
"
Class {
	#name : #GeoViewMercatorProjectionTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - MapProjection'
}

{ #category : #'tests-accessing' }
GeoViewMercatorProjectionTest >> testReverseProj [
            | projection absoluteCoordinates cartesianCoordinates absoluteCoordinatesRes random precision |
            projection := MercatorProjection new.
            random := Random seed: 42.
            precision := 1e-12. "Precision at 1e-12 degree"
            
            10 timesRepeat: [ 
                        absoluteCoordinates := AbsoluteCoordinates 
                                   latitudeInDegrees: (random next * 180) - 90
                                   longitudeInDegrees:  (random next * 360) - 180.
                        cartesianCoordinates := projection projLatLonToCart: absoluteCoordinates.
                        absoluteCoordinatesRes := projection projCartToLatLon: cartesianCoordinates.
                        self assert: (absoluteCoordinatesRes latitudeInDegrees 
                                   closeTo: absoluteCoordinates latitudeInDegrees 
                                   precision: precision).
                        self assert: (absoluteCoordinatesRes longitudeInDegrees 
                                   closeTo: absoluteCoordinates longitudeInDegrees 
                                   precision: precision). ].

]
