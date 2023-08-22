Class {
	#name : #DLeafShapeBlocProcessData,
	#superclass : #DShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DLeafShapeBlocProcessData >> processCreatedData: aKey incoming: aDLeafShape with: aBlElement context: aContext [
	
	super processCreatedData: aKey incoming: aDLeafShape with: aBlElement context: aContext.
	
	aDLeafShape fillColor 
		ifNil: [ aBlElement background: BlBackground transparent ]
		ifNotNil: [aBlElement background: (aDLeafShape fillColor)].
		
	(aDLeafShape strokeColor isNil or: [aDLeafShape strokeWidth isNil]) 
		ifTrue: [ aBlElement border: BlBorder empty ]
		ifFalse: [ aBlElement border: 
			(BlBorder paint: aDLeafShape strokeColor width: aDLeafShape strokeWidth) ]
]

{ #category : #processing }
DLeafShapeBlocProcessData >> processUpdatedData: aKey incoming: aDLeafShape with: aBlElement context: aContext [
	
	super processUpdatedData: aKey incoming: aDLeafShape with: aBlElement context: aContext.
	
	aDLeafShape fillColor ifNotNil: [aBlElement background: aDLeafShape fillColor].
	
	(aDLeafShape strokeColor notNil and: [ aDLeafShape strokeWidth notNil ])
		ifTrue: [aBlElement border: (BlBorder paint: aDLeafShape strokeColor width: aDLeafShape strokeWidth)]
]
