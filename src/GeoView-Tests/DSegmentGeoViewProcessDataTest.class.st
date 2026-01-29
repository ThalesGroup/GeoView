Class {
	#name : #DSegmentGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DSegmentGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDSegment new .
	
	"Complete shape"
	(SmockDSegment new coordinates: 0@0; coordinates2: 2@2; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDSegment new coordinates: 0@0; coordinates2: 2@2; fillColor: Color red; setDrawModeDevice).
	 }
]

{ #category : #running }
DSegmentGeoViewProcessDataTest >> processDataClass [ 

	^ DSegmentGeoViewProcessData 
]
