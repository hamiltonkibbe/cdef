#Cdef

Generate C/C++ constant definitions from Matlab variables.

## Installation
Just copy cdef.m to a folder on your Matlab path.

## Printing to console
By default, cdef will print the definition to the matlab console.
Example:

```matlab
TestVector = hamming(10);
cdef(TestVector)
cdef(TestVector, 'precision', 'double')
cdef(TestVector, 'pack', false)
cdef(TestVector, 'varname', 'HammingTestVector', 'static', false)
```

Generates the following:

```c
static const float TestVector[10] =
{
    0.07999999821f, 0.187619552f, 0.4601218402f, 0.7699999809f, 0.9722586274f, 
    0.9722586274f, 0.7699999809f, 0.4601218402f, 0.187619552f, 0.07999999821f
};

static const double TestVector[10] =
{
    0.080000000000000016, 0.18761955616527015, 0.46012183827321207, 
    0.76999999999999991, 0.97225860556151789, 0.97225860556151789, 
    0.76999999999999991, 0.46012183827321207, 0.18761955616527015, 
    0.080000000000000016
};

static const float TestVector[10] =
{
    0.07999999821f,
    0.187619552f,
    0.4601218402f,
    0.7699999809f,
    0.9722586274f,
    0.9722586274f,
    0.7699999809f,
    0.4601218402f,
    0.187619552f,
    0.07999999821f
};

const float HammingTestVector[10] =
{
    0.07999999821f, 0.187619552f, 0.4601218402f, 0.7699999809f, 0.9722586274f, 
    0.9722586274f, 0.7699999809f, 0.4601218402f, 0.187619552f, 0.07999999821f
};
```

## Writing to header files
If the `filename` parameter is specified, the definition is written to the file specified.
Example:

```matlab
cdef(TestVector, 'precision', 'double', 'exportlength', true, 'filename', 'test.h')
```
Generates the following file:

```c
/* test.h
 * Generated by Matlab on 20-May-2015 11:54:13
 */

#ifndef TEST_H
#define TEST_H

#ifdef __cplusplus
extern "C" {
#endif

static const unsigned TestVectorLength = 10;

static const double TestVector[TestVectorLength] =
{
    0.080000000000000016, 0.18761955616527015, 0.46012183827321207, 
    0.76999999999999991, 0.97225860556151789, 0.97225860556151789, 
    0.76999999999999991, 0.46012183827321207, 0.18761955616527015, 
    0.080000000000000016
};


#ifdef __cplusplus
}
#endif

#endif /* TEST_H */
```
