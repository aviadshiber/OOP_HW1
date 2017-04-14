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


TestCase subclass: #MonomTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!

!MonomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 18:58'!
testBasic
	| m1 |
	m1 := Monom new.
	m1 coef: 0 ; exp: 8.
	self should: [m1 coef: 0.5] raise: Error.
	self should: [m1 coef: 'asdf'] raise: Error.
	self should: [m1 exp: 0.5] raise: Error.
	self should: [m1 exp: -1] raise: Error.
	self should: [m1 exp: 'asdf'] raise: Error.
	! !


TestCase subclass: #PolyBlock
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!

!PolyBlock methodsFor: 'initialize-release' stamp: 'af 4/4/2017 12:33'!
initialize
block:=[:x|0].! !


!PolyBlock methodsFor: 'accessing' stamp: 'af 4/3/2017 16:43'!
block

^block.! !


!PolyBlock methodsFor: 'adding' stamp: 'af 4/4/2017 13:21'!
add: aPolyBlock
|newBlock tempBlock|
((aPolyBlock notNil) and: [aPolyBlock isKindOf: PolyBlock])ifFalse:[self error:'invalid input'].
tempBlock := block.
newBlock:= [:x|
		self evalPolynom1:tempBlock evalPolynom2:(aPolyBlock block) op:0 value:x.
	 ].
block:=newBlock.! !

!PolyBlock methodsFor: 'adding' stamp: 'af 4/4/2017 12:50'!
addCoef: coef withExp: exp
|newBlock tempBlock monomBlock|

(coef isInteger)ifFalse:[self error: 'invalid input'].
((exp isInteger) and: [exp>=0]) ifFalse:[self error: 'invalid input' ].

monomBlock:=[:x| coef*(x raisedTo:exp)].
tempBlock:=block.
newBlock:=[:x| 
	self evalPolynom1:monomBlock evalPolynom2:tempBlock op:0 value:x.
	].

block:=newBlock.
! !


!PolyBlock methodsFor: 'calculations' stamp: 'af 4/4/2017 13:22'!
composeWith: aPolyBlock
|newBlock tempBlock|
((aPolyBlock notNil) and: [aPolyBlock isKindOf: PolyBlock])ifFalse:[self error:'invalid input'].
tempBlock := block.

newBlock:= [:x|
		self evalPolynom1:tempBlock evalPolynom2:(aPolyBlock block) op:2 value:x.
	 ].
block:=newBlock.! !

!PolyBlock methodsFor: 'calculations' stamp: 'af 4/4/2017 13:10'!
eval:anInteger
(anInteger isInteger)ifFalse:[self error: 'invalid input'].
^(block value:anInteger).! !

!PolyBlock methodsFor: 'calculations' stamp: 'af 4/4/2017 13:21'!
multiplyBy: aPolyBlock
|newBlock tempBlock|
((aPolyBlock notNil) and: [aPolyBlock isKindOf: PolyBlock])ifFalse:[self error:'invalid input'].
tempBlock := block.

newBlock:= [:x|
		self evalPolynom1:tempBlock evalPolynom2:(aPolyBlock block) op:1 value:x.
	 ].
block:=newBlock.
! !


!PolyBlock methodsFor: 'private' stamp: 'af 4/4/2017 13:07'!
evalPolynom1:p1 evalPolynom2:p2 op:anOpValue value:anInteger
|res|.
res:=0.
(anOpValue = 0)ifTrue:[res:=(p1 value:anInteger) + (p2 value:anInteger)].
(anOpValue = 1)ifTrue:[res:=(p1 value:anInteger)*(p2 value:anInteger)].
(anOpValue = 2)ifTrue:[res:=(p1 value:(p2 value:anInteger))].

^res.! !


TestCase subclass: #PolyBlockTest
	instanceVariableNames: 'pb1 pb2 pb3 pb4 pb5'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!

!PolyBlockTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:24'!
testAdd
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	pb1 add: pb2.
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	pb3 add: pb1.
	self assert: ((pb3 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb3 := PolyBlock new.
	pb1 addCoef: 3 withExp: 2.
	pb1 addCoef: 1 withExp: 0.
	pb1 addCoef: 2 withExp: 0.
	pb1 addCoef: 3 withExp: 0.
	pb1 addCoef: 4 withExp: 0.
	pb1 addCoef: 5 withExp: 0.
	pb1 addCoef: 6 withExp: 0.
	pb1 addCoef: 7 withExp: 0. "P(x) = 3x2+28"
	pb2 addCoef: -2 withExp: 2.
	pb2 addCoef: -1 withExp: 0.
	pb2 addCoef: -2 withExp: 0.
	pb2 addCoef: -3 withExp: 0.
	pb2 addCoef: -4 withExp: 0.
	pb2 addCoef: -5 withExp: 0.
	pb2 addCoef: -6 withExp: 0.
	pb2 addCoef: 20 withExp: 0. "P(x) = (-2)x2+(-1)"
	
	pb2 add: pb1. "P(x) = 1x2+27"
	self assert: ((pb1 eval: 2) = 40). "P(x) = 3x2+28"
	self assert: ((pb2 eval: 0) = 27). "P(x) = 1x2+27"
	self assert: ((pb2 eval: 1) = 28). "P(x) = 1x2+27"
	self assert: ((pb2 eval: -1) = 28). "P(x) = 1x2+27"
	pb2 addCoef: -27 withExp: 0.
	pb3 add: pb2. "P(x) = 1x2"
	self assert: ((pb1 eval: 0) = 28). "P(x) = 3x2+28"
	self assert: ((pb2 eval: 2) = 4). "P(x) =1x2"
	self assert: ((pb3 eval: 0) = 0). "P(x) = 1x2"
	self assert: ((pb3 eval: 6) = 36). "P(x) = 1x2"
	self assert: ((pb3 eval: -10) = 100). "P(x) = 1x2"
	self assert: ((pb3 eval: 100) = 10000). "P(x) = 1x2"
	pb3 addCoef: -2 withExp: 2. "P(x) = (-1)x2"
	self assert: ((pb1 eval: 0) = 28). "P(x) = 3x2+28"
	self assert: ((pb2 eval: 2) = 4). "P(x) =1x2"
	self assert: ((pb3 eval: 0) = 0). "P(x) = (-1)x2"
	self assert: ((pb3 eval: 6) = -36). "P(x) = (-1)x2"
	self assert: ((pb3 eval: -10) = -100). "P(x) = (-1)x2"
	self assert: ((pb3 eval: 100) = -10000). "P(x) = (-1)x2"
	self should: [pb1 add: 1] raise: Error.
	self should: [pb1 add: 'asd'] raise: Error.
	! !

!PolyBlockTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:23'!
testAddCoefWithExp
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	pb1 addCoef: 3 withExp: 2.
	pb1 addCoef: 1 withExp: 0.
	pb1 addCoef: 2 withExp: 0.
	pb1 addCoef: 3 withExp: 0.
	pb1 addCoef: 4 withExp: 0.
	pb1 addCoef: 5 withExp: 0.
	pb1 addCoef: 6 withExp: 0.
	pb1 addCoef: 7 withExp: 0. "P(x) = 3x2+28"
	self assert: ((pb1 eval: 0) = 28).
	self assert: ((pb1 eval: 1) = 31).
	pb2 addCoef: 1 withExp: 0.
	pb2 addCoef: -1 withExp: 1.
	pb2 addCoef: 1 withExp: 2.
	pb2 addCoef: -1 withExp: 3.
	pb2 addCoef: 1 withExp: 4.
	pb2 addCoef: -1 withExp: 5.
	pb2 addCoef: 1 withExp: 6.
	pb2 addCoef: -1 withExp: 7. "P(x) = (-1)x7+1x6+(-1)x5+1x4+(-1)x3+1x2+(-1)x+1"
	self assert: ((pb2 eval: 0) = 1).
	self assert: ((pb2 eval: 1) = 0).
	self assert: ((pb2 eval: -1) = 8).
	pb2 addCoef: 1 withExp: 1.
	pb2 addCoef: -1 withExp: 2.
	pb2 addCoef: 1 withExp: 3.
	pb2 addCoef: -1 withExp: 4.
	pb2 addCoef: 1 withExp: 5.
	pb2 addCoef: -1 withExp: 6.
	pb2 addCoef: 1 withExp: 7. "P(x) = 1"
	self assert: ((pb2 eval: 42) = 1).
	self assert: ((pb2 eval: 1984) = 1).
	self assert: ((pb2 eval: 31415) = 1).
	self should: [pb1 addCoef: 1 withExp: -1] raise: Error.
	self should: [pb1 addCoef: 1.5 withExp: 1] raise: Error.
	self should: [pb1 addCoef: 1 withExp: 1.5] raise: Error.
	self should: [pb1 addCoef: 'ad' withExp: 1] raise: Error.
	self should: [pb1 addCoef: 1 withExp: 'ad'] raise: Error.
	! !

!PolyBlockTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:25'!
testCompose
	pb1 composeWith: pb2.
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	pb1 composeWith: pb2.
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	
	pb1 addCoef: 1 withExp: 1. "P(x) = 1x"
	pb2 addCoef: 2 withExp: 2. "P(x) = 2x2"
	pb3 addCoef: 3 withExp: 3. "P(x) = 3x3"
	pb4 addCoef: 0 withExp: 4. "P(x) = 0"
	pb5 addCoef: 5 withExp: 0. "P(x) = 5"
	
	pb1 composeWith: pb5. "P(x) = 5"
	self assert: ((pb1 eval: 1984) = 5).
	pb2 composeWith: pb5. "P(x) = 50"
	self assert: ((pb2 eval: 1984) = 50).
	pb3 composeWith: pb5. "P(x) = 375"
	self assert: ((pb3 eval: 1984) = 375).
	pb4 composeWith: pb5. "P(x) = 0"
	self assert: ((pb4 eval: 1984) = 0).
	
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb3 := PolyBlock new.
	pb4 := PolyBlock new.
	pb5 := PolyBlock new.
	
	pb1 addCoef: 1 withExp: 1. "P(x) = 1x"
	pb2 addCoef: 2 withExp: 2. "P(x) = 2x2"
	pb3 addCoef: 3 withExp: 3. "P(x) = 3x3"
	pb4 addCoef: 0 withExp: 4. "P(x) = 0"
	pb5 addCoef: 5 withExp: 0. "P(x) = 5"
	
	pb1 composeWith: pb4. "P(x) = 0"
	self assert: ((pb1 eval: 1984) = 0).
	pb2 composeWith: pb4. "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0).
	pb3 composeWith: pb4. "P(x) = 0"
	self assert: ((pb3 eval: 1984) = 0).
	pb5 composeWith: pb4. "P(x) = 5"
	self assert: ((pb5 eval: 1984) = 5).
	
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb3 := PolyBlock new.
	pb4 := PolyBlock new.
	pb5 := PolyBlock new.
	
	pb1 addCoef: 1 withExp: 1. "P(x) = 1x"
	pb2 addCoef: 2 withExp: 2. "P(x) = 2x2"
	pb3 addCoef: 3 withExp: 3. "P(x) = 3x3"
	pb4 addCoef: 0 withExp: 4. "P(x) = 0"
	pb5 addCoef: 5 withExp: 0. "P(x) = 5"
	
	pb2 composeWith: pb1. "P(x) = 2x2"
	self assert: ((pb2 eval: 20) = 800).
	pb3 composeWith: pb1. "P(x) = 3x3"
	self assert: ((pb3 eval: -3) = -81).
	pb4 composeWith: pb1. "P(x) = 0"
	self assert: ((pb4 eval: 1984) = 0).
	pb5 composeWith: pb1. "P(x) = 5"
	self assert: ((pb5 eval: 1984) = 5).
	
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb3 := PolyBlock new.
	pb4 := PolyBlock new.
	pb5 := PolyBlock new.
	
	pb1 addCoef: 1 withExp: 1. "P(x) = 1x"
	pb2 addCoef: 2 withExp: 2. "P(x) = 2x2"
	pb3 addCoef: 3 withExp: 3. "P(x) = 3x3"
	pb4 addCoef: 0 withExp: 4. "P(x) = 0"
	pb5 addCoef: 5 withExp: 0. "P(x) = 5"
	
	pb1 composeWith: pb2. "P(x) = 2x2"
	self assert: ((pb1 eval: 10) = 200).
	pb3 composeWith: pb2. "P(x) = 24x6"
	self assert: ((pb3 eval: 2) = 1536).
	pb4 composeWith: pb2. "P(x) = 0"
	self assert: ((pb4 eval: 1984) = 0).
	pb5 composeWith: pb2. "P(x) = 5"
	self assert: ((pb5 eval: 1984) = 5).
	
	self should: [pb1 composeWith: 1] raise: Error.
	self should: [pb1 composeWith: 'asd'] raise: Error.
	
	self should: [pb1 eval: 1.1] raise: Error.
	self should: [pb1 eval: 'asd'] raise: Error.
	! !

!PolyBlockTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:24'!
testMultiplyBy
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	pb1 multiplyBy: pb2.
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	pb3 multiplyBy: pb1.
	self assert: ((pb3 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb2 eval: 1984) = 0). "P(x) = 0"
	self assert: ((pb1 eval: 1984) = 0). "P(x) = 0"
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb3 := PolyBlock new.
	pb1 addCoef: 1 withExp: 1.
	pb1 addCoef: 1 withExp: 2.
	pb1 addCoef: 1 withExp: 3.
	pb1 addCoef: 1 withExp: 4. "P(x) = 1x4 + 1x3 + 1x2 + 1x"
	pb2 addCoef: 3 withExp: 0. "P(x) = 3"
	
	pb2 multiplyBy: pb1. "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	self assert: ((pb1 eval: 1) = 4). "P(x) = 1x4 + 1x3 + 1x2 + 1x"
	self assert: ((pb2 eval: 0) = 0). "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	self assert: ((pb2 eval: 1) = 12). "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	self assert: ((pb2 eval: -1) = 0). "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb1 addCoef: 1 withExp: 1.
	pb1 addCoef: 1 withExp: 2.
	pb1 addCoef: 1 withExp: 3.
	pb1 addCoef: 1 withExp: 4. "P(x) = 1x4 + 1x3 + 1x2 + 1x"
	pb2 addCoef: 3 withExp: 0. "P(x) = 3"
	
	pb1 multiplyBy: pb2. "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	self assert: ((pb2 eval: 1984) = 3). "P(x) = 3"
	self assert: ((pb1 eval: 0) = 0). "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	self assert: ((pb1 eval: 1) = 12). "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	self assert: ((pb1 eval: -1) = 0). "P(x) = 3x4 + 3x3 + 3x2 + 3x"
	
	pb3 addCoef: 1 withExp: 1. "P(x) = 1x"
	
	pb3 multiplyBy: pb2. "P(x) = 3x"
	self assert: ((pb2 eval: 1984) = 3). "P(x) = 3"
	self assert: ((pb3 eval: 0) = 0). "P(x) = 3x"
	self assert: ((pb3 eval: 1) = 3). "P(x) = 3x"
	self assert: ((pb3 eval: 2) = 6). "P(x) = 3x"
	pb3 multiplyBy: pb2. "P(x) = 9x"
	self assert: ((pb2 eval: 1984) = 3). "P(x) = 3"
	self assert: ((pb3 eval: 0) = 0). "P(x) = 9x"
	self assert: ((pb3 eval: -1) = -9). "P(x) = 9x"
	self assert: ((pb3 eval: -2) = -18). "P(x) = 9x"
	pb4 := pb3 copy.
	pb4 multiplyBy: pb3. "P(x) = 81x2"
	self assert: ((pb3 eval: 3) = 27). "P(x) = 9x"
	self assert: ((pb4 eval: 0) = 0). "P(x) = 81x2"
	self assert: ((pb4 eval: 1) = 81). "P(x) = 81x2"
	self assert: ((pb4 eval: -2) = 324). "P(x) = 81x2"
	self should: [pb1 multiplyBy: 1] raise: Error.
	self should: [pb1 multiplyBy: 'asd'] raise: Error.
	! !


!PolyBlockTest methodsFor: 'initialize-release' stamp: 'Omer 3/31/2017 20:47'!
setUp
	pb1 := PolyBlock new.
	pb2 := PolyBlock new.
	pb3 := PolyBlock new.
	pb4 := PolyBlock new.
	pb5 := PolyBlock new.
	! !


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


TestCase subclass: #PolynomTest
	instanceVariableNames: 'p1 p2 p3 i1 i2 i3 m6 m34 m26 mn71 m50 m00 m71 m08 m18 m05 iter m1 m2 iter1 mn26'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP1'!

!PolynomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:19'!
testAdd
	| temp |
	p1 addMonom: m34.
	p3 := p1 add: p2.
	self assert: ((p3 printString) = 'P(x) = 3x4').
	p3 := p2 add: p1.
	self assert: ((p3 printString) = 'P(x) = 3x4').
	((p1 addMonom: m26) addMonom: m71) addMonom: m50.
	temp := p3 add: p1.
	self assert: ((temp printString) = 'P(x) = 2x6 + 6x4 + 7x + 5').
	p1 addMonom: m26.
	p3 addMonom: m26.
	self assert: ((temp printString) = 'P(x) = 2x6 + 6x4 + 7x + 5'). "should not change"
	p1 := Polynom new.
	p1 addMonom: m26.
	p2 addMonom: mn26.
	p3 := p1 add: p2.
	self assert: ((p3 printString) = 'P(x) = 0').
	p3 := p2 add: p1.
	self assert: ((p3 printString) = 'P(x) = 0').
	self should: [p1 add: 0.5] raise: Error.
	self should: [p1 add: 'abc'] raise: Error.
	! !

!PolynomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:20'!
testAddMonom
	p1 addMonom: m34.
	self assert: ((p1 printString) = 'P(x) = 3x4').
	p1 addMonom: m26.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 3x4').
	p1 addMonom: mn71.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 3x4 + (-7)x').
	p1 addMonom: m50.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 3x4 + (-7)x + 5').
	p1 addMonom: m00.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 3x4 + (-7)x + 5').
	p1 addMonom: m71.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 3x4 + 5').
	p1 addMonom: m34.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 6x4 + 5').
	p1 addMonom: m08.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 6x4 + 5').
	m26 exp: 99; coef: 99.
	m34 exp: 99; coef: 99.
	m50 exp: 99; coef: 99.
	m08 exp: 99; coef: 99.
	self assert: ((p1 printString) = 'P(x) = 2x6 + 6x4 + 5').
	self should: [p1 addMonom: 123] raise: Error.
	self should: [p1 addMonom: 'abc'] raise: Error.
	! !

!PolynomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:13'!
testAsDictionary
	|dict|
	dict := p1 asDictionary.
	self assert: (dict isKindOf: Dictionary).
	self assert: (dict size = 0).
	(((p1 addMonom: m34) addMonom: m26) addMonom: mn71) addMonom: m50.
	dict := p1 asDictionary.
	self assert: (dict size = 4).
	self assert: ((dict at: 4) = 3).
	self assert: ((dict at: 6) = 2).
	self assert: ((dict at: 1) = -7).
	self assert: ((dict at: 0) = 5).
	self assert: ((dict includes: 42) = false).
	p1 multiplyByMonom: Monom new.
	dict := p1 asDictionary.
	self assert: (dict size = 0).
	(p1 addMonom: m71) addMonom: mn71.
	dict := p1 asDictionary.
	self assert: (dict size = 0).
	! !

!PolynomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:21'!
testEval
	self assert: ((p1 eval: 42) = 0).
	self assert: ((p1 eval: 42) = (p1 eval: 1984)).
	(((((p1 addMonom: m34) addMonom: m50) addMonom: mn71) addMonom: m08) addMonom: m18) addMonom: mn71.
	self assert: ((p1 printString) = 'P(x) = 1x8 + 3x4 + (-14)x + 5').
	self assert: ((p1 eval: 0) = 5).
	self assert: ((p1 eval: 1) = -5).
	self assert: ((p1 eval: -1) = 23).
	self assert: ((p1 eval: 10) = 100029865).
	self should: [p1 eval: 0.5] raise: Error.
	self should: [p1 eval: 'abc'] raise: Error.
	! !

!PolynomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:07'!
testIterator
	|monom1 monom2 monom3 monom4|
	iter1 := p1 iterator.
	self assert: (iter1 value = nil).
	(((p1 addMonom: m34) addMonom: m26) addMonom: mn71) addMonom: m50.
	iter1 :=p1 iterator.
	monom1 := iter1 value.
	self assert: ((monom1 coef = 2) and:[monom1 exp = 6]).
	monom2 := iter1 value.
	self assert: ((monom2 coef = 3) and:[monom2 exp = 4]).
	monom3 := iter1 value.
	self assert: ((monom3 coef = -7) and:[monom3 exp = 1]).
	monom4 := iter1 value.
	self assert: ((monom4 coef = 5) and:[monom4 exp = 0]).
	self assert: (iter1 value = nil).
	self assert: ((p1 printString) = 'P(x) = 2x6 + 3x4 + (-7)x + 5').
	iter1 :=p1 iterator.
	p1 addMonom: mn26.
	monom1 := iter1 value.
	self assert: ((monom1 coef = 2) and:[monom1 exp = 6]).
	iter1 :=p1 iterator.
	monom1 := iter1 value.
	self assert: ((monom1 coef = 3) and:[monom1 exp = 4]).
	! !

!PolynomTest methodsFor: 'testing' stamp: 'MM 4/10/2017 19:21'!
testMultiplyByMonom
	p1 multiplyByMonom: m34. "P(x) = 0"
	self assert: ((p1 printString) = 'P(x) = 0').
	p1 addMonom: m34.
	p1 multiplyByMonom: m00. "P(x) = 0"
	self assert: ((p1 printString) = 'P(x) = 0').
	p1 addMonom: m34.
	p1 addMonom: m34.
	p1 addMonom: mn71.
	p1 addMonom: m50.
	p1 addMonom: m50.
	p1 multiplyByMonom: m34.
	self assert: ((p1 printString) = 'P(x) = 18x8 + (-21)x5 + 30x4').
	p1 multiplyByMonom: mn71.
	self assert: ((p1 printString) = 'P(x) = (-126)x9 + 147x6 + (-210)x5').
	p1 multiplyByMonom: m50.
	self assert: ((p1 printString) = 'P(x) = (-630)x9 + 735x6 + (-1050)x5').
	p1 multiplyByMonom: m18.
	self assert: ((p1 printString) = 'P(x) = (-630)x17 + 735x14 + (-1050)x13').
	m18 exp: 99; coef: 99.
	m50 exp: 99; coef: 99.
	mn71 exp: 99; coef: 99.
	m34 exp: 99; coef: 99.
	self assert: ((p1 printString) = 'P(x) = (-630)x17 + 735x14 + (-1050)x13').
	self should: [p1 multiplyByMonom: 123] raise: Error.
	self should: [p1 multiplyByMonom: 'abc'] raise: Error.
	! !

!PolynomTest methodsFor: 'testing' stamp: 'Omer 3/31/2017 21:00'!
testPrintOn
	self assert: ((p1 printString) = 'P(x) = 0').
	! !


!PolynomTest methodsFor: 'initialize-release' stamp: 'Omer 3/31/2017 20:53'!
setUp
	p1 := Polynom new.
	p2 := Polynom new.
	p3 := Polynom new.
	m34 := Monom new.
	m34 coef: 3 ; exp: 4.
	m26 := Monom new.
	m26 coef: 2 ; exp: 6.
	mn26 := Monom new.
	mn26 coef: -2 ; exp: 6.
	mn71 := Monom new.
	mn71 coef: -7 ; exp: 1.
	m50 := Monom new.
	m50 coef: 5 ; exp: 0.
	m00 := Monom new.
	m00 coef: 0 ; exp: 0.
	m71 := Monom new.
	m71 coef: 7 ; exp: 1.
	m08 := Monom new.
	m08 coef: 0 ; exp: 8.
	m18 := Monom new.
	m18 coef: 1 ; exp: 8.! !
