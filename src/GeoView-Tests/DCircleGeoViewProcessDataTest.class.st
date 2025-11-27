Class {
	#name : #DCircleGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DCircleGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDCircle new .
	
	"Complete shape"
	(SmockDCircle new radius: 10; coordinates: 0@0; fillColor: Color red).
	
	"With effect"
	(SmockDCircle new radius: 10; coordinates: 0@0; fillColor: Color red; effect: (SmockDuplicateEffect new)).
	 }
]

{ #category : #running }
DCircleGeoViewProcessDataTest >> processDataClass [ 

	^ DCircleGeoViewProcessData 
]
