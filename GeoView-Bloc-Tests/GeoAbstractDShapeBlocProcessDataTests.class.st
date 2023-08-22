Class {
	#name : #GeoAbstractDShapeBlocProcessDataTests,
	#superclass : #TestCase,
	#instVars : [
		'process'
	],
	#category : #'GeoView-Bloc-Tests-Cases - ProcessData'
}

{ #category : #running }
GeoAbstractDShapeBlocProcessDataTests >> createProcessor [
	| projection |
	projection := GeoView2DProjection new.
	projection altitudeInMeters: 1000.
	projection updateResolution: 800 @ 600.
	^ GeoViewProjectionModel new projection: projection
]

{ #category : #running }
GeoAbstractDShapeBlocProcessDataTests >> dShape [

	^ nil
]

{ #category : #running }
GeoAbstractDShapeBlocProcessDataTests >> processData [

	^ nil
]

{ #category : #running }
GeoAbstractDShapeBlocProcessDataTests >> setUp [
	process := self processData processor: (self createProcessor).
	
]

{ #category : #running }
GeoAbstractDShapeBlocProcessDataTests >> tearDown [

	process := nil.
]
