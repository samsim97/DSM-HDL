# Copilot / AI Agent Instructions for DSM-HDL

Purpose: give succinct, repository-specific guidance so an AI coding agent can be productive immediately.

- Big picture
  - This repo implements a first-order Delta-Sigma DAC in synthesizable Verilog. The main signal flow is: delta_feedback -> integrator -> quantizer. See `src/rtl/dsm_dac.v` for the composed top-level module.
  - Each building block is a small, parameterized module: `delta_feedback.v`, `integrator.v`, `quantizer.v`. Widths and behavior are driven by parameters such as `DATA_WIDTH`, `ACC_WIDTH`, and `FEEDBACK_MAG`.

- Key files and locations (start here)
  - Top-level RTL: `src/rtl/dsm_dac.v`
  - Building blocks: `src/rtl/delta_feedback.v`, `src/rtl/integrator.v`, `src/rtl/quantizer.v`
  - Testbenches: `src/tb/` (look at `tb_dsm_dac.v`)
  - Test stimulus helper: `script/gen_input_signal.py` (prints `r_input_signal[...]` assignments)
  - Package placeholder: `src/pkg/input_pkg.v` (currently empty)

- Project-specific conventions and patterns
  - Narrow, composable modules: prefer one clear responsibility per file (e.g., integrator only accumulates signed samples when `i_en` asserted).
  - Signal naming: instance prefixes `u_` for modules, regs use `r_`, wires use `w_`, inputs/outputs use `i_`/`o_` prefixes in modules.
  - Parameter-driven widths: modules compute localparams for effective widths (e.g., sign extension handled by concatenation: `{{(ACC_WIDTH-DATA_WIDTH){i_data[DATA_WIDTH-1]}}, i_data}`).
  - Signed arithmetic used throughout; maintain correct sign extension when changing widths.
  - Quantizer is a 1-bit comparator (non-negative -> 1); feedback subtracts/adds a signed `FEEDBACK_MAG` value.

- Test and simulation workflow (what works here)
  - Testbenches live under `src/tb/`. The primary top testbench is `src/tb/tb_dsm_dac.v` which declares a large `r_input_signal` array of fixed-width samples.
  - Use `script/gen_input_signal.py` to generate the `r_input_signal` initialization lines and paste them into the testbench to reproduce stimuli.
  - Example quick simulation (typical):
    - Compile: `iverilog -g2012 -o tb_sim.exe src/rtl/*.v src/tb/tb_dsm_dac.v`
    - Run: `vvp tb_sim.exe`
    (Adjust for your simulator of choice; the design is standard Verilog-2001/2012 compatible.)
  - For waveform inspection, add `$dumpfile("dump.vcd"); $dumpvars(0, tb_dsm_dac);` to the testbench and open `dump.vcd` in `gtkwave`.

- Integration points & external dependencies
  - No build scripts committed; typical local workflows use a Verilog simulator (`iverilog`/`vvp`, `verilator`, or commercial tools). A Python 3 runtime is used for `script/gen_input_signal.py`.
  - There are no external IPs or vendor-specific primitives. Focus on signed arithmetic and parameterization when refactoring.

- Code change guidance for AI
  - Preserve parameterization: if you change `DATA_WIDTH`, update related localparam calculations (e.g., `DELTA_WIDTH`, `ACC_WIDTH`).
  - Keep sign-extension explicit and correct; prefer the existing concatenation pattern to extend signed inputs.
  - Maintain small module boundaries — add helper signals or internal modules rather than merging unrelated logic.
  - When touching testbenches: use `script/gen_input_signal.py` to produce stimulus blocks and add `$dumpvars` lines for easier debugging.

- Quick examples and idioms
  - Sign extend input: `wire signed [ACC_WIDTH-1:0] w_data_ext = {{(ACC_WIDTH-DATA_WIDTH){i_data[DATA_WIDTH-1]}}, i_data};`
  - 1-bit quantizer: `assign o_data = (i_data >= 0) ? 1'b1 : 1'b0;`
  - Feedback delta: `assign o_delta = w_data_ext - (i_quantized_bit ? w_pos : w_neg);`

If anything here is incomplete or you'd like additional examples (e.g., CI commands, preferred simulator, or commit style), tell me which areas to expand and I'll iterate. 
