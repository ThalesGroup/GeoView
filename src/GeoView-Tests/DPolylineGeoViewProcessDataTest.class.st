Class {
	#name : #DPolylineGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DPolylineGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDPolyline new .
	
	"Complete shape"
	(SmockDPolyline new points: { 0 asPoint . 1 asPoint . 2 asPoint }; fillColor: Color red).
	
	"Draw mode device (default is user)"
	(SmockDPolyline new points: { 0 asPoint . 1 asPoint . 2 asPoint }; fillColor: Color red) setDrawModeDevice.
	 }
]

{ #category : #running }
DPolylineGeoViewProcessDataTest >> processDataClass [ 

	^ DPolylineGeoViewProcessData 
]
