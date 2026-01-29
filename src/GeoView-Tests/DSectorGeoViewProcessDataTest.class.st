Class {
	#name : #DSectorGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DSectorGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDSector new .
	
	"Complete shape"
	(SmockDSector new aperture: 10; radius: 20; orientation: 45; coordinates: 0@0; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDSector new aperture: 10; radius: 20; orientation: 45; coordinates: 0@0; fillColor: Color red; setDrawModeDevice).
	 }
]

{ #category : #running }
DSectorGeoViewProcessDataTest >> processDataClass [ 

	^ DSectorGeoViewProcessData 
]
