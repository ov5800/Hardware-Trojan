How Our Code Works:
Look at the provided Wrapper.v in python code to determine size of input and size of output by opening the file and reading it,
looking at size(in_val) and size (out_val)

This will let us generate pseudo random bit inputs without having to specify the size each time
Using this input size, we generate different test cases so that using pseudo random inputs,
we are able to test inputs and make a list of golden input-outputs and compare this list with the input-output list of the given bitstream to determine if it is safe or there is a trojan in it.
If they are not the same, then we know that the given RTL has a trojan

This will further be improved by 
