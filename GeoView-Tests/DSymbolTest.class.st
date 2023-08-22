Class {
	#name : #DSymbolTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
DSymbolTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := DSymbol new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false.
]

{ #category : #tests }
DSymbolTest >> testInitialize [ 
	
	| dShape |
	dShape := DSymbol new.
	
	self assert: dShape symbolKey equals: nil.
	self assert: dShape orientation equals: nil.
]

{ #category : #tests }
DSymbolTest >> testOrientation [
	
	| dShape |
	dShape := DSymbol new.

	dShape orientation: 180.
	self assert: dShape orientation equals: 180.
	
	dShape orientation: nil.
	self assert: dShape orientation equals: nil.
]

{ #category : #tests }
DSymbolTest >> testSymbolKey [ 
	
	| dShape |
	dShape := DSymbol new.

	dShape symbolKey: #mySymbol.
	self assert: dShape symbolKey equals: #mySymbol.
	
	dShape symbolKey: nil.
	self assert: dShape symbolKey equals: nil.
]
