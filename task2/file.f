-timescale 1ns/1ns

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d

-incdir ./sv
-incdir ./tb
./sv/yapp_pkg.sv
./sv/yapp_if.sv

./tb/clkgen.sv
./tb/hw_top_no_dut.sv
./tb/tb_top.sv

+UVM_TESTNAME=new_test012
+UVM_VERBOSITY=UVM_HIGH
 +SVSEED=random
