BUNDLE = bundle exec

doc:
	@$(BUNDLE) jazzy \
		--min-acl public \
		--no-hide-documentation-coverage \
		--theme fullwidth \
		--output ./docs \
		--documentation=./*.md

doc-publish: doc
	@$(MAKE) -C docs publish
