"
I am a Graphic Model. 
GraphicModel is use to manage conversion between a user data and an user-interface data. ProcessData manage the conversion strategy by creation, updating and deletion.
"
Class {
	#name : #GeoViewModel,
	#superclass : #Object,
	#instVars : [
		'indexAccessor',
		'datas',
		'processDatas',
		'defaultProcessData',
		'isRecyclingActive',
		'recycledDatasStack',
		'symbologyProvider'
	],
	#category : #'GeoView-Model'
}

{ #category : #cud }
GeoViewModel >> created: aData [
	| processData data key |
	(self isSupportedData: aData) ifFalse:[
		GeoViewNotSupportedDataError signal: 'Data not supported or model not setup for this data.'. ^ nil.
	].
	
	key := self getSupportedDataIndex: aData.
	(self datas includesKey: key) ifTrue:[ 
		GeoViewDuplicateIdError signal: 'Cannot create the Data because index already used.'. ^ nil.	
	].
	
	processData := self getSupportedDataProcessData: aData.
	processData ifNil:[ ^ nil ].
	self isRecyclingActive ifTrue:[
		data := self destockRecycledDataFor: aData class.
	].
	data := processData processCreatedData: key incoming: aData with: data context: nil.
	data ifNil:[ ^ nil ].
	
	self datas at: key put: data.
	^data
]

{ #category : #datas }
GeoViewModel >> datas [
	datas ifNil:[datas := Dictionary new].
	^ datas 
]

{ #category : #datas }
GeoViewModel >> datas: anObject [
	datas := anObject
]

{ #category : #'process data' }
GeoViewModel >> defaultProcessData [
	^ defaultProcessData
]

{ #category : #'process data' }
GeoViewModel >> defaultProcessData: anObject [

	(defaultProcessData ~= anObject) ifFalse:[ ^ self ].
	defaultProcessData := anObject.
	defaultProcessData ifNotNil: [ defaultProcessData processor: self ]
]

{ #category : #'process data' }
GeoViewModel >> deleteProcessDataFor: aDataClass [
	self assert: [ aDataClass isNotNil ] description: [ '[GeoViewGraphicModel] Can not delete a process data without data class.'].
	^self processDatas removeKey: aDataClass ifAbsent:[nil]
]

{ #category : #cud }
GeoViewModel >> deleted: aData [
	| processData data oldData key |
	(self isSupportedData: aData) ifFalse:[
		GeoViewNotSupportedDataError signal: 'Data not supported or model not setup for this data.'. ^ nil.
	].
	
	key := self getSupportedDataIndex: aData.
	(self datas includesKey: key) not ifTrue:[ 
		GeoViewNoIdError signal: 'Cannot delete the Data because index not used.'. ^ nil.	
	].
	
	processData := self getSupportedDataProcessData: aData.
	processData ifNil:[ ^ nil ].
	oldData := self datas at: key ifAbsent:[ nil ].
	oldData ifNil:[ ^ nil ].
	data := processData processDeletedData: key incoming: aData with: oldData context: nil.
	
	self datas removeKey: key.
	(data notNil and:[self isRecyclingActive]) ifTrue:[self stockRecycledData: data for: aData class].
	^data
]

{ #category : #'recycling - private' }
GeoViewModel >> destockRecycledDataFor: anObjectClass [
	| recycledDatas data |
	anObjectClass ifNil:[^nil].
	recycledDatas := self recycledDatasStackFor: anObjectClass.
	recycledDatas isEmpty ifTrue:[data := nil] ifFalse:[data := recycledDatas first. recycledDatas removeFirst].
	^data
]

{ #category : #'recycling - private' }
GeoViewModel >> destockRecycledDatasFor: anObjectClass [
	| recycledDatas data |
	anObjectClass ifNil:[^nil].
	recycledDatas := self recycledDatasStackFor: anObjectClass.
	recycledDatas isEmpty ifTrue:[data := nil] ifFalse:[data := recycledDatas first. recycledDatas removeFirst].
	^data
]

{ #category : #'process data' }
GeoViewModel >> getAllProcessData [
	^self processDatas values
]

{ #category : #datas }
GeoViewModel >> getData: aKey [
	^ self datas at: aKey 
]

{ #category : #'process data' }
GeoViewModel >> getProcessDataFor: aDataClass [
	self assert: [ aDataClass isNotNil ] description: [ '[GeoViewGraphicModel] Can not get a process data without data class.'].
	^self processDatas at: aDataClass ifAbsent:[nil]
]

{ #category : #datas }
GeoViewModel >> getSupportedDataIndex: aData [
	"suppose data is supported"
	^aData perform: self indexAccessor
]

{ #category : #datas }
GeoViewModel >> getSupportedDataProcessData: aData [
	"suppose data is supported"
	| processData |
	processData := self processDatas at: aData class ifAbsent:[nil].
	processData ifNil:[processData := self defaultProcessData].
	^processData
]

{ #category : #accessing }
GeoViewModel >> indexAccessor [
	indexAccessor ifNil:[indexAccessor := #key].
	^ indexAccessor
]

{ #category : #accessing }
GeoViewModel >> indexAccessor: anObject [
	indexAccessor := anObject
]

{ #category : #recycling }
GeoViewModel >> isRecyclingActive [
	isRecyclingActive ifNil:[isRecyclingActive := true].
	^ isRecyclingActive
]

{ #category : #recycling }
GeoViewModel >> isRecyclingActive: anObject [
	isRecyclingActive := anObject
]

{ #category : #testing }
GeoViewModel >> isSupportedData: aData [
	| key |
	aData ifNil:[^false].
	(aData respondsTo: self indexAccessor) ifFalse:[^false].
	key := aData perform: self indexAccessor.
	key ifNil:[^false].
	
	^true
]

{ #category : #'process data' }
GeoViewModel >> processDatas [
	processDatas ifNil:[processDatas := Dictionary new].
	^ processDatas
]

{ #category : #'process data' }
GeoViewModel >> processDatas: anObject [
	processDatas := anObject
]

{ #category : #accessing }
GeoViewModel >> recycledDatasStack [
	recycledDatasStack ifNil:[recycledDatasStack := Dictionary new].
	^ recycledDatasStack
]

{ #category : #accessing }
GeoViewModel >> recycledDatasStack: anObject [
	recycledDatasStack := anObject
]

{ #category : #'recycling - private' }
GeoViewModel >> recycledDatasStackFor: anObjectClass [
	| recycledDatas |
	recycledDatas := self recycledDatasStack at: anObjectClass ifAbsentPut:[OrderedCollection new].
	^recycledDatas
]

{ #category : #'process data' }
GeoViewModel >> setProcessData: aProcessDataInstance for: aDataClass [
	self assert: [ aProcessDataInstance isNotNil ] description: [ '[GeoViewGraphicModel] Can not add a nil process data.' ].
	self assert: [ aDataClass isNotNil ] description: [ '[GeoViewGraphicModel] Can not add a process data without data class.' ].

	aProcessDataInstance processor: self.
	self processDatas at: aDataClass put: aProcessDataInstance
]

{ #category : #'recycling - private' }
GeoViewModel >> stockRecycledData: aData for: anObjectClass [
	| recycledDatas |
	(anObjectClass isNil or:[aData isNil]) ifTrue:[^nil].
	recycledDatas := self recycledDatasStackFor: anObjectClass.
	recycledDatas add: aData
]

{ #category : #'recycling - private' }
GeoViewModel >> stockRecycledDatas: aData for: anObjectClass [
	| recycledDatas |
	(anObjectClass isNil or:[aData isNil]) ifTrue:[^nil].
	recycledDatas := self recycledDatasStackFor: anObjectClass.
	recycledDatas add: aData
]

{ #category : #accessing }
GeoViewModel >> symbologyProvider [
	^ symbologyProvider
]

{ #category : #accessing }
GeoViewModel >> symbologyProvider: anObject [
	symbologyProvider := anObject
]

{ #category : #cud }
GeoViewModel >> updated: aData [
	| processData data oldData key |
	(self isSupportedData: aData) ifFalse:[
		GeoViewNotSupportedDataError signal: 'Data not supported or model not setup for this data.'. ^ nil.
	].
	
	key := self getSupportedDataIndex: aData.
	(self datas includesKey: key) not ifTrue:[ 
		GeoViewNoIdError signal: 'Cannot update the Data because index not used.'. ^ nil.	
	].
	
	processData := self getSupportedDataProcessData: aData.
	processData ifNil:[ ^ nil ].
	oldData := self datas at: key ifAbsent:[ nil ].
	oldData ifNil:[ ^ nil ].
	data := processData processUpdatedData: key incoming: aData with: oldData context: nil.
	data ifNil:[ ^ nil ].
	
	self datas at: key put: data.
	^data
]
