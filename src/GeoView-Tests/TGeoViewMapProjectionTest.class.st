"
A TGeoViewMapProjectionTest is a test class for testing the behavior of TGeoViewMapProjection
"
Class {
	#name : #TGeoViewMapProjectionTest,
	#superclass : #TestCase,
	#instVars : [
		'projection'
	],
	#category : #'GeoView-Tests-Projections'
}

{ #category : #testing }
TGeoViewMapProjectionTest class >> isAbstract [ 

	^ self == TGeoViewMapProjectionTest 
]

{ #category : #running }
TGeoViewMapProjectionTest >> projectionClass [

	self subclassResponsibility 
]

{ #category : #running }
TGeoViewMapProjectionTest >> setUp [ 

	super setUp.
	
	projection := self projectionClass new.
	self setUpProjection.
]

{ #category : #running }
TGeoViewMapProjectionTest >> setUpProjection [

	"do nothing"
]

{ #category : #tests }
TGeoViewMapProjectionTest >> testEpsgCode [

	self subclassResponsibility 
]

{ #category : #tests }
TGeoViewMapProjectionTest >> testKey [

	self subclassResponsibility 
]
