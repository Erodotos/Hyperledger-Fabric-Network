“
ō#Å#
:
Add
x"T
y"T
z"T"
Ttype:
2	
A
AddV2
x"T
y"T
z"T"
Ttype:
2	
E
AssignAddVariableOp
resource
value"dtype"
dtypetype
B
AssignVariableOp
resource
value"dtype"
dtypetype
~
BiasAdd

value"T	
bias"T
output"T" 
Ttype:
2	"-
data_formatstringNHWC:
NHWCNCHW
~
BiasAddGrad
out_backprop"T
output"T" 
Ttype:
2	"-
data_formatstringNHWC:
NHWCNCHW
R
BroadcastGradientArgs
s0"T
s1"T
r0"T
r1"T"
Ttype0:
2	
Z
BroadcastTo

input"T
shape"Tidx
output"T"	
Ttype"
Tidxtype0:
2	
N
Cast	
x"SrcT	
y"DstT"
SrcTtype"
DstTtype"
Truncatebool( 
h
ConcatV2
values"T*N
axis"Tidx
output"T"
Nint(0"	
Ttype"
Tidxtype0:
2	
8
Const
output"dtype"
valuetensor"
dtypetype
8
DivNoNan
x"T
y"T
z"T"
Ttype:	
2
S
DynamicStitch
indices*N
data"T*N
merged"T"
Nint(0"	
Ttype
^
Fill
dims"
index_type

value"T
output"T"	
Ttype"

index_typetype0:
2	
?
FloorDiv
x"T
y"T
z"T"
Ttype:
2	
:
FloorMod
x"T
y"T
z"T"
Ttype:
	2	
­
GatherV2
params"Tparams
indices"Tindices
axis"Taxis
output"Tparams"

batch_dimsint "
Tparamstype"
Tindicestype:
2	"
Taxistype:
2	
.
Identity

input"T
output"T"	
Ttype
:
InvertPermutation
x"T
y"T"
Ttype0:
2	
q
MatMul
a"T
b"T
product"T"
transpose_abool( "
transpose_bbool( "
Ttype:

2	
:
Maximum
x"T
y"T
z"T"
Ttype:

2	

Mean

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
e
MergeV2Checkpoints
checkpoint_prefixes
destination_prefix"
delete_old_dirsbool(
=
Mul
x"T
y"T
z"T"
Ttype:
2	
0
Neg
x"T
y"T"
Ttype:
2
	

NoOp
M
Pack
values"T*N
output"T"
Nint(0"	
Ttype"
axisint 
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
X
PlaceholderWithDefault
input"dtype
output"dtype"
dtypetype"
shapeshape

Prod

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
~
RandomUniform

shape"T
output"dtype"
seedint "
seed2int "
dtypetype:
2"
Ttype:
2	
b
Range
start"Tidx
limit"Tidx
delta"Tidx
output"Tidx"
Tidxtype0:

2	
@
ReadVariableOp
resource
value"dtype"
dtypetype
>
RealDiv
x"T
y"T
z"T"
Ttype:
2	
[
Reshape
tensor"T
shape"Tshape
output"T"	
Ttype"
Tshapetype0:
2	
}
ResourceApplyGradientDescent
var

alpha"T

delta"T" 
Ttype:
2	"
use_lockingbool( 
o
	RestoreV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
l
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
?
Select
	condition

t"T
e"T
output"T"	
Ttype
P
Shape

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
H
ShardedFilename
basename	
shard

num_shards
filename
0
Sigmoid
x"T
y"T"
Ttype:

2
=
SigmoidGrad
y"T
dy"T
z"T"
Ttype:

2
O
Size

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
G
SquaredDifference
x"T
y"T
z"T"
Ttype:

2	
@
StaticRegexFullMatch	
input

output
"
patternstring
N

StringJoin
inputs*N

output"
Nint(0"
	separatorstring 
;
Sub
x"T
y"T
z"T"
Ttype:
2	

Sum

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
c
Tile

input"T
	multiples"
Tmultiples
output"T"	
Ttype"

Tmultiplestype0:
2	
P
	Transpose
x"T
perm"Tperm
y"T"	
Ttype"
Tpermtype0:
2	

VarHandleOp
resource"
	containerstring "
shared_namestring "
dtypetype"
shapeshape"#
allowed_deviceslist(string)
 
9
VarIsInitializedOp
resource
is_initialized
"TRAINING*2.3.02v2.3.0-rc2-23-gb36436b087
r
input_1Placeholder*+
_output_shapes
:’’’’’’’’’*
dtype0* 
shape:’’’’’’’’’
\
keras_learning_phase/inputConst*
_output_shapes
: *
dtype0
*
value	B
 Z 
|
keras_learning_phasePlaceholderWithDefaultkeras_learning_phase/input*
_output_shapes
: *
dtype0
*
shape: 
¹
:sequential/dense_0/kernel/Initializer/random_uniform/shapeConst*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
:*
dtype0*
valueB"      
«
8sequential/dense_0/kernel/Initializer/random_uniform/minConst*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Żæ
«
8sequential/dense_0/kernel/Initializer/random_uniform/maxConst*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Ż?

Bsequential/dense_0/kernel/Initializer/random_uniform/RandomUniformRandomUniform:sequential/dense_0/kernel/Initializer/random_uniform/shape*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes

:*
dtype0*

seed *
seed2 

8sequential/dense_0/kernel/Initializer/random_uniform/subSub8sequential/dense_0/kernel/Initializer/random_uniform/max8sequential/dense_0/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: 

8sequential/dense_0/kernel/Initializer/random_uniform/mulMulBsequential/dense_0/kernel/Initializer/random_uniform/RandomUniform8sequential/dense_0/kernel/Initializer/random_uniform/sub*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes

:

4sequential/dense_0/kernel/Initializer/random_uniformAdd8sequential/dense_0/kernel/Initializer/random_uniform/mul8sequential/dense_0/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes

:
ä
sequential/dense_0/kernelVarHandleOp*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape
:**
shared_namesequential/dense_0/kernel

:sequential/dense_0/kernel/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_0/kernel*
_output_shapes
: 

 sequential/dense_0/kernel/AssignAssignVariableOpsequential/dense_0/kernel4sequential/dense_0/kernel/Initializer/random_uniform*
dtype0

-sequential/dense_0/kernel/Read/ReadVariableOpReadVariableOpsequential/dense_0/kernel*
_output_shapes

:*
dtype0
¢
)sequential/dense_0/bias/Initializer/zerosConst**
_class 
loc:@sequential/dense_0/bias*
_output_shapes
:*
dtype0*
valueB*    
Ś
sequential/dense_0/biasVarHandleOp**
_class 
loc:@sequential/dense_0/bias*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape:*(
shared_namesequential/dense_0/bias

8sequential/dense_0/bias/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_0/bias*
_output_shapes
: 

sequential/dense_0/bias/AssignAssignVariableOpsequential/dense_0/bias)sequential/dense_0/bias/Initializer/zeros*
dtype0

+sequential/dense_0/bias/Read/ReadVariableOpReadVariableOpsequential/dense_0/bias*
_output_shapes
:*
dtype0

+sequential/dense_0/Tensordot/ReadVariableOpReadVariableOpsequential/dense_0/kernel*
_output_shapes

:*
dtype0
k
!sequential/dense_0/Tensordot/axesConst*
_output_shapes
:*
dtype0*
valueB:
r
!sequential/dense_0/Tensordot/freeConst*
_output_shapes
:*
dtype0*
valueB"       
i
"sequential/dense_0/Tensordot/ShapeShapeinput_1*
T0*
_output_shapes
:*
out_type0
l
*sequential/dense_0/Tensordot/GatherV2/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ž
%sequential/dense_0/Tensordot/GatherV2GatherV2"sequential/dense_0/Tensordot/Shape!sequential/dense_0/Tensordot/free*sequential/dense_0/Tensordot/GatherV2/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
n
,sequential/dense_0/Tensordot/GatherV2_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 

'sequential/dense_0/Tensordot/GatherV2_1GatherV2"sequential/dense_0/Tensordot/Shape!sequential/dense_0/Tensordot/axes,sequential/dense_0/Tensordot/GatherV2_1/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
l
"sequential/dense_0/Tensordot/ConstConst*
_output_shapes
:*
dtype0*
valueB: 
²
!sequential/dense_0/Tensordot/ProdProd%sequential/dense_0/Tensordot/GatherV2"sequential/dense_0/Tensordot/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
n
$sequential/dense_0/Tensordot/Const_1Const*
_output_shapes
:*
dtype0*
valueB: 
ø
#sequential/dense_0/Tensordot/Prod_1Prod'sequential/dense_0/Tensordot/GatherV2_1$sequential/dense_0/Tensordot/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
j
(sequential/dense_0/Tensordot/concat/axisConst*
_output_shapes
: *
dtype0*
value	B : 
Ł
#sequential/dense_0/Tensordot/concatConcatV2!sequential/dense_0/Tensordot/free!sequential/dense_0/Tensordot/axes(sequential/dense_0/Tensordot/concat/axis*
N*
T0*

Tidx0*
_output_shapes
:
¬
"sequential/dense_0/Tensordot/stackPack!sequential/dense_0/Tensordot/Prod#sequential/dense_0/Tensordot/Prod_1*
N*
T0*
_output_shapes
:*

axis 
¤
&sequential/dense_0/Tensordot/transpose	Transposeinput_1#sequential/dense_0/Tensordot/concat*
T0*
Tperm0*+
_output_shapes
:’’’’’’’’’
Ä
$sequential/dense_0/Tensordot/ReshapeReshape&sequential/dense_0/Tensordot/transpose"sequential/dense_0/Tensordot/stack*
T0*
Tshape0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ų
#sequential/dense_0/Tensordot/MatMulMatMul$sequential/dense_0/Tensordot/Reshape+sequential/dense_0/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b( 
n
$sequential/dense_0/Tensordot/Const_2Const*
_output_shapes
:*
dtype0*
valueB:
l
*sequential/dense_0/Tensordot/concat_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ä
%sequential/dense_0/Tensordot/concat_1ConcatV2%sequential/dense_0/Tensordot/GatherV2$sequential/dense_0/Tensordot/Const_2*sequential/dense_0/Tensordot/concat_1/axis*
N*
T0*

Tidx0*
_output_shapes
:
·
sequential/dense_0/TensordotReshape#sequential/dense_0/Tensordot/MatMul%sequential/dense_0/Tensordot/concat_1*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
}
)sequential/dense_0/BiasAdd/ReadVariableOpReadVariableOpsequential/dense_0/bias*
_output_shapes
:*
dtype0
»
sequential/dense_0/BiasAddBiasAddsequential/dense_0/Tensordot)sequential/dense_0/BiasAdd/ReadVariableOp*
T0*+
_output_shapes
:’’’’’’’’’*
data_formatNHWC
w
sequential/dense_0/SigmoidSigmoidsequential/dense_0/BiasAdd*
T0*+
_output_shapes
:’’’’’’’’’
¹
:sequential/dense_1/kernel/Initializer/random_uniform/shapeConst*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
:*
dtype0*
valueB"      
«
8sequential/dense_1/kernel/Initializer/random_uniform/minConst*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Żæ
«
8sequential/dense_1/kernel/Initializer/random_uniform/maxConst*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Ż?

Bsequential/dense_1/kernel/Initializer/random_uniform/RandomUniformRandomUniform:sequential/dense_1/kernel/Initializer/random_uniform/shape*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes

:*
dtype0*

seed *
seed2 

8sequential/dense_1/kernel/Initializer/random_uniform/subSub8sequential/dense_1/kernel/Initializer/random_uniform/max8sequential/dense_1/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: 

8sequential/dense_1/kernel/Initializer/random_uniform/mulMulBsequential/dense_1/kernel/Initializer/random_uniform/RandomUniform8sequential/dense_1/kernel/Initializer/random_uniform/sub*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes

:

4sequential/dense_1/kernel/Initializer/random_uniformAdd8sequential/dense_1/kernel/Initializer/random_uniform/mul8sequential/dense_1/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes

:
ä
sequential/dense_1/kernelVarHandleOp*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape
:**
shared_namesequential/dense_1/kernel

:sequential/dense_1/kernel/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_1/kernel*
_output_shapes
: 

 sequential/dense_1/kernel/AssignAssignVariableOpsequential/dense_1/kernel4sequential/dense_1/kernel/Initializer/random_uniform*
dtype0

-sequential/dense_1/kernel/Read/ReadVariableOpReadVariableOpsequential/dense_1/kernel*
_output_shapes

:*
dtype0
¢
)sequential/dense_1/bias/Initializer/zerosConst**
_class 
loc:@sequential/dense_1/bias*
_output_shapes
:*
dtype0*
valueB*    
Ś
sequential/dense_1/biasVarHandleOp**
_class 
loc:@sequential/dense_1/bias*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape:*(
shared_namesequential/dense_1/bias

8sequential/dense_1/bias/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_1/bias*
_output_shapes
: 

sequential/dense_1/bias/AssignAssignVariableOpsequential/dense_1/bias)sequential/dense_1/bias/Initializer/zeros*
dtype0

+sequential/dense_1/bias/Read/ReadVariableOpReadVariableOpsequential/dense_1/bias*
_output_shapes
:*
dtype0

+sequential/dense_1/Tensordot/ReadVariableOpReadVariableOpsequential/dense_1/kernel*
_output_shapes

:*
dtype0
k
!sequential/dense_1/Tensordot/axesConst*
_output_shapes
:*
dtype0*
valueB:
r
!sequential/dense_1/Tensordot/freeConst*
_output_shapes
:*
dtype0*
valueB"       
|
"sequential/dense_1/Tensordot/ShapeShapesequential/dense_0/Sigmoid*
T0*
_output_shapes
:*
out_type0
l
*sequential/dense_1/Tensordot/GatherV2/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ž
%sequential/dense_1/Tensordot/GatherV2GatherV2"sequential/dense_1/Tensordot/Shape!sequential/dense_1/Tensordot/free*sequential/dense_1/Tensordot/GatherV2/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
n
,sequential/dense_1/Tensordot/GatherV2_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 

'sequential/dense_1/Tensordot/GatherV2_1GatherV2"sequential/dense_1/Tensordot/Shape!sequential/dense_1/Tensordot/axes,sequential/dense_1/Tensordot/GatherV2_1/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
l
"sequential/dense_1/Tensordot/ConstConst*
_output_shapes
:*
dtype0*
valueB: 
²
!sequential/dense_1/Tensordot/ProdProd%sequential/dense_1/Tensordot/GatherV2"sequential/dense_1/Tensordot/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
n
$sequential/dense_1/Tensordot/Const_1Const*
_output_shapes
:*
dtype0*
valueB: 
ø
#sequential/dense_1/Tensordot/Prod_1Prod'sequential/dense_1/Tensordot/GatherV2_1$sequential/dense_1/Tensordot/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
j
(sequential/dense_1/Tensordot/concat/axisConst*
_output_shapes
: *
dtype0*
value	B : 
Ł
#sequential/dense_1/Tensordot/concatConcatV2!sequential/dense_1/Tensordot/free!sequential/dense_1/Tensordot/axes(sequential/dense_1/Tensordot/concat/axis*
N*
T0*

Tidx0*
_output_shapes
:
¬
"sequential/dense_1/Tensordot/stackPack!sequential/dense_1/Tensordot/Prod#sequential/dense_1/Tensordot/Prod_1*
N*
T0*
_output_shapes
:*

axis 
·
&sequential/dense_1/Tensordot/transpose	Transposesequential/dense_0/Sigmoid#sequential/dense_1/Tensordot/concat*
T0*
Tperm0*+
_output_shapes
:’’’’’’’’’
Ä
$sequential/dense_1/Tensordot/ReshapeReshape&sequential/dense_1/Tensordot/transpose"sequential/dense_1/Tensordot/stack*
T0*
Tshape0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ų
#sequential/dense_1/Tensordot/MatMulMatMul$sequential/dense_1/Tensordot/Reshape+sequential/dense_1/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b( 
n
$sequential/dense_1/Tensordot/Const_2Const*
_output_shapes
:*
dtype0*
valueB:
l
*sequential/dense_1/Tensordot/concat_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ä
%sequential/dense_1/Tensordot/concat_1ConcatV2%sequential/dense_1/Tensordot/GatherV2$sequential/dense_1/Tensordot/Const_2*sequential/dense_1/Tensordot/concat_1/axis*
N*
T0*

Tidx0*
_output_shapes
:
·
sequential/dense_1/TensordotReshape#sequential/dense_1/Tensordot/MatMul%sequential/dense_1/Tensordot/concat_1*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
}
)sequential/dense_1/BiasAdd/ReadVariableOpReadVariableOpsequential/dense_1/bias*
_output_shapes
:*
dtype0
»
sequential/dense_1/BiasAddBiasAddsequential/dense_1/Tensordot)sequential/dense_1/BiasAdd/ReadVariableOp*
T0*+
_output_shapes
:’’’’’’’’’*
data_formatNHWC

output_1_targetPlaceholder*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’*
dtype0*2
shape):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
®
$loss/output_1_loss/SquaredDifferenceSquaredDifferencesequential/dense_1/BiasAddoutput_1_target*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
t
)loss/output_1_loss/Mean/reduction_indicesConst*
_output_shapes
: *
dtype0*
valueB :
’’’’’’’’’
Č
loss/output_1_loss/MeanMean$loss/output_1_loss/SquaredDifference)loss/output_1_loss/Mean/reduction_indices*
T0*

Tidx0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’*
	keep_dims( 
k
&loss/output_1_loss/weighted_loss/ConstConst*
_output_shapes
: *
dtype0*
valueB
 *  ?
§
$loss/output_1_loss/weighted_loss/MulMulloss/output_1_loss/Mean&loss/output_1_loss/weighted_loss/Const*
T0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
i
loss/output_1_loss/ConstConst*
_output_shapes
:*
dtype0*
valueB"       

loss/output_1_loss/SumSum$loss/output_1_loss/weighted_loss/Mulloss/output_1_loss/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
~
loss/output_1_loss/num_elementsSize$loss/output_1_loss/weighted_loss/Mul*
T0*
_output_shapes
: *
out_type0

$loss/output_1_loss/num_elements/CastCastloss/output_1_loss/num_elements*

DstT0*

SrcT0*
Truncate( *
_output_shapes
: 
]
loss/output_1_loss/Const_1Const*
_output_shapes
: *
dtype0*
valueB 

loss/output_1_loss/Sum_1Sumloss/output_1_loss/Sumloss/output_1_loss/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

loss/output_1_loss/valueDivNoNanloss/output_1_loss/Sum_1$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
O

loss/mul/xConst*
_output_shapes
: *
dtype0*
valueB
 *  ?
V
loss/mulMul
loss/mul/xloss/output_1_loss/value*
T0*
_output_shapes
: 
i
&training/SGD/gradients/gradients/ShapeConst*
_output_shapes
: *
dtype0*
valueB 
o
*training/SGD/gradients/gradients/grad_ys_0Const*
_output_shapes
: *
dtype0*
valueB
 *  ?
“
%training/SGD/gradients/gradients/FillFill&training/SGD/gradients/gradients/Shape*training/SGD/gradients/gradients/grad_ys_0*
T0*
_output_shapes
: *

index_type0

2training/SGD/gradients/gradients/loss/mul_grad/MulMul%training/SGD/gradients/gradients/Fillloss/output_1_loss/value*
T0*
_output_shapes
: 

4training/SGD/gradients/gradients/loss/mul_grad/Mul_1Mul%training/SGD/gradients/gradients/Fill
loss/mul/x*
T0*
_output_shapes
: 

Dtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ShapeConst*
_output_shapes
: *
dtype0*
valueB 

Ftraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape_1Const*
_output_shapes
: *
dtype0*
valueB 
ø
Ttraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/BroadcastGradientArgsBroadcastGradientArgsDtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ShapeFtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape_1*
T0*2
_output_shapes 
:’’’’’’’’’:’’’’’’’’’
Ņ
Itraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nanDivNoNan4training/SGD/gradients/gradients/loss/mul_grad/Mul_1$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
Ø
Btraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/SumSumItraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nanTtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/BroadcastGradientArgs*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Ftraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ReshapeReshapeBtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/SumDtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape*
T0*
Tshape0*
_output_shapes
: 

Btraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/NegNegloss/output_1_loss/Sum_1*
T0*
_output_shapes
: 
ā
Ktraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_1DivNoNanBtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Neg$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
ė
Ktraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_2DivNoNanKtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_1$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
ķ
Btraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/mulMul4training/SGD/gradients/gradients/loss/mul_grad/Mul_1Ktraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_2*
T0*
_output_shapes
: 
„
Dtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Sum_1SumBtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/mulVtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/BroadcastGradientArgs:1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Htraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Reshape_1ReshapeDtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Sum_1Ftraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 

Ltraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/Reshape/shapeConst*
_output_shapes
: *
dtype0*
valueB 

Ftraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/ReshapeReshapeFtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ReshapeLtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes
: 

Dtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/ConstConst*
_output_shapes
: *
dtype0*
valueB 

Ctraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/TileTileFtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/ReshapeDtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/Const*
T0*

Tmultiples0*
_output_shapes
: 

Jtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Reshape/shapeConst*
_output_shapes
:*
dtype0*
valueB"      

Dtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/ReshapeReshapeCtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/TileJtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes

:
¦
Btraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/ShapeShape$loss/output_1_loss/weighted_loss/Mul*
T0*
_output_shapes
:*
out_type0
 
Atraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/TileTileDtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/ReshapeBtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Shape*
T0*

Tmultiples0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
§
Ptraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ShapeShapeloss/output_1_loss/Mean*
T0*
_output_shapes
:*
out_type0
¶
Rtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape_1Shape&loss/output_1_loss/weighted_loss/Const*
T0*
_output_shapes
: *
out_type0
Ü
`training/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/BroadcastGradientArgsBroadcastGradientArgsPtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ShapeRtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape_1*
T0*2
_output_shapes 
:’’’’’’’’’:’’’’’’’’’
ū
Ntraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/MulMulAtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Tile&loss/output_1_loss/weighted_loss/Const*
T0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ē
Ntraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/SumSumNtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Mul`training/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/BroadcastGradientArgs*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
Č
Rtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ReshapeReshapeNtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/SumPtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape*
T0*
Tshape0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
ī
Ptraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Mul_1Mulloss/output_1_loss/MeanAtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Tile*
T0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ķ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Sum_1SumPtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Mul_1btraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/BroadcastGradientArgs:1*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
“
Ttraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Reshape_1ReshapePtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Sum_1Rtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 
§
Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ShapeShape$loss/output_1_loss/SquaredDifference*
T0*
_output_shapes
:*
out_type0
Ü
Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/SizeConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B :
²
Atraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/addAddV2)loss/output_1_loss/Mean/reduction_indicesBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Size*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: 
Ķ
Atraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/modFloorModAtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/addBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Size*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: 
ą
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_1Const*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
valueB 
ć
Itraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/startConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B : 
ć
Itraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/deltaConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B :
¦
Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/rangeRangeItraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/startBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/SizeItraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/delta*

Tidx0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
:
ā
Htraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Fill/valueConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B :
ę
Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/FillFillEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_1Htraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Fill/value*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *

index_type0
ó
Ktraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/DynamicStitchDynamicStitchCtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/rangeAtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/modCtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ShapeBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Fill*
N*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
:
Ē
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ReshapeReshapeRtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ReshapeKtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/DynamicStitch*
T0*
Tshape0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
ø
Itraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/BroadcastToBroadcastToEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ReshapeCtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
T0*

Tidx0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
©
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_2Shape$loss/output_1_loss/SquaredDifference*
T0*
_output_shapes
:*
out_type0

Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_3Shapeloss/output_1_loss/Mean*
T0*
_output_shapes
:*
out_type0

Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ConstConst*
_output_shapes
:*
dtype0*
valueB: 

Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ProdProdEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_2Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Const_1Const*
_output_shapes
:*
dtype0*
valueB: 

Dtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Prod_1ProdEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_3Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Gtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Maximum/yConst*
_output_shapes
: *
dtype0*
value	B :

Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/MaximumMaximumDtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Prod_1Gtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Maximum/y*
T0*
_output_shapes
: 
ž
Ftraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/floordivFloorDivBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ProdEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Maximum*
T0*
_output_shapes
: 
Ņ
Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/CastCastFtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/floordiv*

DstT0*

SrcT0*
Truncate( *
_output_shapes
: 
§
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truedivRealDivItraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/BroadcastToBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Cast*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
Ž
Qtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/scalarConstF^training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truediv*
_output_shapes
: *
dtype0*
valueB
 *   @
·
Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/MulMulQtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/scalarEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truediv*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’

Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/subSubsequential/dense_1/BiasAddoutput_1_targetF^training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truediv*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
æ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/mul_1MulNtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/MulNtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/sub*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
Ŗ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ShapeShapesequential/dense_1/BiasAdd*
T0*
_output_shapes
:*
out_type0
”
Rtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape_1Shapeoutput_1_target*
T0*
_output_shapes
:*
out_type0
Ü
`training/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/BroadcastGradientArgsBroadcastGradientArgsPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ShapeRtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape_1*
T0*2
_output_shapes 
:’’’’’’’’’:’’’’’’’’’
É
Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/SumSumPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/mul_1`training/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/BroadcastGradientArgs*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
Ć
Rtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ReshapeReshapeNtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/SumPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
Ķ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Sum_1SumPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/mul_1btraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/BroadcastGradientArgs:1*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
Ū
Ttraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Reshape_1ReshapePtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Sum_1Rtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape_1*
T0*
Tshape0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
ó
Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/NegNegTtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Reshape_1*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
ė
Ltraining/SGD/gradients/gradients/sequential/dense_1/BiasAdd_grad/BiasAddGradBiasAddGradRtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Reshape*
T0*
_output_shapes
:*
data_formatNHWC
«
Htraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/ShapeShape#sequential/dense_1/Tensordot/MatMul*
T0*
_output_shapes
:*
out_type0
³
Jtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/ReshapeReshapeRtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ReshapeHtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/Shape*
T0*
Tshape0*'
_output_shapes
:’’’’’’’’’
«
Ptraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMulMatMulJtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/Reshape+sequential/dense_1/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b(

Rtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMul_1MatMul$sequential/dense_1/Tensordot/ReshapeJtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/Reshape*
T0*
_output_shapes

:*
transpose_a(*
transpose_b( 
¶
Ptraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/ShapeShape&sequential/dense_1/Tensordot/transpose*
T0*
_output_shapes
:*
out_type0
Å
Rtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/ReshapeReshapePtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMulPtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/Shape*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
½
^training/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/InvertPermutationInvertPermutation#sequential/dense_1/Tensordot/concat*
T0*
_output_shapes
:
Ś
Vtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/transpose	TransposeRtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/Reshape^training/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/InvertPermutation*
T0*
Tperm0*+
_output_shapes
:’’’’’’’’’

Ltraining/SGD/gradients/gradients/sequential/dense_0/Sigmoid_grad/SigmoidGradSigmoidGradsequential/dense_0/SigmoidVtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/transpose*
T0*+
_output_shapes
:’’’’’’’’’
å
Ltraining/SGD/gradients/gradients/sequential/dense_0/BiasAdd_grad/BiasAddGradBiasAddGradLtraining/SGD/gradients/gradients/sequential/dense_0/Sigmoid_grad/SigmoidGrad*
T0*
_output_shapes
:*
data_formatNHWC
«
Htraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/ShapeShape#sequential/dense_0/Tensordot/MatMul*
T0*
_output_shapes
:*
out_type0
­
Jtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/ReshapeReshapeLtraining/SGD/gradients/gradients/sequential/dense_0/Sigmoid_grad/SigmoidGradHtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/Shape*
T0*
Tshape0*'
_output_shapes
:’’’’’’’’’
«
Ptraining/SGD/gradients/gradients/sequential/dense_0/Tensordot/MatMul_grad/MatMulMatMulJtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/Reshape+sequential/dense_0/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b(

Rtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot/MatMul_grad/MatMul_1MatMul$sequential/dense_0/Tensordot/ReshapeJtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/Reshape*
T0*
_output_shapes

:*
transpose_a(*
transpose_b( 

#training/SGD/iter/Initializer/zerosConst*$
_class
loc:@training/SGD/iter*
_output_shapes
: *
dtype0	*
value	B	 R 
Ä
training/SGD/iterVarHandleOp*$
_class
loc:@training/SGD/iter*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0	*
shape: *"
shared_nametraining/SGD/iter
s
2training/SGD/iter/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/iter*
_output_shapes
: 
q
training/SGD/iter/AssignAssignVariableOptraining/SGD/iter#training/SGD/iter/Initializer/zeros*
dtype0	
o
%training/SGD/iter/Read/ReadVariableOpReadVariableOptraining/SGD/iter*
_output_shapes
: *
dtype0	

,training/SGD/decay/Initializer/initial_valueConst*%
_class
loc:@training/SGD/decay*
_output_shapes
: *
dtype0*
valueB
 *    
Ē
training/SGD/decayVarHandleOp*%
_class
loc:@training/SGD/decay*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape: *#
shared_nametraining/SGD/decay
u
3training/SGD/decay/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/decay*
_output_shapes
: 
|
training/SGD/decay/AssignAssignVariableOptraining/SGD/decay,training/SGD/decay/Initializer/initial_value*
dtype0
q
&training/SGD/decay/Read/ReadVariableOpReadVariableOptraining/SGD/decay*
_output_shapes
: *
dtype0
Ø
4training/SGD/learning_rate/Initializer/initial_valueConst*-
_class#
!loc:@training/SGD/learning_rate*
_output_shapes
: *
dtype0*
valueB
 *
×#<
ß
training/SGD/learning_rateVarHandleOp*-
_class#
!loc:@training/SGD/learning_rate*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape: *+
shared_nametraining/SGD/learning_rate

;training/SGD/learning_rate/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/learning_rate*
_output_shapes
: 

!training/SGD/learning_rate/AssignAssignVariableOptraining/SGD/learning_rate4training/SGD/learning_rate/Initializer/initial_value*
dtype0

.training/SGD/learning_rate/Read/ReadVariableOpReadVariableOptraining/SGD/learning_rate*
_output_shapes
: *
dtype0

/training/SGD/momentum/Initializer/initial_valueConst*(
_class
loc:@training/SGD/momentum*
_output_shapes
: *
dtype0*
valueB
 *    
Š
training/SGD/momentumVarHandleOp*(
_class
loc:@training/SGD/momentum*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape: *&
shared_nametraining/SGD/momentum
{
6training/SGD/momentum/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/momentum*
_output_shapes
: 

training/SGD/momentum/AssignAssignVariableOptraining/SGD/momentum/training/SGD/momentum/Initializer/initial_value*
dtype0
w
)training/SGD/momentum/Read/ReadVariableOpReadVariableOptraining/SGD/momentum*
_output_shapes
: *
dtype0
w
$training/SGD/Identity/ReadVariableOpReadVariableOptraining/SGD/learning_rate*
_output_shapes
: *
dtype0
h
training/SGD/IdentityIdentity$training/SGD/Identity/ReadVariableOp*
T0*
_output_shapes
: 
t
&training/SGD/Identity_1/ReadVariableOpReadVariableOptraining/SGD/momentum*
_output_shapes
: *
dtype0
l
training/SGD/Identity_1Identity&training/SGD/Identity_1/ReadVariableOp*
T0*
_output_shapes
: 
¾
Ntraining/SGD/SGD/update_sequential/dense_0/kernel/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_0/kerneltraining/SGD/IdentityRtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot/MatMul_grad/MatMul_1*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
use_locking(
²
Ltraining/SGD/SGD/update_sequential/dense_0/bias/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_0/biastraining/SGD/IdentityLtraining/SGD/gradients/gradients/sequential/dense_0/BiasAdd_grad/BiasAddGrad*
T0**
_class 
loc:@sequential/dense_0/bias*
use_locking(
¾
Ntraining/SGD/SGD/update_sequential/dense_1/kernel/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_1/kerneltraining/SGD/IdentityRtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMul_1*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
use_locking(
²
Ltraining/SGD/SGD/update_sequential/dense_1/bias/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_1/biastraining/SGD/IdentityLtraining/SGD/gradients/gradients/sequential/dense_1/BiasAdd_grad/BiasAddGrad*
T0**
_class 
loc:@sequential/dense_1/bias*
use_locking(

training/SGD/SGD/ConstConstM^training/SGD/SGD/update_sequential/dense_0/bias/ResourceApplyGradientDescentO^training/SGD/SGD/update_sequential/dense_0/kernel/ResourceApplyGradientDescentM^training/SGD/SGD/update_sequential/dense_1/bias/ResourceApplyGradientDescentO^training/SGD/SGD/update_sequential/dense_1/kernel/ResourceApplyGradientDescent*
_output_shapes
: *
dtype0	*
value	B	 R
s
$training/SGD/SGD/AssignAddVariableOpAssignAddVariableOptraining/SGD/itertraining/SGD/SGD/Const*
dtype0	
O
training_1/group_depsNoOp	^loss/mul%^training/SGD/SGD/AssignAddVariableOp
T
VarIsInitializedOpVarIsInitializedOptraining/SGD/decay*
_output_shapes
: 
]
VarIsInitializedOp_1VarIsInitializedOpsequential/dense_0/kernel*
_output_shapes
: 
]
VarIsInitializedOp_2VarIsInitializedOpsequential/dense_1/kernel*
_output_shapes
: 
[
VarIsInitializedOp_3VarIsInitializedOpsequential/dense_0/bias*
_output_shapes
: 
U
VarIsInitializedOp_4VarIsInitializedOptraining/SGD/iter*
_output_shapes
: 
^
VarIsInitializedOp_5VarIsInitializedOptraining/SGD/learning_rate*
_output_shapes
: 
Y
VarIsInitializedOp_6VarIsInitializedOptraining/SGD/momentum*
_output_shapes
: 
[
VarIsInitializedOp_7VarIsInitializedOpsequential/dense_1/bias*
_output_shapes
: 

initNoOp^sequential/dense_0/bias/Assign!^sequential/dense_0/kernel/Assign^sequential/dense_1/bias/Assign!^sequential/dense_1/kernel/Assign^training/SGD/decay/Assign^training/SGD/iter/Assign"^training/SGD/learning_rate/Assign^training/SGD/momentum/Assign
7
predict/group_depsNoOp^sequential/dense_1/BiasAdd
Y
save/filename/inputConst*
_output_shapes
: *
dtype0*
valueB Bmodel
n
save/filenamePlaceholderWithDefaultsave/filename/input*
_output_shapes
: *
dtype0*
shape: 
e

save/ConstPlaceholderWithDefaultsave/filename*
_output_shapes
: *
dtype0*
shape: 
{
save/StaticRegexFullMatchStaticRegexFullMatch
save/Const"/device:CPU:**
_output_shapes
: *
pattern
^s3://.*
a
save/Const_1Const"/device:CPU:**
_output_shapes
: *
dtype0*
valueB B.part

save/Const_2Const"/device:CPU:**
_output_shapes
: *
dtype0*<
value3B1 B+_temp_f94886b154bd4b3d83f61d18c5cb1964/part
|
save/SelectSelectsave/StaticRegexFullMatchsave/Const_1save/Const_2"/device:CPU:**
T0*
_output_shapes
: 
w
save/StringJoin
StringJoin
save/Constsave/Select"/device:CPU:**
N*
_output_shapes
: *
	separator 
Q
save/num_shardsConst*
_output_shapes
: *
dtype0*
value	B :
k
save/ShardedFilename/shardConst"/device:CPU:0*
_output_shapes
: *
dtype0*
value	B : 

save/ShardedFilenameShardedFilenamesave/StringJoinsave/ShardedFilename/shardsave/num_shards"/device:CPU:0*
_output_shapes
: 
³
save/SaveV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*×
valueĶBŹBsequential/dense_0/biasBsequential/dense_0/kernelBsequential/dense_1/biasBsequential/dense_1/kernelBtraining/SGD/decayBtraining/SGD/iterBtraining/SGD/learning_rateBtraining/SGD/momentum

save/SaveV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*#
valueBB B B B B B B B 
ģ
save/SaveV2SaveV2save/ShardedFilenamesave/SaveV2/tensor_namessave/SaveV2/shape_and_slices+sequential/dense_0/bias/Read/ReadVariableOp-sequential/dense_0/kernel/Read/ReadVariableOp+sequential/dense_1/bias/Read/ReadVariableOp-sequential/dense_1/kernel/Read/ReadVariableOp&training/SGD/decay/Read/ReadVariableOp%training/SGD/iter/Read/ReadVariableOp.training/SGD/learning_rate/Read/ReadVariableOp)training/SGD/momentum/Read/ReadVariableOp"/device:CPU:0*
dtypes

2	
 
save/control_dependencyIdentitysave/ShardedFilename^save/SaveV2"/device:CPU:0*
T0*'
_class
loc:@save/ShardedFilename*
_output_shapes
: 
¬
+save/MergeV2Checkpoints/checkpoint_prefixesPacksave/ShardedFilename^save/control_dependency"/device:CPU:0*
N*
T0*
_output_shapes
:*

axis 

save/MergeV2CheckpointsMergeV2Checkpoints+save/MergeV2Checkpoints/checkpoint_prefixes
save/Const"/device:CPU:0*
delete_old_dirs(

save/IdentityIdentity
save/Const^save/MergeV2Checkpoints^save/control_dependency"/device:CPU:0*
T0*
_output_shapes
: 
¶
save/RestoreV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*×
valueĶBŹBsequential/dense_0/biasBsequential/dense_0/kernelBsequential/dense_1/biasBsequential/dense_1/kernelBtraining/SGD/decayBtraining/SGD/iterBtraining/SGD/learning_rateBtraining/SGD/momentum

save/RestoreV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*#
valueBB B B B B B B B 
Ā
save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices"/device:CPU:0*4
_output_shapes"
 ::::::::*
dtypes

2	
N
save/Identity_1Identitysave/RestoreV2*
T0*
_output_shapes
:
`
save/AssignVariableOpAssignVariableOpsequential/dense_0/biassave/Identity_1*
dtype0
P
save/Identity_2Identitysave/RestoreV2:1*
T0*
_output_shapes
:
d
save/AssignVariableOp_1AssignVariableOpsequential/dense_0/kernelsave/Identity_2*
dtype0
P
save/Identity_3Identitysave/RestoreV2:2*
T0*
_output_shapes
:
b
save/AssignVariableOp_2AssignVariableOpsequential/dense_1/biassave/Identity_3*
dtype0
P
save/Identity_4Identitysave/RestoreV2:3*
T0*
_output_shapes
:
d
save/AssignVariableOp_3AssignVariableOpsequential/dense_1/kernelsave/Identity_4*
dtype0
P
save/Identity_5Identitysave/RestoreV2:4*
T0*
_output_shapes
:
]
save/AssignVariableOp_4AssignVariableOptraining/SGD/decaysave/Identity_5*
dtype0
P
save/Identity_6Identitysave/RestoreV2:5*
T0	*
_output_shapes
:
\
save/AssignVariableOp_5AssignVariableOptraining/SGD/itersave/Identity_6*
dtype0	
P
save/Identity_7Identitysave/RestoreV2:6*
T0*
_output_shapes
:
e
save/AssignVariableOp_6AssignVariableOptraining/SGD/learning_ratesave/Identity_7*
dtype0
P
save/Identity_8Identitysave/RestoreV2:7*
T0*
_output_shapes
:
`
save/AssignVariableOp_7AssignVariableOptraining/SGD/momentumsave/Identity_8*
dtype0
č
save/restore_shardNoOp^save/AssignVariableOp^save/AssignVariableOp_1^save/AssignVariableOp_2^save/AssignVariableOp_3^save/AssignVariableOp_4^save/AssignVariableOp_5^save/AssignVariableOp_6^save/AssignVariableOp_7
-
save/restore_allNoOp^save/restore_shard"ø<
save/Const:0save/Identity:0save/restore_all (5 @F8"µ
trainable_variables
¬
sequential/dense_0/kernel:0 sequential/dense_0/kernel/Assign/sequential/dense_0/kernel/Read/ReadVariableOp:0(26sequential/dense_0/kernel/Initializer/random_uniform:08

sequential/dense_0/bias:0sequential/dense_0/bias/Assign-sequential/dense_0/bias/Read/ReadVariableOp:0(2+sequential/dense_0/bias/Initializer/zeros:08
¬
sequential/dense_1/kernel:0 sequential/dense_1/kernel/Assign/sequential/dense_1/kernel/Read/ReadVariableOp:0(26sequential/dense_1/kernel/Initializer/random_uniform:08

sequential/dense_1/bias:0sequential/dense_1/bias/Assign-sequential/dense_1/bias/Read/ReadVariableOp:0(2+sequential/dense_1/bias/Initializer/zeros:08"

	variables


¬
sequential/dense_0/kernel:0 sequential/dense_0/kernel/Assign/sequential/dense_0/kernel/Read/ReadVariableOp:0(26sequential/dense_0/kernel/Initializer/random_uniform:08

sequential/dense_0/bias:0sequential/dense_0/bias/Assign-sequential/dense_0/bias/Read/ReadVariableOp:0(2+sequential/dense_0/bias/Initializer/zeros:08
¬
sequential/dense_1/kernel:0 sequential/dense_1/kernel/Assign/sequential/dense_1/kernel/Read/ReadVariableOp:0(26sequential/dense_1/kernel/Initializer/random_uniform:08

sequential/dense_1/bias:0sequential/dense_1/bias/Assign-sequential/dense_1/bias/Read/ReadVariableOp:0(2+sequential/dense_1/bias/Initializer/zeros:08

training/SGD/iter:0training/SGD/iter/Assign'training/SGD/iter/Read/ReadVariableOp:0(2%training/SGD/iter/Initializer/zeros:0H

training/SGD/decay:0training/SGD/decay/Assign(training/SGD/decay/Read/ReadVariableOp:0(2.training/SGD/decay/Initializer/initial_value:0H
Æ
training/SGD/learning_rate:0!training/SGD/learning_rate/Assign0training/SGD/learning_rate/Read/ReadVariableOp:0(26training/SGD/learning_rate/Initializer/initial_value:0H

training/SGD/momentum:0training/SGD/momentum/Assign+training/SGD/momentum/Read/ReadVariableOp:0(21training/SGD/momentum/Initializer/initial_value:0HŽ
ó#Å#
:
Add
x"T
y"T
z"T"
Ttype:
2	
A
AddV2
x"T
y"T
z"T"
Ttype:
2	
E
AssignAddVariableOp
resource
value"dtype"
dtypetype
B
AssignVariableOp
resource
value"dtype"
dtypetype
~
BiasAdd

value"T	
bias"T
output"T" 
Ttype:
2	"-
data_formatstringNHWC:
NHWCNCHW
~
BiasAddGrad
out_backprop"T
output"T" 
Ttype:
2	"-
data_formatstringNHWC:
NHWCNCHW
R
BroadcastGradientArgs
s0"T
s1"T
r0"T
r1"T"
Ttype0:
2	
Z
BroadcastTo

input"T
shape"Tidx
output"T"	
Ttype"
Tidxtype0:
2	
N
Cast	
x"SrcT	
y"DstT"
SrcTtype"
DstTtype"
Truncatebool( 
h
ConcatV2
values"T*N
axis"Tidx
output"T"
Nint(0"	
Ttype"
Tidxtype0:
2	
8
Const
output"dtype"
valuetensor"
dtypetype
8
DivNoNan
x"T
y"T
z"T"
Ttype:	
2
S
DynamicStitch
indices*N
data"T*N
merged"T"
Nint(0"	
Ttype
^
Fill
dims"
index_type

value"T
output"T"	
Ttype"

index_typetype0:
2	
?
FloorDiv
x"T
y"T
z"T"
Ttype:
2	
:
FloorMod
x"T
y"T
z"T"
Ttype:
	2	
­
GatherV2
params"Tparams
indices"Tindices
axis"Taxis
output"Tparams"

batch_dimsint "
Tparamstype"
Tindicestype:
2	"
Taxistype:
2	
.
Identity

input"T
output"T"	
Ttype
:
InvertPermutation
x"T
y"T"
Ttype0:
2	
q
MatMul
a"T
b"T
product"T"
transpose_abool( "
transpose_bbool( "
Ttype:

2	
:
Maximum
x"T
y"T
z"T"
Ttype:

2	

Mean

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
e
MergeV2Checkpoints
checkpoint_prefixes
destination_prefix"
delete_old_dirsbool(
=
Mul
x"T
y"T
z"T"
Ttype:
2	
0
Neg
x"T
y"T"
Ttype:
2
	

NoOp
M
Pack
values"T*N
output"T"
Nint(0"	
Ttype"
axisint 
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
X
PlaceholderWithDefault
input"dtype
output"dtype"
dtypetype"
shapeshape

Prod

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
~
RandomUniform

shape"T
output"dtype"
seedint "
seed2int "
dtypetype:
2"
Ttype:
2	
b
Range
start"Tidx
limit"Tidx
delta"Tidx
output"Tidx"
Tidxtype0:

2	
@
ReadVariableOp
resource
value"dtype"
dtypetype
>
RealDiv
x"T
y"T
z"T"
Ttype:
2	
[
Reshape
tensor"T
shape"Tshape
output"T"	
Ttype"
Tshapetype0:
2	
}
ResourceApplyGradientDescent
var

alpha"T

delta"T" 
Ttype:
2	"
use_lockingbool( 
o
	RestoreV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
l
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
?
Select
	condition

t"T
e"T
output"T"	
Ttype
P
Shape

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
H
ShardedFilename
basename	
shard

num_shards
filename
0
Sigmoid
x"T
y"T"
Ttype:

2
=
SigmoidGrad
y"T
dy"T
z"T"
Ttype:

2
O
Size

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
G
SquaredDifference
x"T
y"T
z"T"
Ttype:

2	
@
StaticRegexFullMatch	
input

output
"
patternstring
N

StringJoin
inputs*N

output"
Nint(0"
	separatorstring 
;
Sub
x"T
y"T
z"T"
Ttype:
2	

Sum

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
c
Tile

input"T
	multiples"
Tmultiples
output"T"	
Ttype"

Tmultiplestype0:
2	
P
	Transpose
x"T
perm"Tperm
y"T"	
Ttype"
Tpermtype0:
2	

VarHandleOp
resource"
	containerstring "
shared_namestring "
dtypetype"
shapeshape"#
allowed_deviceslist(string)
 
9
VarIsInitializedOp
resource
is_initialized
"SERVING*2.3.02v2.3.0-rc2-23-gb36436b087ż©
r
input_1Placeholder*+
_output_shapes
:’’’’’’’’’*
dtype0* 
shape:’’’’’’’’’
\
keras_learning_phase/inputConst*
_output_shapes
: *
dtype0
*
value	B
 Z 
|
keras_learning_phasePlaceholderWithDefaultkeras_learning_phase/input*
_output_shapes
: *
dtype0
*
shape: 
¹
:sequential/dense_0/kernel/Initializer/random_uniform/shapeConst*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
:*
dtype0*
valueB"      
«
8sequential/dense_0/kernel/Initializer/random_uniform/minConst*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Żæ
«
8sequential/dense_0/kernel/Initializer/random_uniform/maxConst*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Ż?

Bsequential/dense_0/kernel/Initializer/random_uniform/RandomUniformRandomUniform:sequential/dense_0/kernel/Initializer/random_uniform/shape*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes

:*
dtype0*

seed *
seed2 

8sequential/dense_0/kernel/Initializer/random_uniform/subSub8sequential/dense_0/kernel/Initializer/random_uniform/max8sequential/dense_0/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: 

8sequential/dense_0/kernel/Initializer/random_uniform/mulMulBsequential/dense_0/kernel/Initializer/random_uniform/RandomUniform8sequential/dense_0/kernel/Initializer/random_uniform/sub*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes

:

4sequential/dense_0/kernel/Initializer/random_uniformAdd8sequential/dense_0/kernel/Initializer/random_uniform/mul8sequential/dense_0/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes

:
ä
sequential/dense_0/kernelVarHandleOp*,
_class"
 loc:@sequential/dense_0/kernel*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape
:**
shared_namesequential/dense_0/kernel

:sequential/dense_0/kernel/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_0/kernel*
_output_shapes
: 

 sequential/dense_0/kernel/AssignAssignVariableOpsequential/dense_0/kernel4sequential/dense_0/kernel/Initializer/random_uniform*
dtype0

-sequential/dense_0/kernel/Read/ReadVariableOpReadVariableOpsequential/dense_0/kernel*
_output_shapes

:*
dtype0
¢
)sequential/dense_0/bias/Initializer/zerosConst**
_class 
loc:@sequential/dense_0/bias*
_output_shapes
:*
dtype0*
valueB*    
Ś
sequential/dense_0/biasVarHandleOp**
_class 
loc:@sequential/dense_0/bias*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape:*(
shared_namesequential/dense_0/bias

8sequential/dense_0/bias/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_0/bias*
_output_shapes
: 

sequential/dense_0/bias/AssignAssignVariableOpsequential/dense_0/bias)sequential/dense_0/bias/Initializer/zeros*
dtype0

+sequential/dense_0/bias/Read/ReadVariableOpReadVariableOpsequential/dense_0/bias*
_output_shapes
:*
dtype0

+sequential/dense_0/Tensordot/ReadVariableOpReadVariableOpsequential/dense_0/kernel*
_output_shapes

:*
dtype0
k
!sequential/dense_0/Tensordot/axesConst*
_output_shapes
:*
dtype0*
valueB:
r
!sequential/dense_0/Tensordot/freeConst*
_output_shapes
:*
dtype0*
valueB"       
i
"sequential/dense_0/Tensordot/ShapeShapeinput_1*
T0*
_output_shapes
:*
out_type0
l
*sequential/dense_0/Tensordot/GatherV2/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ž
%sequential/dense_0/Tensordot/GatherV2GatherV2"sequential/dense_0/Tensordot/Shape!sequential/dense_0/Tensordot/free*sequential/dense_0/Tensordot/GatherV2/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
n
,sequential/dense_0/Tensordot/GatherV2_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 

'sequential/dense_0/Tensordot/GatherV2_1GatherV2"sequential/dense_0/Tensordot/Shape!sequential/dense_0/Tensordot/axes,sequential/dense_0/Tensordot/GatherV2_1/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
l
"sequential/dense_0/Tensordot/ConstConst*
_output_shapes
:*
dtype0*
valueB: 
²
!sequential/dense_0/Tensordot/ProdProd%sequential/dense_0/Tensordot/GatherV2"sequential/dense_0/Tensordot/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
n
$sequential/dense_0/Tensordot/Const_1Const*
_output_shapes
:*
dtype0*
valueB: 
ø
#sequential/dense_0/Tensordot/Prod_1Prod'sequential/dense_0/Tensordot/GatherV2_1$sequential/dense_0/Tensordot/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
j
(sequential/dense_0/Tensordot/concat/axisConst*
_output_shapes
: *
dtype0*
value	B : 
Ł
#sequential/dense_0/Tensordot/concatConcatV2!sequential/dense_0/Tensordot/free!sequential/dense_0/Tensordot/axes(sequential/dense_0/Tensordot/concat/axis*
N*
T0*

Tidx0*
_output_shapes
:
¬
"sequential/dense_0/Tensordot/stackPack!sequential/dense_0/Tensordot/Prod#sequential/dense_0/Tensordot/Prod_1*
N*
T0*
_output_shapes
:*

axis 
¤
&sequential/dense_0/Tensordot/transpose	Transposeinput_1#sequential/dense_0/Tensordot/concat*
T0*
Tperm0*+
_output_shapes
:’’’’’’’’’
Ä
$sequential/dense_0/Tensordot/ReshapeReshape&sequential/dense_0/Tensordot/transpose"sequential/dense_0/Tensordot/stack*
T0*
Tshape0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ų
#sequential/dense_0/Tensordot/MatMulMatMul$sequential/dense_0/Tensordot/Reshape+sequential/dense_0/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b( 
n
$sequential/dense_0/Tensordot/Const_2Const*
_output_shapes
:*
dtype0*
valueB:
l
*sequential/dense_0/Tensordot/concat_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ä
%sequential/dense_0/Tensordot/concat_1ConcatV2%sequential/dense_0/Tensordot/GatherV2$sequential/dense_0/Tensordot/Const_2*sequential/dense_0/Tensordot/concat_1/axis*
N*
T0*

Tidx0*
_output_shapes
:
·
sequential/dense_0/TensordotReshape#sequential/dense_0/Tensordot/MatMul%sequential/dense_0/Tensordot/concat_1*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
}
)sequential/dense_0/BiasAdd/ReadVariableOpReadVariableOpsequential/dense_0/bias*
_output_shapes
:*
dtype0
»
sequential/dense_0/BiasAddBiasAddsequential/dense_0/Tensordot)sequential/dense_0/BiasAdd/ReadVariableOp*
T0*+
_output_shapes
:’’’’’’’’’*
data_formatNHWC
w
sequential/dense_0/SigmoidSigmoidsequential/dense_0/BiasAdd*
T0*+
_output_shapes
:’’’’’’’’’
¹
:sequential/dense_1/kernel/Initializer/random_uniform/shapeConst*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
:*
dtype0*
valueB"      
«
8sequential/dense_1/kernel/Initializer/random_uniform/minConst*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Żæ
«
8sequential/dense_1/kernel/Initializer/random_uniform/maxConst*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: *
dtype0*
valueB
 *×³Ż?

Bsequential/dense_1/kernel/Initializer/random_uniform/RandomUniformRandomUniform:sequential/dense_1/kernel/Initializer/random_uniform/shape*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes

:*
dtype0*

seed *
seed2 

8sequential/dense_1/kernel/Initializer/random_uniform/subSub8sequential/dense_1/kernel/Initializer/random_uniform/max8sequential/dense_1/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: 

8sequential/dense_1/kernel/Initializer/random_uniform/mulMulBsequential/dense_1/kernel/Initializer/random_uniform/RandomUniform8sequential/dense_1/kernel/Initializer/random_uniform/sub*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes

:

4sequential/dense_1/kernel/Initializer/random_uniformAdd8sequential/dense_1/kernel/Initializer/random_uniform/mul8sequential/dense_1/kernel/Initializer/random_uniform/min*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes

:
ä
sequential/dense_1/kernelVarHandleOp*,
_class"
 loc:@sequential/dense_1/kernel*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape
:**
shared_namesequential/dense_1/kernel

:sequential/dense_1/kernel/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_1/kernel*
_output_shapes
: 

 sequential/dense_1/kernel/AssignAssignVariableOpsequential/dense_1/kernel4sequential/dense_1/kernel/Initializer/random_uniform*
dtype0

-sequential/dense_1/kernel/Read/ReadVariableOpReadVariableOpsequential/dense_1/kernel*
_output_shapes

:*
dtype0
¢
)sequential/dense_1/bias/Initializer/zerosConst**
_class 
loc:@sequential/dense_1/bias*
_output_shapes
:*
dtype0*
valueB*    
Ś
sequential/dense_1/biasVarHandleOp**
_class 
loc:@sequential/dense_1/bias*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape:*(
shared_namesequential/dense_1/bias

8sequential/dense_1/bias/IsInitialized/VarIsInitializedOpVarIsInitializedOpsequential/dense_1/bias*
_output_shapes
: 

sequential/dense_1/bias/AssignAssignVariableOpsequential/dense_1/bias)sequential/dense_1/bias/Initializer/zeros*
dtype0

+sequential/dense_1/bias/Read/ReadVariableOpReadVariableOpsequential/dense_1/bias*
_output_shapes
:*
dtype0

+sequential/dense_1/Tensordot/ReadVariableOpReadVariableOpsequential/dense_1/kernel*
_output_shapes

:*
dtype0
k
!sequential/dense_1/Tensordot/axesConst*
_output_shapes
:*
dtype0*
valueB:
r
!sequential/dense_1/Tensordot/freeConst*
_output_shapes
:*
dtype0*
valueB"       
|
"sequential/dense_1/Tensordot/ShapeShapesequential/dense_0/Sigmoid*
T0*
_output_shapes
:*
out_type0
l
*sequential/dense_1/Tensordot/GatherV2/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ž
%sequential/dense_1/Tensordot/GatherV2GatherV2"sequential/dense_1/Tensordot/Shape!sequential/dense_1/Tensordot/free*sequential/dense_1/Tensordot/GatherV2/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
n
,sequential/dense_1/Tensordot/GatherV2_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 

'sequential/dense_1/Tensordot/GatherV2_1GatherV2"sequential/dense_1/Tensordot/Shape!sequential/dense_1/Tensordot/axes,sequential/dense_1/Tensordot/GatherV2_1/axis*
Taxis0*
Tindices0*
Tparams0*
_output_shapes
:*

batch_dims 
l
"sequential/dense_1/Tensordot/ConstConst*
_output_shapes
:*
dtype0*
valueB: 
²
!sequential/dense_1/Tensordot/ProdProd%sequential/dense_1/Tensordot/GatherV2"sequential/dense_1/Tensordot/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
n
$sequential/dense_1/Tensordot/Const_1Const*
_output_shapes
:*
dtype0*
valueB: 
ø
#sequential/dense_1/Tensordot/Prod_1Prod'sequential/dense_1/Tensordot/GatherV2_1$sequential/dense_1/Tensordot/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
j
(sequential/dense_1/Tensordot/concat/axisConst*
_output_shapes
: *
dtype0*
value	B : 
Ł
#sequential/dense_1/Tensordot/concatConcatV2!sequential/dense_1/Tensordot/free!sequential/dense_1/Tensordot/axes(sequential/dense_1/Tensordot/concat/axis*
N*
T0*

Tidx0*
_output_shapes
:
¬
"sequential/dense_1/Tensordot/stackPack!sequential/dense_1/Tensordot/Prod#sequential/dense_1/Tensordot/Prod_1*
N*
T0*
_output_shapes
:*

axis 
·
&sequential/dense_1/Tensordot/transpose	Transposesequential/dense_0/Sigmoid#sequential/dense_1/Tensordot/concat*
T0*
Tperm0*+
_output_shapes
:’’’’’’’’’
Ä
$sequential/dense_1/Tensordot/ReshapeReshape&sequential/dense_1/Tensordot/transpose"sequential/dense_1/Tensordot/stack*
T0*
Tshape0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ų
#sequential/dense_1/Tensordot/MatMulMatMul$sequential/dense_1/Tensordot/Reshape+sequential/dense_1/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b( 
n
$sequential/dense_1/Tensordot/Const_2Const*
_output_shapes
:*
dtype0*
valueB:
l
*sequential/dense_1/Tensordot/concat_1/axisConst*
_output_shapes
: *
dtype0*
value	B : 
ä
%sequential/dense_1/Tensordot/concat_1ConcatV2%sequential/dense_1/Tensordot/GatherV2$sequential/dense_1/Tensordot/Const_2*sequential/dense_1/Tensordot/concat_1/axis*
N*
T0*

Tidx0*
_output_shapes
:
·
sequential/dense_1/TensordotReshape#sequential/dense_1/Tensordot/MatMul%sequential/dense_1/Tensordot/concat_1*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
}
)sequential/dense_1/BiasAdd/ReadVariableOpReadVariableOpsequential/dense_1/bias*
_output_shapes
:*
dtype0
»
sequential/dense_1/BiasAddBiasAddsequential/dense_1/Tensordot)sequential/dense_1/BiasAdd/ReadVariableOp*
T0*+
_output_shapes
:’’’’’’’’’*
data_formatNHWC

output_1_targetPlaceholder*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’*
dtype0*2
shape):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
®
$loss/output_1_loss/SquaredDifferenceSquaredDifferencesequential/dense_1/BiasAddoutput_1_target*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
t
)loss/output_1_loss/Mean/reduction_indicesConst*
_output_shapes
: *
dtype0*
valueB :
’’’’’’’’’
Č
loss/output_1_loss/MeanMean$loss/output_1_loss/SquaredDifference)loss/output_1_loss/Mean/reduction_indices*
T0*

Tidx0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’*
	keep_dims( 
k
&loss/output_1_loss/weighted_loss/ConstConst*
_output_shapes
: *
dtype0*
valueB
 *  ?
§
$loss/output_1_loss/weighted_loss/MulMulloss/output_1_loss/Mean&loss/output_1_loss/weighted_loss/Const*
T0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
i
loss/output_1_loss/ConstConst*
_output_shapes
:*
dtype0*
valueB"       

loss/output_1_loss/SumSum$loss/output_1_loss/weighted_loss/Mulloss/output_1_loss/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 
~
loss/output_1_loss/num_elementsSize$loss/output_1_loss/weighted_loss/Mul*
T0*
_output_shapes
: *
out_type0

$loss/output_1_loss/num_elements/CastCastloss/output_1_loss/num_elements*

DstT0*

SrcT0*
Truncate( *
_output_shapes
: 
]
loss/output_1_loss/Const_1Const*
_output_shapes
: *
dtype0*
valueB 

loss/output_1_loss/Sum_1Sumloss/output_1_loss/Sumloss/output_1_loss/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

loss/output_1_loss/valueDivNoNanloss/output_1_loss/Sum_1$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
O

loss/mul/xConst*
_output_shapes
: *
dtype0*
valueB
 *  ?
V
loss/mulMul
loss/mul/xloss/output_1_loss/value*
T0*
_output_shapes
: 
i
&training/SGD/gradients/gradients/ShapeConst*
_output_shapes
: *
dtype0*
valueB 
o
*training/SGD/gradients/gradients/grad_ys_0Const*
_output_shapes
: *
dtype0*
valueB
 *  ?
“
%training/SGD/gradients/gradients/FillFill&training/SGD/gradients/gradients/Shape*training/SGD/gradients/gradients/grad_ys_0*
T0*
_output_shapes
: *

index_type0

2training/SGD/gradients/gradients/loss/mul_grad/MulMul%training/SGD/gradients/gradients/Fillloss/output_1_loss/value*
T0*
_output_shapes
: 

4training/SGD/gradients/gradients/loss/mul_grad/Mul_1Mul%training/SGD/gradients/gradients/Fill
loss/mul/x*
T0*
_output_shapes
: 

Dtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ShapeConst*
_output_shapes
: *
dtype0*
valueB 

Ftraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape_1Const*
_output_shapes
: *
dtype0*
valueB 
ø
Ttraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/BroadcastGradientArgsBroadcastGradientArgsDtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ShapeFtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape_1*
T0*2
_output_shapes 
:’’’’’’’’’:’’’’’’’’’
Ņ
Itraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nanDivNoNan4training/SGD/gradients/gradients/loss/mul_grad/Mul_1$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
Ø
Btraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/SumSumItraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nanTtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/BroadcastGradientArgs*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Ftraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ReshapeReshapeBtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/SumDtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape*
T0*
Tshape0*
_output_shapes
: 

Btraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/NegNegloss/output_1_loss/Sum_1*
T0*
_output_shapes
: 
ā
Ktraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_1DivNoNanBtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Neg$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
ė
Ktraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_2DivNoNanKtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_1$loss/output_1_loss/num_elements/Cast*
T0*
_output_shapes
: 
ķ
Btraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/mulMul4training/SGD/gradients/gradients/loss/mul_grad/Mul_1Ktraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/div_no_nan_2*
T0*
_output_shapes
: 
„
Dtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Sum_1SumBtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/mulVtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/BroadcastGradientArgs:1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Htraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Reshape_1ReshapeDtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Sum_1Ftraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 

Ltraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/Reshape/shapeConst*
_output_shapes
: *
dtype0*
valueB 

Ftraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/ReshapeReshapeFtraining/SGD/gradients/gradients/loss/output_1_loss/value_grad/ReshapeLtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes
: 

Dtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/ConstConst*
_output_shapes
: *
dtype0*
valueB 

Ctraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/TileTileFtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/ReshapeDtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/Const*
T0*

Tmultiples0*
_output_shapes
: 

Jtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Reshape/shapeConst*
_output_shapes
:*
dtype0*
valueB"      

Dtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/ReshapeReshapeCtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_1_grad/TileJtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes

:
¦
Btraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/ShapeShape$loss/output_1_loss/weighted_loss/Mul*
T0*
_output_shapes
:*
out_type0
 
Atraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/TileTileDtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/ReshapeBtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Shape*
T0*

Tmultiples0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
§
Ptraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ShapeShapeloss/output_1_loss/Mean*
T0*
_output_shapes
:*
out_type0
¶
Rtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape_1Shape&loss/output_1_loss/weighted_loss/Const*
T0*
_output_shapes
: *
out_type0
Ü
`training/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/BroadcastGradientArgsBroadcastGradientArgsPtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ShapeRtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape_1*
T0*2
_output_shapes 
:’’’’’’’’’:’’’’’’’’’
ū
Ntraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/MulMulAtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Tile&loss/output_1_loss/weighted_loss/Const*
T0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ē
Ntraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/SumSumNtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Mul`training/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/BroadcastGradientArgs*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
Č
Rtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ReshapeReshapeNtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/SumPtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape*
T0*
Tshape0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
ī
Ptraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Mul_1Mulloss/output_1_loss/MeanAtraining/SGD/gradients/gradients/loss/output_1_loss/Sum_grad/Tile*
T0*0
_output_shapes
:’’’’’’’’’’’’’’’’’’
Ķ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Sum_1SumPtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Mul_1btraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/BroadcastGradientArgs:1*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
“
Ttraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Reshape_1ReshapePtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Sum_1Rtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 
§
Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ShapeShape$loss/output_1_loss/SquaredDifference*
T0*
_output_shapes
:*
out_type0
Ü
Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/SizeConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B :
²
Atraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/addAddV2)loss/output_1_loss/Mean/reduction_indicesBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Size*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: 
Ķ
Atraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/modFloorModAtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/addBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Size*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: 
ą
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_1Const*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
valueB 
ć
Itraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/startConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B : 
ć
Itraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/deltaConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B :
¦
Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/rangeRangeItraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/startBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/SizeItraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/range/delta*

Tidx0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
:
ā
Htraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Fill/valueConst*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *
dtype0*
value	B :
ę
Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/FillFillEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_1Htraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Fill/value*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
: *

index_type0
ó
Ktraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/DynamicStitchDynamicStitchCtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/rangeAtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/modCtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ShapeBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Fill*
N*
T0*V
_classL
JHloc:@training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
_output_shapes
:
Ē
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ReshapeReshapeRtraining/SGD/gradients/gradients/loss/output_1_loss/weighted_loss/Mul_grad/ReshapeKtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/DynamicStitch*
T0*
Tshape0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
ø
Itraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/BroadcastToBroadcastToEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ReshapeCtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape*
T0*

Tidx0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
©
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_2Shape$loss/output_1_loss/SquaredDifference*
T0*
_output_shapes
:*
out_type0

Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_3Shapeloss/output_1_loss/Mean*
T0*
_output_shapes
:*
out_type0

Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ConstConst*
_output_shapes
:*
dtype0*
valueB: 

Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ProdProdEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_2Ctraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Const*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Const_1Const*
_output_shapes
:*
dtype0*
valueB: 

Dtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Prod_1ProdEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Shape_3Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Const_1*
T0*

Tidx0*
_output_shapes
: *
	keep_dims( 

Gtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Maximum/yConst*
_output_shapes
: *
dtype0*
value	B :

Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/MaximumMaximumDtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Prod_1Gtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Maximum/y*
T0*
_output_shapes
: 
ž
Ftraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/floordivFloorDivBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/ProdEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Maximum*
T0*
_output_shapes
: 
Ņ
Btraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/CastCastFtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/floordiv*

DstT0*

SrcT0*
Truncate( *
_output_shapes
: 
§
Etraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truedivRealDivItraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/BroadcastToBtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/Cast*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
Ž
Qtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/scalarConstF^training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truediv*
_output_shapes
: *
dtype0*
valueB
 *   @
·
Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/MulMulQtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/scalarEtraining/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truediv*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’

Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/subSubsequential/dense_1/BiasAddoutput_1_targetF^training/SGD/gradients/gradients/loss/output_1_loss/Mean_grad/truediv*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
æ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/mul_1MulNtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/MulNtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/sub*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
Ŗ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ShapeShapesequential/dense_1/BiasAdd*
T0*
_output_shapes
:*
out_type0
”
Rtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape_1Shapeoutput_1_target*
T0*
_output_shapes
:*
out_type0
Ü
`training/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/BroadcastGradientArgsBroadcastGradientArgsPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ShapeRtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape_1*
T0*2
_output_shapes 
:’’’’’’’’’:’’’’’’’’’
É
Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/SumSumPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/mul_1`training/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/BroadcastGradientArgs*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
Ć
Rtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ReshapeReshapeNtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/SumPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
Ķ
Ptraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Sum_1SumPtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/mul_1btraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/BroadcastGradientArgs:1*
T0*

Tidx0*
_output_shapes
:*
	keep_dims( 
Ū
Ttraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Reshape_1ReshapePtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Sum_1Rtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Shape_1*
T0*
Tshape0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
ó
Ntraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/NegNegTtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Reshape_1*
T0*=
_output_shapes+
):'’’’’’’’’’’’’’’’’’’’’’’’’’’’
ė
Ltraining/SGD/gradients/gradients/sequential/dense_1/BiasAdd_grad/BiasAddGradBiasAddGradRtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/Reshape*
T0*
_output_shapes
:*
data_formatNHWC
«
Htraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/ShapeShape#sequential/dense_1/Tensordot/MatMul*
T0*
_output_shapes
:*
out_type0
³
Jtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/ReshapeReshapeRtraining/SGD/gradients/gradients/loss/output_1_loss/SquaredDifference_grad/ReshapeHtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/Shape*
T0*
Tshape0*'
_output_shapes
:’’’’’’’’’
«
Ptraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMulMatMulJtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/Reshape+sequential/dense_1/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b(

Rtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMul_1MatMul$sequential/dense_1/Tensordot/ReshapeJtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot_grad/Reshape*
T0*
_output_shapes

:*
transpose_a(*
transpose_b( 
¶
Ptraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/ShapeShape&sequential/dense_1/Tensordot/transpose*
T0*
_output_shapes
:*
out_type0
Å
Rtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/ReshapeReshapePtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMulPtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/Shape*
T0*
Tshape0*+
_output_shapes
:’’’’’’’’’
½
^training/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/InvertPermutationInvertPermutation#sequential/dense_1/Tensordot/concat*
T0*
_output_shapes
:
Ś
Vtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/transpose	TransposeRtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/Reshape_grad/Reshape^training/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/InvertPermutation*
T0*
Tperm0*+
_output_shapes
:’’’’’’’’’

Ltraining/SGD/gradients/gradients/sequential/dense_0/Sigmoid_grad/SigmoidGradSigmoidGradsequential/dense_0/SigmoidVtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/transpose_grad/transpose*
T0*+
_output_shapes
:’’’’’’’’’
å
Ltraining/SGD/gradients/gradients/sequential/dense_0/BiasAdd_grad/BiasAddGradBiasAddGradLtraining/SGD/gradients/gradients/sequential/dense_0/Sigmoid_grad/SigmoidGrad*
T0*
_output_shapes
:*
data_formatNHWC
«
Htraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/ShapeShape#sequential/dense_0/Tensordot/MatMul*
T0*
_output_shapes
:*
out_type0
­
Jtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/ReshapeReshapeLtraining/SGD/gradients/gradients/sequential/dense_0/Sigmoid_grad/SigmoidGradHtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/Shape*
T0*
Tshape0*'
_output_shapes
:’’’’’’’’’
«
Ptraining/SGD/gradients/gradients/sequential/dense_0/Tensordot/MatMul_grad/MatMulMatMulJtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/Reshape+sequential/dense_0/Tensordot/ReadVariableOp*
T0*'
_output_shapes
:’’’’’’’’’*
transpose_a( *
transpose_b(

Rtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot/MatMul_grad/MatMul_1MatMul$sequential/dense_0/Tensordot/ReshapeJtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot_grad/Reshape*
T0*
_output_shapes

:*
transpose_a(*
transpose_b( 

#training/SGD/iter/Initializer/zerosConst*$
_class
loc:@training/SGD/iter*
_output_shapes
: *
dtype0	*
value	B	 R 
Ä
training/SGD/iterVarHandleOp*$
_class
loc:@training/SGD/iter*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0	*
shape: *"
shared_nametraining/SGD/iter
s
2training/SGD/iter/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/iter*
_output_shapes
: 
q
training/SGD/iter/AssignAssignVariableOptraining/SGD/iter#training/SGD/iter/Initializer/zeros*
dtype0	
o
%training/SGD/iter/Read/ReadVariableOpReadVariableOptraining/SGD/iter*
_output_shapes
: *
dtype0	

,training/SGD/decay/Initializer/initial_valueConst*%
_class
loc:@training/SGD/decay*
_output_shapes
: *
dtype0*
valueB
 *    
Ē
training/SGD/decayVarHandleOp*%
_class
loc:@training/SGD/decay*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape: *#
shared_nametraining/SGD/decay
u
3training/SGD/decay/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/decay*
_output_shapes
: 
|
training/SGD/decay/AssignAssignVariableOptraining/SGD/decay,training/SGD/decay/Initializer/initial_value*
dtype0
q
&training/SGD/decay/Read/ReadVariableOpReadVariableOptraining/SGD/decay*
_output_shapes
: *
dtype0
Ø
4training/SGD/learning_rate/Initializer/initial_valueConst*-
_class#
!loc:@training/SGD/learning_rate*
_output_shapes
: *
dtype0*
valueB
 *
×#<
ß
training/SGD/learning_rateVarHandleOp*-
_class#
!loc:@training/SGD/learning_rate*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape: *+
shared_nametraining/SGD/learning_rate

;training/SGD/learning_rate/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/learning_rate*
_output_shapes
: 

!training/SGD/learning_rate/AssignAssignVariableOptraining/SGD/learning_rate4training/SGD/learning_rate/Initializer/initial_value*
dtype0

.training/SGD/learning_rate/Read/ReadVariableOpReadVariableOptraining/SGD/learning_rate*
_output_shapes
: *
dtype0

/training/SGD/momentum/Initializer/initial_valueConst*(
_class
loc:@training/SGD/momentum*
_output_shapes
: *
dtype0*
valueB
 *    
Š
training/SGD/momentumVarHandleOp*(
_class
loc:@training/SGD/momentum*
_output_shapes
: *
allowed_devices
 *
	container *
dtype0*
shape: *&
shared_nametraining/SGD/momentum
{
6training/SGD/momentum/IsInitialized/VarIsInitializedOpVarIsInitializedOptraining/SGD/momentum*
_output_shapes
: 

training/SGD/momentum/AssignAssignVariableOptraining/SGD/momentum/training/SGD/momentum/Initializer/initial_value*
dtype0
w
)training/SGD/momentum/Read/ReadVariableOpReadVariableOptraining/SGD/momentum*
_output_shapes
: *
dtype0
w
$training/SGD/Identity/ReadVariableOpReadVariableOptraining/SGD/learning_rate*
_output_shapes
: *
dtype0
h
training/SGD/IdentityIdentity$training/SGD/Identity/ReadVariableOp*
T0*
_output_shapes
: 
t
&training/SGD/Identity_1/ReadVariableOpReadVariableOptraining/SGD/momentum*
_output_shapes
: *
dtype0
l
training/SGD/Identity_1Identity&training/SGD/Identity_1/ReadVariableOp*
T0*
_output_shapes
: 
¾
Ntraining/SGD/SGD/update_sequential/dense_0/kernel/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_0/kerneltraining/SGD/IdentityRtraining/SGD/gradients/gradients/sequential/dense_0/Tensordot/MatMul_grad/MatMul_1*
T0*,
_class"
 loc:@sequential/dense_0/kernel*
use_locking(
²
Ltraining/SGD/SGD/update_sequential/dense_0/bias/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_0/biastraining/SGD/IdentityLtraining/SGD/gradients/gradients/sequential/dense_0/BiasAdd_grad/BiasAddGrad*
T0**
_class 
loc:@sequential/dense_0/bias*
use_locking(
¾
Ntraining/SGD/SGD/update_sequential/dense_1/kernel/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_1/kerneltraining/SGD/IdentityRtraining/SGD/gradients/gradients/sequential/dense_1/Tensordot/MatMul_grad/MatMul_1*
T0*,
_class"
 loc:@sequential/dense_1/kernel*
use_locking(
²
Ltraining/SGD/SGD/update_sequential/dense_1/bias/ResourceApplyGradientDescentResourceApplyGradientDescentsequential/dense_1/biastraining/SGD/IdentityLtraining/SGD/gradients/gradients/sequential/dense_1/BiasAdd_grad/BiasAddGrad*
T0**
_class 
loc:@sequential/dense_1/bias*
use_locking(

training/SGD/SGD/ConstConstM^training/SGD/SGD/update_sequential/dense_0/bias/ResourceApplyGradientDescentO^training/SGD/SGD/update_sequential/dense_0/kernel/ResourceApplyGradientDescentM^training/SGD/SGD/update_sequential/dense_1/bias/ResourceApplyGradientDescentO^training/SGD/SGD/update_sequential/dense_1/kernel/ResourceApplyGradientDescent*
_output_shapes
: *
dtype0	*
value	B	 R
s
$training/SGD/SGD/AssignAddVariableOpAssignAddVariableOptraining/SGD/itertraining/SGD/SGD/Const*
dtype0	
O
training_1/group_depsNoOp	^loss/mul%^training/SGD/SGD/AssignAddVariableOp
T
VarIsInitializedOpVarIsInitializedOptraining/SGD/decay*
_output_shapes
: 
]
VarIsInitializedOp_1VarIsInitializedOpsequential/dense_0/kernel*
_output_shapes
: 
]
VarIsInitializedOp_2VarIsInitializedOpsequential/dense_1/kernel*
_output_shapes
: 
[
VarIsInitializedOp_3VarIsInitializedOpsequential/dense_0/bias*
_output_shapes
: 
U
VarIsInitializedOp_4VarIsInitializedOptraining/SGD/iter*
_output_shapes
: 
^
VarIsInitializedOp_5VarIsInitializedOptraining/SGD/learning_rate*
_output_shapes
: 
Y
VarIsInitializedOp_6VarIsInitializedOptraining/SGD/momentum*
_output_shapes
: 
[
VarIsInitializedOp_7VarIsInitializedOpsequential/dense_1/bias*
_output_shapes
: 

initNoOp^sequential/dense_0/bias/Assign!^sequential/dense_0/kernel/Assign^sequential/dense_1/bias/Assign!^sequential/dense_1/kernel/Assign^training/SGD/decay/Assign^training/SGD/iter/Assign"^training/SGD/learning_rate/Assign^training/SGD/momentum/Assign
7
predict/group_depsNoOp^sequential/dense_1/BiasAdd
Y
save/filename/inputConst*
_output_shapes
: *
dtype0*
valueB Bmodel
n
save/filenamePlaceholderWithDefaultsave/filename/input*
_output_shapes
: *
dtype0*
shape: 
e

save/ConstPlaceholderWithDefaultsave/filename*
_output_shapes
: *
dtype0*
shape: 
{
save/StaticRegexFullMatchStaticRegexFullMatch
save/Const"/device:CPU:**
_output_shapes
: *
pattern
^s3://.*
a
save/Const_1Const"/device:CPU:**
_output_shapes
: *
dtype0*
valueB B.part

save/Const_2Const"/device:CPU:**
_output_shapes
: *
dtype0*<
value3B1 B+_temp_f94886b154bd4b3d83f61d18c5cb1964/part
|
save/SelectSelectsave/StaticRegexFullMatchsave/Const_1save/Const_2"/device:CPU:**
T0*
_output_shapes
: 
w
save/StringJoin
StringJoin
save/Constsave/Select"/device:CPU:**
N*
_output_shapes
: *
	separator 
Q
save/num_shardsConst*
_output_shapes
: *
dtype0*
value	B :
k
save/ShardedFilename/shardConst"/device:CPU:0*
_output_shapes
: *
dtype0*
value	B : 

save/ShardedFilenameShardedFilenamesave/StringJoinsave/ShardedFilename/shardsave/num_shards"/device:CPU:0*
_output_shapes
: 
³
save/SaveV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*×
valueĶBŹBsequential/dense_0/biasBsequential/dense_0/kernelBsequential/dense_1/biasBsequential/dense_1/kernelBtraining/SGD/decayBtraining/SGD/iterBtraining/SGD/learning_rateBtraining/SGD/momentum

save/SaveV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*#
valueBB B B B B B B B 
ģ
save/SaveV2SaveV2save/ShardedFilenamesave/SaveV2/tensor_namessave/SaveV2/shape_and_slices+sequential/dense_0/bias/Read/ReadVariableOp-sequential/dense_0/kernel/Read/ReadVariableOp+sequential/dense_1/bias/Read/ReadVariableOp-sequential/dense_1/kernel/Read/ReadVariableOp&training/SGD/decay/Read/ReadVariableOp%training/SGD/iter/Read/ReadVariableOp.training/SGD/learning_rate/Read/ReadVariableOp)training/SGD/momentum/Read/ReadVariableOp"/device:CPU:0*
dtypes

2	
 
save/control_dependencyIdentitysave/ShardedFilename^save/SaveV2"/device:CPU:0*
T0*'
_class
loc:@save/ShardedFilename*
_output_shapes
: 
¬
+save/MergeV2Checkpoints/checkpoint_prefixesPacksave/ShardedFilename^save/control_dependency"/device:CPU:0*
N*
T0*
_output_shapes
:*

axis 

save/MergeV2CheckpointsMergeV2Checkpoints+save/MergeV2Checkpoints/checkpoint_prefixes
save/Const"/device:CPU:0*
delete_old_dirs(

save/IdentityIdentity
save/Const^save/MergeV2Checkpoints^save/control_dependency"/device:CPU:0*
T0*
_output_shapes
: 
¶
save/RestoreV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*×
valueĶBŹBsequential/dense_0/biasBsequential/dense_0/kernelBsequential/dense_1/biasBsequential/dense_1/kernelBtraining/SGD/decayBtraining/SGD/iterBtraining/SGD/learning_rateBtraining/SGD/momentum

save/RestoreV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*#
valueBB B B B B B B B 
Ā
save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices"/device:CPU:0*4
_output_shapes"
 ::::::::*
dtypes

2	
N
save/Identity_1Identitysave/RestoreV2*
T0*
_output_shapes
:
`
save/AssignVariableOpAssignVariableOpsequential/dense_0/biassave/Identity_1*
dtype0
P
save/Identity_2Identitysave/RestoreV2:1*
T0*
_output_shapes
:
d
save/AssignVariableOp_1AssignVariableOpsequential/dense_0/kernelsave/Identity_2*
dtype0
P
save/Identity_3Identitysave/RestoreV2:2*
T0*
_output_shapes
:
b
save/AssignVariableOp_2AssignVariableOpsequential/dense_1/biassave/Identity_3*
dtype0
P
save/Identity_4Identitysave/RestoreV2:3*
T0*
_output_shapes
:
d
save/AssignVariableOp_3AssignVariableOpsequential/dense_1/kernelsave/Identity_4*
dtype0
P
save/Identity_5Identitysave/RestoreV2:4*
T0*
_output_shapes
:
]
save/AssignVariableOp_4AssignVariableOptraining/SGD/decaysave/Identity_5*
dtype0
P
save/Identity_6Identitysave/RestoreV2:5*
T0	*
_output_shapes
:
\
save/AssignVariableOp_5AssignVariableOptraining/SGD/itersave/Identity_6*
dtype0	
P
save/Identity_7Identitysave/RestoreV2:6*
T0*
_output_shapes
:
e
save/AssignVariableOp_6AssignVariableOptraining/SGD/learning_ratesave/Identity_7*
dtype0
P
save/Identity_8Identitysave/RestoreV2:7*
T0*
_output_shapes
:
`
save/AssignVariableOp_7AssignVariableOptraining/SGD/momentumsave/Identity_8*
dtype0
č
save/restore_shardNoOp^save/AssignVariableOp^save/AssignVariableOp_1^save/AssignVariableOp_2^save/AssignVariableOp_3^save/AssignVariableOp_4^save/AssignVariableOp_5^save/AssignVariableOp_6^save/AssignVariableOp_7
-
save/restore_allNoOp^save/restore_shard
[
save_1/filename/inputConst*
_output_shapes
: *
dtype0*
valueB Bmodel
r
save_1/filenamePlaceholderWithDefaultsave_1/filename/input*
_output_shapes
: *
dtype0*
shape: 
i
save_1/ConstPlaceholderWithDefaultsave_1/filename*
_output_shapes
: *
dtype0*
shape: 

save_1/StaticRegexFullMatchStaticRegexFullMatchsave_1/Const"/device:CPU:**
_output_shapes
: *
pattern
^s3://.*
c
save_1/Const_1Const"/device:CPU:**
_output_shapes
: *
dtype0*
valueB B.part

save_1/Const_2Const"/device:CPU:**
_output_shapes
: *
dtype0*<
value3B1 B+_temp_2ca39207b50c499abb241d4e1a4d053e/part

save_1/SelectSelectsave_1/StaticRegexFullMatchsave_1/Const_1save_1/Const_2"/device:CPU:**
T0*
_output_shapes
: 
}
save_1/StringJoin
StringJoinsave_1/Constsave_1/Select"/device:CPU:**
N*
_output_shapes
: *
	separator 
S
save_1/num_shardsConst*
_output_shapes
: *
dtype0*
value	B :
m
save_1/ShardedFilename/shardConst"/device:CPU:0*
_output_shapes
: *
dtype0*
value	B : 

save_1/ShardedFilenameShardedFilenamesave_1/StringJoinsave_1/ShardedFilename/shardsave_1/num_shards"/device:CPU:0*
_output_shapes
: 
µ
save_1/SaveV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*×
valueĶBŹBsequential/dense_0/biasBsequential/dense_0/kernelBsequential/dense_1/biasBsequential/dense_1/kernelBtraining/SGD/decayBtraining/SGD/iterBtraining/SGD/learning_rateBtraining/SGD/momentum

save_1/SaveV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*#
valueBB B B B B B B B 
ō
save_1/SaveV2SaveV2save_1/ShardedFilenamesave_1/SaveV2/tensor_namessave_1/SaveV2/shape_and_slices+sequential/dense_0/bias/Read/ReadVariableOp-sequential/dense_0/kernel/Read/ReadVariableOp+sequential/dense_1/bias/Read/ReadVariableOp-sequential/dense_1/kernel/Read/ReadVariableOp&training/SGD/decay/Read/ReadVariableOp%training/SGD/iter/Read/ReadVariableOp.training/SGD/learning_rate/Read/ReadVariableOp)training/SGD/momentum/Read/ReadVariableOp"/device:CPU:0*
dtypes

2	
Ø
save_1/control_dependencyIdentitysave_1/ShardedFilename^save_1/SaveV2"/device:CPU:0*
T0*)
_class
loc:@save_1/ShardedFilename*
_output_shapes
: 
²
-save_1/MergeV2Checkpoints/checkpoint_prefixesPacksave_1/ShardedFilename^save_1/control_dependency"/device:CPU:0*
N*
T0*
_output_shapes
:*

axis 

save_1/MergeV2CheckpointsMergeV2Checkpoints-save_1/MergeV2Checkpoints/checkpoint_prefixessave_1/Const"/device:CPU:0*
delete_old_dirs(

save_1/IdentityIdentitysave_1/Const^save_1/MergeV2Checkpoints^save_1/control_dependency"/device:CPU:0*
T0*
_output_shapes
: 
ø
save_1/RestoreV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*×
valueĶBŹBsequential/dense_0/biasBsequential/dense_0/kernelBsequential/dense_1/biasBsequential/dense_1/kernelBtraining/SGD/decayBtraining/SGD/iterBtraining/SGD/learning_rateBtraining/SGD/momentum

!save_1/RestoreV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*#
valueBB B B B B B B B 
Ź
save_1/RestoreV2	RestoreV2save_1/Constsave_1/RestoreV2/tensor_names!save_1/RestoreV2/shape_and_slices"/device:CPU:0*4
_output_shapes"
 ::::::::*
dtypes

2	
R
save_1/Identity_1Identitysave_1/RestoreV2*
T0*
_output_shapes
:
d
save_1/AssignVariableOpAssignVariableOpsequential/dense_0/biassave_1/Identity_1*
dtype0
T
save_1/Identity_2Identitysave_1/RestoreV2:1*
T0*
_output_shapes
:
h
save_1/AssignVariableOp_1AssignVariableOpsequential/dense_0/kernelsave_1/Identity_2*
dtype0
T
save_1/Identity_3Identitysave_1/RestoreV2:2*
T0*
_output_shapes
:
f
save_1/AssignVariableOp_2AssignVariableOpsequential/dense_1/biassave_1/Identity_3*
dtype0
T
save_1/Identity_4Identitysave_1/RestoreV2:3*
T0*
_output_shapes
:
h
save_1/AssignVariableOp_3AssignVariableOpsequential/dense_1/kernelsave_1/Identity_4*
dtype0
T
save_1/Identity_5Identitysave_1/RestoreV2:4*
T0*
_output_shapes
:
a
save_1/AssignVariableOp_4AssignVariableOptraining/SGD/decaysave_1/Identity_5*
dtype0
T
save_1/Identity_6Identitysave_1/RestoreV2:5*
T0	*
_output_shapes
:
`
save_1/AssignVariableOp_5AssignVariableOptraining/SGD/itersave_1/Identity_6*
dtype0	
T
save_1/Identity_7Identitysave_1/RestoreV2:6*
T0*
_output_shapes
:
i
save_1/AssignVariableOp_6AssignVariableOptraining/SGD/learning_ratesave_1/Identity_7*
dtype0
T
save_1/Identity_8Identitysave_1/RestoreV2:7*
T0*
_output_shapes
:
d
save_1/AssignVariableOp_7AssignVariableOptraining/SGD/momentumsave_1/Identity_8*
dtype0
ś
save_1/restore_shardNoOp^save_1/AssignVariableOp^save_1/AssignVariableOp_1^save_1/AssignVariableOp_2^save_1/AssignVariableOp_3^save_1/AssignVariableOp_4^save_1/AssignVariableOp_5^save_1/AssignVariableOp_6^save_1/AssignVariableOp_7
1
save_1/restore_allNoOp^save_1/restore_shard"øB
save_1/Const:0save_1/Identity:0save_1/restore_all (5 @F8"µ
trainable_variables
¬
sequential/dense_0/kernel:0 sequential/dense_0/kernel/Assign/sequential/dense_0/kernel/Read/ReadVariableOp:0(26sequential/dense_0/kernel/Initializer/random_uniform:08

sequential/dense_0/bias:0sequential/dense_0/bias/Assign-sequential/dense_0/bias/Read/ReadVariableOp:0(2+sequential/dense_0/bias/Initializer/zeros:08
¬
sequential/dense_1/kernel:0 sequential/dense_1/kernel/Assign/sequential/dense_1/kernel/Read/ReadVariableOp:0(26sequential/dense_1/kernel/Initializer/random_uniform:08

sequential/dense_1/bias:0sequential/dense_1/bias/Assign-sequential/dense_1/bias/Read/ReadVariableOp:0(2+sequential/dense_1/bias/Initializer/zeros:08"

	variables


¬
sequential/dense_0/kernel:0 sequential/dense_0/kernel/Assign/sequential/dense_0/kernel/Read/ReadVariableOp:0(26sequential/dense_0/kernel/Initializer/random_uniform:08

sequential/dense_0/bias:0sequential/dense_0/bias/Assign-sequential/dense_0/bias/Read/ReadVariableOp:0(2+sequential/dense_0/bias/Initializer/zeros:08
¬
sequential/dense_1/kernel:0 sequential/dense_1/kernel/Assign/sequential/dense_1/kernel/Read/ReadVariableOp:0(26sequential/dense_1/kernel/Initializer/random_uniform:08

sequential/dense_1/bias:0sequential/dense_1/bias/Assign-sequential/dense_1/bias/Read/ReadVariableOp:0(2+sequential/dense_1/bias/Initializer/zeros:08

training/SGD/iter:0training/SGD/iter/Assign'training/SGD/iter/Read/ReadVariableOp:0(2%training/SGD/iter/Initializer/zeros:0H

training/SGD/decay:0training/SGD/decay/Assign(training/SGD/decay/Read/ReadVariableOp:0(2.training/SGD/decay/Initializer/initial_value:0H
Æ
training/SGD/learning_rate:0!training/SGD/learning_rate/Assign0training/SGD/learning_rate/Read/ReadVariableOp:0(26training/SGD/learning_rate/Initializer/initial_value:0H

training/SGD/momentum:0training/SGD/momentum/Assign+training/SGD/momentum/Read/ReadVariableOp:0(21training/SGD/momentum/Initializer/initial_value:0H