MAKE_CACHE_DIR := build/make_cache
# See https://www.gnu.org/software/make/manual/html_node/General-Search.html#General-Search ...
VPATH := $(MAKE_CACHE_DIR)
PROD_SRC_FILES := $(shell find lib -name *.dart -print)
TEST_SRC_FILES := $(shell find test -name *.dart -print)

.PHONY: flutter_pub_get

pre-commit: flutter_format flutter_analyze $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	@touch $(MAKE_CACHE_DIR)/$@

flutter_format: $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	flutter format --line-length 120 lib/ test/ > /dev/null
	@touch $(MAKE_CACHE_DIR)/$@

flutter_analyze: $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	flutter analyze --no-pub --fatal-warnings
	@touch $(MAKE_CACHE_DIR)/$@

br:
	flutter pub run build_runner build --delete-conflicting-outputs

l10n:
	fvm flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart

$(MAKE_CACHE_DIR):
	mkdir -p $@
