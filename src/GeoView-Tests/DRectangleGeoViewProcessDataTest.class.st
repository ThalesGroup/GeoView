Class {
	#name : #DRectangleGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DRectangleGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDRectangle new .
	
	"Complete shape"
	(SmockDRectangle new length1: 10; length2: 20; orientation: 45; coordinates: 0@0; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDRectangle new length1: 10; length2: 20; orientation: 45; coordinates: 0@0; fillColor: Color red; setDrawModeDevice).
	 }
]

{ #category : #running }
DRectangleGeoViewProcessDataTest >> processDataClass [ 

	^ DRectangleGeoViewProcessData 
]
