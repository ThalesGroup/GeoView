Class {
	#name : #DMultiPolylinesGeoViewProcessDataTest,
	#superclass : #DShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DMultiPolylinesGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDMultiPolylines new .
	
	"With empty polyline"
	(SmockDMultiPolylines new addPolylines: { SmockDPolyline new . SmockDPolyline new . SmockDPolyline new }; fillColor: Color red) .
	
	"With polylines"
	(SmockDMultiPolylines new addPolylines: { SmockDPolyline new points: { 0 asPoint . 1 asPoint . 2 asPoint } . SmockDPolyline new points: { 3 asPoint . 4 asPoint . 5 asPoint } . SmockDPolyline new points: { 6 asPoint . 7 asPoint . 8 asPoint } }; fillColor: Color red)
	 }
]

{ #category : #running }
DMultiPolylinesGeoViewProcessDataTest >> processDataClass [ 

	^ DMultiPolylinesGeoViewProcessData 
]
