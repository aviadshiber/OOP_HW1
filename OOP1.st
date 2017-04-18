Object subclass: #Monom
	instanceVariableNames: 'exp coef'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!


!Monom methodsFor: 'accessing' stamp: 'initalize 3/29/2017 18:10'!
coef
	"getter of the field coef"
	^coef.! !

!Monom methodsFor: 'accessing' stamp: 'initalize 3/29/2017 18:37'!
coef: anInteger
	"The method is a setter of coef field. the method will throw error 'invalid input' anInteger is not an integer "
	(anInteger isInteger) ifTrue:[coef:=anInteger] ifFalse:[self error: 'invalid input'].! !

!Monom methodsFor: 'accessing' stamp: 'initalize 3/29/2017 18:05'!
exp
	"getter method of exp"
	^exp.! !

!Monom methodsFor: 'accessing' stamp: 'initalize 3/29/2017 18:26'!
exp: anInteger
	"a setter method of exp. the method will throw 'invalid input' error if the anInteger is not integer or the value is 	negative"
	|isValidInput|
	isValidInput:=(anInteger isInteger) and: [anInteger>=0]. "boolean contition with short-circuit"
	isValidInput ifTrue:[exp:=anInteger] ifFalse:[self error: 'invalid input' ].! !


!Monom methodsFor: 'comparing' stamp: 'initalize 4/1/2017 14:07'!
= anObject
 ^ (anObject isKindOf: Monom) and: [(Monom exp = anObject exp) and: [Monom coef = anObject coef]]! !

!Monom methodsFor: 'comparing' stamp: 'initalize 4/1/2017 14:19'!
hash
 ^ (coef raisedTo: (exp+1)) hash! !


!Monom methodsFor: 'printing' stamp: 'initalize 4/1/2017 17:18'!
printOn: aStream
	"The method will print a monom"
	|co ex str |
	(coef < 0)ifTrue:[co:= ('(', coef asString,')')] ifFalse:[co:= (coef asString)]. "handling negative number in coef"
	(exp=0) ifTrue:[ex:='']"default is empty string in case of exp=0"
	ifFalse:[
			(exp=1 )
			ifTrue:[ex:='x'] "handling the case that x^1=x"
			ifFalse:[ex:=('x',(exp asString))]. "otherwise show it as xexp"
			]. "end outer ifFalse"
	str:=co,ex.
	aStream nextPutAll: str.
									
	 ! !


!Monom methodsFor: 'initialize-release' stamp: 'initalize 3/29/2017 18:04'!
initialize
	coef:=0.
	exp:=0.! !


TestCase subclass: #PolyBlock
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!

!PolyBlock methodsFor: 'initialize-release' stamp: 'initalize 4/18/2017 19:51'!
initialize
"the method initialize a PolyBlock with the zero Polynom"
block:=[:x|0].! !


!PolyBlock methodsFor: 'accessing' stamp: 'initalize 4/18/2017 19:48'!
block
"the methods represent the block represntation of the polyBlock, the time & space complexity of the method is O(1)"
^block.! !


!PolyBlock methodsFor: 'adding' stamp: 'initalize 4/18/2017 19:59'!
add: aPolyBlock
"the method adds aPolyBlock to the this polyBlock, the time & space complexity of the method is O(1)"
|newBlock tempBlock|
((aPolyBlock notNil) and: [aPolyBlock isKindOf: PolyBlock])ifFalse:[self error:'invalid input'].
tempBlock := block.
newBlock:= [:x| self evalPolynom1:tempBlock evalPolynom2:(aPolyBlock block) op:0 value:x. ].
block:=newBlock.! !

!PolyBlock methodsFor: 'adding' stamp: 'initalize 4/18/2017 19:59'!
addCoef: coef withExp: exp
"the method creates a monom with coef and exp, and adds it to this polyBlock, the time & space complexity of the method is O(1)"
|newBlock tempBlock monomBlock|

(coef isInteger)ifFalse:[self error: 'invalid input'].
((exp isInteger) and: [exp>=0]) ifFalse:[self error: 'invalid input' ].

monomBlock:=[:x| coef*(x raisedTo:exp)].
tempBlock:=block.
newBlock:=[:x| self evalPolynom1:monomBlock evalPolynom2:tempBlock op:0 value:x.].
block:=newBlock.
! !


!PolyBlock methodsFor: 'calculations' stamp: 'initalize 4/18/2017 19:58'!
composeWith: aPolyBlock
"the methods compose this polyBlock with aPolyBlock, the time & space complexity of the method is O(1)"
|newBlock tempBlock|
((aPolyBlock notNil) and: [aPolyBlock isKindOf: PolyBlock])ifFalse:[self error:'invalid input'].
tempBlock := block.
newBlock:= [:x| self evalPolynom1:tempBlock evalPolynom2:(aPolyBlock block) op:2 value:x. ].
block:=newBlock.! !

!PolyBlock methodsFor: 'calculations' stamp: 'initalize 4/18/2017 19:50'!
eval:anInteger
"the method evaluates the polynom at integer point, the time complxity of the method is O(n) since it evaluate the enire chain recursivly. space complexity is O(1)"
(anInteger isInteger)ifFalse:[self error: 'invalid input'].
^(block value:anInteger).! !

!PolyBlock methodsFor: 'calculations' stamp: 'initalize 4/18/2017 19:58'!
multiplyBy: aPolyBlock
"the method multiply this polyBlock with aPolyBlock , the time & space complexity of the method is O(1)"
|newBlock tempBlock|
((aPolyBlock notNil) and: [aPolyBlock isKindOf: PolyBlock])ifFalse:[self error:'invalid input'].
tempBlock := block. "copy of block definition before evaluation"
newBlock:= [:x| self evalPolynom1:tempBlock evalPolynom2:(aPolyBlock block) op:1 value:x.].
block:=newBlock.
! !


!PolyBlock methodsFor: 'private' stamp: 'initalize 4/18/2017 19:56'!
evalPolynom1:p1 evalPolynom2:p2 op:anOpValue value:anInteger
"a private method which is incharge of the diffrent operations that can be done in a polyBlock module.
op=0 -> addition, op=1->multiplying,op=2 ->composing"
|res|.
res:=0. "default result value"
(anOpValue = 0)ifTrue:[res:=(p1 value:anInteger) + (p2 value:anInteger)]. "addition"
(anOpValue = 1)ifTrue:[res:=(p1 value:anInteger)*(p2 value:anInteger)]. "multiplying"
(anOpValue = 2)ifTrue:[res:=(p1 value:(p2 value:anInteger))]. "composing"
^res.! !


Object subclass: #Polynom
	instanceVariableNames: 'monoms'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!

!Polynom methodsFor: 'adding' stamp: 'initalize 4/1/2017 11:19'!
add: aPolynom
	"The method will return a newPolynom of the sum between self and aPolynom. aPolynom must be Polynom instance, otherwise throwing an error of 'invalid input'"
	| newPolynom  |
		newPolynom:= Polynom new.
		"now we need to building the newPolynom by adding all monoms in self and aPolynom"
		aPolynom addAllMonomsTo: newPolynom. "we add the first aPolynom to the newPolynom so that if aPolynom is not an instance of Polynom an error will be thrown."
		^ self addAllMonomsTo: newPolynom. "we returning the newPolynom after adding all monoms to it."
		
	
	
! !

!Polynom methodsFor: 'adding' stamp: 'initalize 4/1/2017 17:34'!
addMonom: aMonom
	"the method will copy aMonom and add it to the polynom (mutuable).
	if aMonom is not a Monom object than an error 	will be thrown as 'invalid method' "
	| monomKey monomValue value finalValue |
	self actionOnMonom: aMonom Do:[
			"if it has coef of 0 then we are done,no monom need to be added"
			(aMonom coef = 0) ifTrue:[^self].
			"we need to copy the values before adding them to the collection"
			monomKey:=aMonom exp.
			monomValue:=aMonom coef.
			"Also we need to check if the exp is already exist, if so we need to take him and edit his coef"
			value:=monoms at:(monomKey) "if present then then we add up the coef of aMonom with the monom in the map"
							ifAbsent:[0]. "no such exp(key) exist then value should be 0 so that only monomValue will be added"
			finalValue:=monomValue + value.
			(finalValue=0) 
							ifTrue:[monoms removeKey: monomKey ifAbsent: ["no key need to be removed"] ]  "if the final coef value is 0 then we need to remove the key"
							ifFalse:[monoms at:(monomKey) put:(finalValue)] . "otherwise update the key"
			]. "end of Do block"! !


!Polynom methodsFor: 'accessing' stamp: 'initalize 4/1/2017 17:51'!
asDictionary
	"the collection is already a Dictonary, so this is just a get method"
	^monoms.! !

!Polynom methodsFor: 'accessing' stamp: 'initalize 4/1/2017 13:37'!
iterator
	"The method return a block of the current state of the polynom.the block will allow to iterate over the collection in 	desc order of the exp value,"
|orderedMonoms|
"add them to the sorted Collection"
orderedMonoms:=self getSortedMonoms.

"after we have the sorted collection we retun a block which return the next element, respectivly. if no element exist a nil block is returened"
^[ |monom| (orderedMonoms isEmpty) 
	ifTrue:[nil]
	ifFalse:[
		monom:= Monom new.
		monom exp: (orderedMonoms first) exp.
		monom coef: (orderedMonoms first) coef.
		orderedMonoms removeFirst.
		monom
		] "end of false block"
	]. "end of retured block"! !


!Polynom methodsFor: 'calculations' stamp: 'initalize 4/14/2017 09:53'!
eval: anInteger
	"the method will evaluate the polynom in a certin point (anInteger)"
	| sum |
	"need to loop over the each key in the monoms and calculate the sum of aValue*(aPoint raisedTo akey)"
	(anInteger isInteger) ifFalse:[ self error:'invalid input'].
	sum:=0.
	monoms keysAndValuesDo: [:aKey :aValue |   sum:=sum+(aValue*(anInteger raisedTo: aKey))].
	^sum.! !

!Polynom methodsFor: 'calculations' stamp: 'initalize 4/1/2017 17:46'!
multiplyByMonom: aMonom
	"The method change the reciver and multiply the polynom by the monom. if aMonom is not a Monom error will be 	thrown error:'invalid input'"
	| monomCoef monomExp newMonoms|
	self actionOnMonom:aMonom Do:[
		newMonoms:=Polynom new.
		monomCoef:=aMonom coef.
		monomExp:=aMonom exp.
		monoms keysAndValuesDo: [:expKey :coefValue | | newKey newValue newM | 
									newKey:=monomExp+expKey.
									newValue:=monomCoef*coefValue.
									newM:=(Monom new) exp:newKey; coef:newValue.
									newMonoms addMonom: newM.
									].
		"updating the collection to the new dictionary"
		monoms:=newMonoms asDictionary.								
		].
	 ! !


!Polynom methodsFor: 'printing' stamp: 'initalize 4/1/2017 17:19'!
printOn:aStream
|orderdMonomC additionFlag str |
additionFlag :=0.
orderdMonomC := self getSortedMonoms.
str :='P(x) = '.
(orderdMonomC isEmpty)
	ifTrue:[
		str:= (str,'0').
		]
	ifFalse:[
		"iterate each monom (m) and concate it to the str"
		(orderdMonomC) do: [:m | 
									(additionFlag = 0)ifTrue:[additionFlag :=1]ifFalse:[str:= (str,' + ')]. "add a plus sign on every iteration except the first one"
									str:=str,m asString.
		]. "ending do block"
	]. "ending false block"
aStream nextPutAll: str.! !


!Polynom methodsFor: 'private' stamp: 'initalize 3/31/2017 11:17'!
actionOnMonom: aMonom Do:aBlock
	"the metod activate the block if aMonom is Monom object otherwise throwing an exception"
	(aMonom isKindOf: Monom) ifTrue:[aBlock value.] ifFalse: [self error:'invalid input'].! !

!Polynom methodsFor: 'private' stamp: 'initalize 4/1/2017 18:49'!
addAllMonomsTo:newPolynom
	"The method will add each monom in this(self) Polynom to the newPolynom using the addMonom method. The method will return the newPolynom"
	|iter monom|
	((newPolynom notNil) and:[newPolynom isKindOf: Polynom]) 
	ifTrue:[
		iter:= self iterator.
		monom:=iter value.
		[monom notNil] whileTrue: 
						[
						 newPolynom addMonom: monom.
						 monom:=iter value.
						]. "end while loop"
		] ifFalse:[self error: 'invalid input'].
	^newPolynom.! !

!Polynom methodsFor: 'private' stamp: 'initalize 4/1/2017 11:09'!
copyPolynomTo:newPolynom
	"The method will add each monom in this(self) Polynom to the newPolynom using the addMonom method. The method will return the newPolynom"
	|iter monom|
	(newPolynom isKindOf: Polynom) ifTrue:
		[
		iter:= self iterator.
		(monom:=(iter value) isNil) whileFalse:[ newPolynom addMonom: monom].
		] ifFalse:[self error: 'invalid input'].
	^newPolynom.! !

!Polynom methodsFor: 'private' stamp: 'initalize 4/1/2017 11:44'!
getSortedMonoms
"The method return the monoms collection as sortedCollection sorted by exp desc ordered."
|sortedCollection|
sortedCollection :=SortedCollection sortBlock: [:a :b | a exp>b exp].
"iterate over the dictionary and convert it to sortedCollection"
(monoms) keysAndValuesDo: [:ex :co| |monom| monom:=(Monom new) exp: ex; coef: co. sortedCollection add: monom].
^sortedCollection.! !


!Polynom methodsFor: 'initialize-release' stamp: 'initalize 3/31/2017 13:41'!
initialize
	"the method will initalize the collection to a Dictionary[key=exp,value=coef]"
	monoms:=Dictionary new.! !
