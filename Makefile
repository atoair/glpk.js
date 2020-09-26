EMCC_FLAGS :=
EMCC_FLAGS += -s RETAIN_COMPILER_SETTINGS=1
EMCC_FLAGS += -s INITIAL_MEMORY=16MB
EMCC_FLAGS += -s ALLOW_MEMORY_GROWTH=1
EMCC_FLAGS += -s EXPORTED_FUNCTIONS="[ \
	'_glp_version', \
	'_glp_create_prob', \
	'_glp_erase_prob', \
	'_glp_delete_prob', \
	'_glp_create_index', \
	'_glp_set_prob_name', \
	'_glp_get_prob_name', \
	'_glp_set_obj_dir', \
	'_glp_find_col', \
	'_glp_set_col_bnds', \
	'_glp_set_row_bnds', \
	'_glp_set_obj_coef', \
	'_glp_add_rows', \
	'_glp_add_cols', \
	'_glp_set_row_name', \
	'_glp_set_col_name', \
	'_glp_set_mat_row', \
	'_glp_set_col_kind', \
	'_glp_get_col_lb', \
	'_glp_get_col_ub', \
	'_glp_delete_index', \
	'_glp_sort_matrix', \
	'_glp_get_num_int', \
	'_glp_get_num_bin', \
	'_glp_get_num_cols', \
	'_glp_get_num_rows', \
	'_glp_mip_obj_val', \
	'_glp_mip_status', \
	'_glp_get_col_name', \
	'_glp_get_row_name', \
	'_glp_mip_col_val', \
	'_glp_get_obj_val', \
	'_glp_get_status', \
	'_glp_get_col_prim', \
	'_glp_get_row_dual', \
	'_glp_delete_prob', \
	'_glp_free_env', \
	'_glp_write_lp', \
	'_solve_lp', \
	'_solve_mip' \
	]"

PWD=$(shell pwd)

all: glpk glpk.js glpk-worker.js

glpk:
	cd $(PWD)/src/glpk && \
	autoreconf -fi && \
	emconfigure ./configure --disable-shared && \
	emmake make -j4 \

dist/glpk.js: src/pre.js src/post.js src/glpk.js.c
	cd $(PWD); \
	emcc -Os --memory-init-file 0 $(EMCC_FLAGS) \
	-Isrc/glpk/src \
	--pre-js src/pre.js --post-js src/post.js  \
	src/glpk/src/.libs/libglpk.a \
	src/glpk.js.c -o dist/glpk.js

dist/glpk-worker.js: src/pre.js src/post-worker.js src/glpk.js.c
	cd $(PWD); \
	emcc -Os --memory-init-file 0 $(EMCC_FLAGS) \
	-Isrc/glpk/src \
	--pre-js src/pre.js --post-js src/post-worker.js  \
	src/glpk/src/.libs/libglpk.a \
	src/glpk.js.c -o dist/glpk-worker.js

clean:
	rm -fr $(PWD)/dist/*;
	cd $(PWD)/src/glpk && make clean;
