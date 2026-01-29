Class {
	#name : #DImageGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DImageGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	| form |
	form := (self iconNamed: #pharo).

	^ { 
	"Empty shape"
	SmockDImage new .
	
	"Complete shape"
	(SmockDImage new image: form; orientation: 45; scale: 2@2; coordinates: 0@0; fillColor: Color red).
	
	"Draw mode user (default is device)"
	(SmockDImage new image: form; orientation: 45; coordinates: 0@0; fillColor: Color red; setDrawModeUser)
	 }
]

{ #category : #running }
DImageGeoViewProcessDataTest >> processDataClass [ 

	^ DImageGeoViewProcessData 
]
