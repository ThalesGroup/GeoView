"
A TGeoProjectorProcessDataTest is a test class for testing the behavior of TGeoProjectorProcessData
"
Class {
	#name : #TGeoProjectorProcessDataTest,
	#superclass : #TestCase,
	#instVars : [
		'processData'
	],
	#category : #'GeoView-Tests-Projections'
}

{ #category : #running }
TGeoProjectorProcessDataTest >> setUp [

	super setUp.

	processData := GeoProjectorProcessDataUserForTest new.
	self setUpProcessData
]

{ #category : #running }
TGeoProjectorProcessDataTest >> setUpProcessData [

	processData processor: GeoViewModel new.
	processData processor projection: GeoViewMercatorProjection new.
]

{ #category : #tests }
TGeoProjectorProcessDataTest >> testGeodesicFormulas [

	self assert: processData geodesicFormulas class equals: GeodesicVincentyFormulas.
	
	processData geodesicFormulas: nil.
	self assert: processData geodesicFormulas class equals: GeodesicVincentyFormulas.
]

{ #category : #tests }
TGeoProjectorProcessDataTest >> testProjectBoundingBox [

	| boundingBox result |
	boundingBox := GeoBoundingBox new.

	"not valid bounding box"
	result := processData projectBoundingBox: boundingBox.
	self assert: result isEmpty.

	boundingBox topLeftAbsoluteCoordinates: AbsoluteCoordinates frBrest.
	result := processData projectBoundingBox: boundingBox.
	self assert: result isEmpty.

	"valid bounding box"
	boundingBox bottomRightAbsoluteCoordinates: AbsoluteCoordinates frLyon.

	result := processData projectBoundingBox: boundingBox.
	self assert: result size equals: 4.
]

{ #category : #tests }
TGeoProjectorProcessDataTest >> testProjectCircleRadiusInMeters [

	"not valid datas"
	| result |
	result := processData projectCircle: AbsoluteCoordinates new radiusInMeters: 1000.
	self assert: result isEmpty.
	
	"valid datas"
	result := processData projectCircle: AbsoluteCoordinates zero radiusInMeters: 0.
	self assert: result notEmpty.
	
	result := processData projectCircle: AbsoluteCoordinates zero radiusInMeters: 1000.
	self assert: result notEmpty.
	
	result := processData projectCircle: AbsoluteCoordinates frBrest radiusInMeters: 100000.
	self assert: result notEmpty.
]

{ #category : #tests }
TGeoProjectorProcessDataTest >> testProjectGeodesicFromTo [

	| result |
	"not valid"
	result := processData projectGeodesicFrom: AbsoluteCoordinates new to: AbsoluteCoordinates frNevers.
	self assert: result isEmpty.
	
	"valid"
	result := processData projectGeodesicFrom: AbsoluteCoordinates frBrest to: AbsoluteCoordinates frNevers.
	self assert: result size equals: 1.
	
	"valid with several polylines in mercator"
	result := processData projectGeodesicFrom: AbsoluteCoordinates usaNewYork to: AbsoluteCoordinates ausSydney.
	self assert: result size equals: 2.
	
]

{ #category : #tests }
TGeoProjectorProcessDataTest >> testProjectionQuality [

	self assert: processData projectionQuality equals: #high.
	
	processData projectionQuality: #medium.
	self assert: processData projectionQuality equals: #medium.
	
	processData projectionQuality: nil.
	self assert: processData projectionQuality equals: #high.
]

{ #category : #tests }
TGeoProjectorProcessDataTest >> testUsingVincentyFormulas [

	processData usingVincentyFormulas.
	self assert: processData geodesicFormulas class equals: GeodesicVincentyFormulas.
]
