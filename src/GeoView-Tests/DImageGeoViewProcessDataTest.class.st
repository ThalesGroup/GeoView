Class {
	#name : #DImageGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DImageGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDImage new .
	
	"Complete shape"
	(SmockDImage new image: Form new; orientation: 45; scale: 2@2; coordinates: 0@0; fillColor: Color red)
	 }
]

{ #category : #running }
DImageGeoViewProcessDataTest >> processDataClass [ 

	^ DImageGeoViewProcessData 
]
