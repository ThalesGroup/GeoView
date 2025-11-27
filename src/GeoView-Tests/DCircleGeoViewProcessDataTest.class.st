Class {
	#name : #DCircleGeoViewProcessDataTest,
	#superclass : #DShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DCircleGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDCircle new .
	
	"Complete shape"
	(SmockDCircle new radius: 10; coordinates: 0@0; fillColor: Color red)
	 }
]

{ #category : #running }
DCircleGeoViewProcessDataTest >> processDataClass [ 

	^ DCircleGeoViewProcessData 
]
