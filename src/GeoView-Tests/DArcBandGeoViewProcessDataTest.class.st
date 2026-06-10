Class {
	#name : #DArcBandGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DArcBandGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDArcBand new .
	
	"Complete shape"
	(SmockDArcBand new aperture: 10; radiusMin: 20; radiusMax: 25; orientation: 45; coordinates: 0@0; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDArcBand new aperture: 10; radiusMin: 20; radiusMax: 25; orientation: 45; coordinates: 0@0; fillColor: Color red; setDrawModeDevice).
	 }
]

{ #category : #running }
DArcBandGeoViewProcessDataTest >> processDataClass [ 

	^ DArcBandGeoViewProcessData 
]
