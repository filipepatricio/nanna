MAKE_CACHE_DIR := build/make_cache
# See https://www.gnu.org/software/make/manual/html_node/General-Search.html#General-Search ...
VPATH := $(MAKE_CACHE_DIR)
PROD_SRC_FILES := $(shell find lib -name *.dart -print)
TEST_SRC_FILES := $(shell find test -name *.dart -print)

.PHONY: flutter_pub_get

pre-commit: flutter_format flutter_analyze $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	@touch $(MAKE_CACHE_DIR)/$@

flutter_format: $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	fvm flutter format --line-length 120 lib/ test/ > /dev/null
	@touch $(MAKE_CACHE_DIR)/$@

flutter_analyze: $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	fvm flutter analyze --no-pub --fatal-warnings
	@touch $(MAKE_CACHE_DIR)/$@

get:
	flutter pub get

br:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

l10n:
	fvm flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart

build_runner:
	flutter pub run build_runner build --delete-conflicting-outputs

easy_localization:
	flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart

unit_tests:
	-flutter test test/unit/wrapper_test.dart

fvm_unit_tests:
	-fvm flutter test test/unit/wrapper_test.dart

update_goldens:
	-flutter test test/visual/wrapper_test.dart --update-goldens
	-flutter test test/visual/wrapper_dark_test.dart --update-goldens

fvm_update_goldens:
	-fvm flutter test test/visual/wrapper_test.dart --update-goldens
	-fvm flutter test test/visual/wrapper_dark_test.dart --update-goldens

screens_report:
	dart scripts/screens_report.dart

fvm_screens_report:
	-fvm dart scripts/screens_report.dart

ui_changes_report:
	dart scripts/ui_changes_report.dart

fvm_ui_changes_report:
	-fvm dart scripts/ui_changes_report.dart

graphql_schema:
	get-graphql-schema https://api.staging.informed.so/graphql > lib/data/gql/config/schema.graphql

start_app_sksl:
	fvm flutter run --profile --cache-sksl --flavor prod --dart-define=env=prod


$(MAKE_CACHE_DIR):
	mkdir -p $@
