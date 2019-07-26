gui_open_window Wave
gui_sg_create PLL_CLK_group
gui_list_add_group -id Wave.1 {PLL_CLK_group}
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.test_phase}
gui_set_radix -radix {ascii} -signals {PLL_CLK_tb.test_phase}
gui_sg_addsignal -group PLL_CLK_group {{Input_clocks}} -divider
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.CLK_IN1}
gui_sg_addsignal -group PLL_CLK_group {{Output_clocks}} -divider
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.dut.clk}
gui_list_expand -id Wave.1 PLL_CLK_tb.dut.clk
gui_sg_addsignal -group PLL_CLK_group {{Status_control}} -divider
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.RESET}
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.LOCKED}
gui_sg_addsignal -group PLL_CLK_group {{Counters}} -divider
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.COUNT}
gui_sg_addsignal -group PLL_CLK_group {PLL_CLK_tb.dut.counter}
gui_list_expand -id Wave.1 PLL_CLK_tb.dut.counter
gui_zoom -window Wave.1 -full
