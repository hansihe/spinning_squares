# Expects an EIR_PATH environment variable pointing to your Eir checkout

MODULE_DIR = _build/dev/lumen/spinning_squares/src
MODULE_ABSTR_FILES = $(wildcard $(MODULE_DIR)/*.abstr)
MODULE_EIR_FILES = $(MODULE_ABSTR_FILES:.abstr=.eir)
MODULE_NAMES = $(notdir $(MODULE_EIR_FILES))

.PHONY: all compile check_env browser_interpreter write_out

full: compile eir_files browser_interpreter write_out

compile:
	mix compile
	mix compile.lumen

%.eir : %.abstr check_env
	cargo run --manifest-path $(EIR_PATH)/tools/Cargo.toml -- -f abstr -o $@ $<

eir_files: $(MODULE_EIR_FILES)

browser_interpreter: check_env
	mkdir -p out/www
	mkdir -p out/pkg
	cd $(LUMEN_PATH)/examples/interpreter-in-browser; wasm-pack build
	cp -r $(LUMEN_PATH)/examples/interpreter-in-browser/www/* out/www
	cp -r $(LUMEN_PATH)/examples/interpreter-in-browser/pkg/* out/pkg

write_out:
	mkdir -p out/www/src
	for file in $(MODULE_EIR_FILES) ; do\
		cp $${file} out/www/src/$$(basename $${file}) ;\
	done
	bash write_index.sh "$(MODULE_NAMES)"

server:
	cd out/www; npm start

check_env:
ifndef EIR_PATH
	$(error EIR_PATH is undefined)
endif
ifndef LUMEN_PATH
	$(error LUMEN_PATH is undefined)
endif
