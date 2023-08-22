Class {
	#name : #DRectangleBlocProcessDataTests,
	#superclass : #GeoAbstractDShapeBlocProcessDataTests,
	#category : #'GeoView-Bloc-Tests-Cases - ProcessData'
}

{ #category : #running }
DRectangleBlocProcessDataTests >> dShape [

	^ DRectangle new
		key: 1;
		length1: 20;
		length2: 10;
		fillColor: Color red;
		yourself.
]

{ #category : #running }
DRectangleBlocProcessDataTests >> processData [

	^ DRectangleBlocProcessData 
]

{ #category : #tests }
DRectangleBlocProcessDataTests >> testProcessCUDDataIncomingWithContext [
	| blElement dRectangle |
	dRectangle := self dShape. 
	blElement := process processCreatedData: dRectangle key incoming: dRectangle with: nil context: nil.
	self assert: blElement background paint color equals: Color red.
	self assert: blElement geometry class equals: BlRectangleGeometry .
	
	dRectangle fillColor: Color blue.
	blElement := process processUpdatedData: dRectangle key incoming: dRectangle with: blElement context: nil.
	self assert: blElement background paint color equals: Color blue.
	self assert: blElement geometry class equals: BlRectangleGeometry.
		
	blElement := process processDeletedData: dRectangle key incoming: dRectangle with: blElement context: nil.
	self assert: blElement notNil.
]
