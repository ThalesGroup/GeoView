Class {
	#name : #DSymbolGeoViewProcessDataTest,
	#superclass : #DShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #running }
DSymbolGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ { 
	"Empty shape"
	SmockDSymbol new .
	
	"Complete shape"
	(SmockDSymbol new coordinates: 0@0; orientation: 45; symbolKey: #mySymbol)
	 }
]

{ #category : #running }
DSymbolGeoViewProcessDataTest >> processDataClass [ 

	^ DSymbolGeoViewProcessData 
]
