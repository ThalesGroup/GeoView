Class {
	#name : #DEllipseGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DEllipseGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDEllipse new .
	
	"Complete shape"
	(SmockDEllipse new radius1: 10; radius2: 20; orientation: 45; coordinates: 0@0; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDEllipse new radius1: 10; radius2: 20; orientation: 45; coordinates: 0@0; fillColor: Color red; setDrawModeDevice).
	 }
]

{ #category : #running }
DEllipseGeoViewProcessDataTest >> processDataClass [ 

	^ DEllipseGeoViewProcessData 
]
