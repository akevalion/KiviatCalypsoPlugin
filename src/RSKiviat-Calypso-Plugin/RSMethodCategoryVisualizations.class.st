"
A plugin to Calypso to visualize number of methods in method categories using RSKiviat
"
Class {
	#name : #RSMethodCategoryVisualizations,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'targetClass'
	],
	#category : #'RSKiviat-Calypso-Plugin'
}

{ #category : #activation }
RSMethodCategoryVisualizations class >> classTapActivation [
	<classAnnotation>
	^ ClyTabActivationStrategyAnnotation for: ClyClass asCalypsoItemContext
]

{ #category : #testing }
RSMethodCategoryVisualizations class >> shouldBeActivatedInContext: aBrowserContext [
 ^ aBrowserContext isClassSelected
]

{ #category : #accessing }
RSMethodCategoryVisualizations class >> tabOrder [
	^ 199
]

{ #category : #building }
RSMethodCategoryVisualizations >> build [

	| canvas morph |
	canvas := self buildKiviatCanvas.
	morph := canvas createMorph.
	morph onAnnouncement: MorphDeleted 
		do: [ self containerTab owner ifNotNil: [ self containerTab delete]].
	canvas when: RSMouseEnter do: [ morph takeKeyboardFocus].
	self addMorph: morph fullFrame: LayoutFrame identity
]

{ #category : #building }
RSMethodCategoryVisualizations >> buildKiviatCanvas [

	| kiviat protocols |
	kiviat := RSKiviat new.

	protocols := Dictionary new.
	self targetClass ifNotNil: [ 
		self targetClass methods do: [ :each | 
			| count |
			count := protocols at: each protocol ifAbsentPut: 1.
			protocols at: each protocol put: count + 1 ].


		kiviat addRow: protocols values.
		kiviat axisNames: protocols keys.
		kiviat usePolygonFillColor.
		kiviat useDots.
		kiviat build ].
	^ kiviat canvas
]

{ #category : #'private - accessing' }
RSMethodCategoryVisualizations >> canvasController [
	| controls |
	controls := RSCanvasController new.
	controls configuration 
		useBasicZoom;
		maxScale: 2.
	^ controls
]

{ #category : #initialization }
RSMethodCategoryVisualizations >> defaultIconName [

	^ #package
]

{ #category : #initialization }
RSMethodCategoryVisualizations >> defaultTitle [
	^'Protocols'
]

{ #category : #testing }
RSMethodCategoryVisualizations >> isSimilarTo: anotherBrowserTool [
	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^ false ].
	^ self targetClass = anotherBrowserTool targetClass
]

{ #category : #initialization }
RSMethodCategoryVisualizations >> setUpModelFromContext [

	self targetClass: (context metaLevelScope = ClyInstanceSideScope
			 ifTrue: [ context lastSelectedClass ]
			 ifFalse: [ context lastSelectedClass class ])
]

{ #category : #accessing }
RSMethodCategoryVisualizations >> targetClass [

	^ targetClass
]

{ #category : #accessing }
RSMethodCategoryVisualizations >> targetClass: aClass [ 
 
	targetClass := aClass
]
