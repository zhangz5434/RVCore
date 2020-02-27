# RVCore
山东大学计算机组成原理 课程设计实验四
## 概述
这是一个（部分）实现了RISCV RV32I基础整数指令集的CPU设计。调试时FPGA芯片为Cyclone IV EP4CE6E22C8。其中，FENCE指令由NOP实现，ECALL和EBREAK被用于实现停机指令。
该CPU执行时分为五个阶段，分别是取指(FE)，译码(ID)，执行(EX)，内存访问(MEM)和写回(WB)。受限于精力，该CPU并没有实现流水线执行，而是使用一个节拍器依次执行这五个阶段。
## 坑
该CPU进行内存访问时必须对齐，否则会被MMU忽略。
## 致谢
该CPU的结构设计参考了Artoriuz设计的[https://github.com/Artoriuz/maestro](maestro)
