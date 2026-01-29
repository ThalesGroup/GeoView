Class {
	#name : #DTextGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DTextGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDText new .
	
	"Complete shape"
	(SmockDText new coordinates: 0@0; text: 'Test'; smockFont: (SmockFont defaultFont fontSize: 20)).
	
	"Draw mode user (default is device)"
	(SmockDText new coordinates: 0@0; text: 'Test'; smockFont: (SmockFont defaultFont fontSize: 20); setDrawModeUser).
	 }
]

{ #category : #running }
DTextGeoViewProcessDataTest >> processDataClass [ 

	^ DTextGeoViewProcessData 
]
