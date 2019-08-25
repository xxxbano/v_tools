# v_tools
This library is used to store useful verilog code


##### Verilog files:
- [fifo.v](rtl/fifo.v): 
- [lifo.v](rtl/lifo.v)
##### UnitTest files:
- [fifo_unit_test.sv](testbench/fifo_unit_test.sv): Find each test in \`SVTEST(mytest) 
- [lifo_unit_test.sv](testbench/lifo_unit_test.sv): Find each test in \`SVTEST(mytest) 
- [Test_Results](testbench/Test_Results): Test Summary

##### ToDo:
- 

#### Waveform from UnitTest
##### fifo:
##### lifo:
![alt text](https://github.com/xxxbano/Hardware_Calculator/blob/master/testbench/waveform/stack_1.png "Logo Title Text 1")

#### About UnitTest
The UnitTest is designed by using SVUnit in Linux

##### Setup SVUnit:
1. Download: http://agilesoc.com/open-source-projects/svunit/
2. mv svunit-code to a directory
3. setenv SVUNIT_INSTALL /directory/svunit-code 
4. add path /direcotry svunit-code/bin 
5. cd testbench; ln -s ../rtl/*.v; if no files in testbench folder 
6. run testbench: ./runUtest.csh 

If you do not have modelsim, setup vcs etc.(has limitation) in runUtest.csh file
runSVunit -s (simulator)

