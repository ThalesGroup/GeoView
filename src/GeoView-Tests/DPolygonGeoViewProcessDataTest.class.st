Class {
	#name : #DPolygonGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DPolygonGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDPolygon new .
	
	"Complete shape"
	(SmockDPolygon new points: { 0 asPoint . 1 asPoint . 2 asPoint }; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDPolygon new points: { 0 asPoint . 1 asPoint . 2 asPoint }; fillColor: Color red) setDrawModeDevice.
	 }
]

{ #category : #running }
DPolygonGeoViewProcessDataTest >> processDataClass [ 

	^ DPolygonGeoViewProcessData 
]
