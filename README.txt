How Our Code Works:
Look at the provided Wrapper.v in python code to determine size of input and size of output by opening the file and reading it,
looking at size(in_val) and size(out_val)

This will let us generate pseudo random bit inputs. The number of test inputs is the number of bits in the input times 100.
If the golden bitstream is being run, random inputs are generated and stored. If the bistream is the unknown bitstream,
the random inputs used in the golden bitstream are parsed and used as the inputs to the other bitstream.

The inputs and outputs for both bitstreams are stored as text files and then compared to determine what bits cause a difference in output.
If there is a difference in output, then we know that there is a trojan present that is affecting the output.

At the moment the program cannot tell us which bits are affected by the trojan. The values are XNORed but this result has not been verified.
