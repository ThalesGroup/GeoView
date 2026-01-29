Class {
	#name : #DSymbolGeoViewProcessDataTest,
	#superclass : #DLeafShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DSymbolGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDSymbol new .
	
	"Complete shape"
	(SmockDSymbol new coordinates: 0@0; orientation: 45; symbolKey: #mySymbol).
	
	"Draw mode user (default is device)"
	(SmockDSymbol new coordinates: 0@0; orientation: 45; symbolKey: #mySymbol; setDrawModeUser).
	 }
]

{ #category : #running }
DSymbolGeoViewProcessDataTest >> processDataClass [ 

	^ DSymbolGeoViewProcessData 
]
