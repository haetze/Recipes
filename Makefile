### Makefile --- 

## Author: richard.stewing@udo.edu

REPOSITORY:=https://github.com/haetze/Recipes.git

ORG-DIR:= org
HTML-DIR:= html
MD-DIR:=md

ORG-SRC:=$(wildcard $(ORG-DIR)/*.org)
HTML-OBJ:=$(patsubst $(ORG-DIR)/%.org,$(HTML-DIR)/%.html,$(ORG-SRC))
MD-OBJ:=$(patsubst $(ORG-DIR)/%.org,$(MD-DIR)/%.md,$(ORG-SRC))

help:
	@echo "Available Targets:"
	@echo "  clean:      Removes target files."
	@echo "  website:    Creates HTML Files in html/"
	@echo "  publish:    Commit with current date and time and push to $(REPOSITORY)"


clean:
	rm -f $(HTML-DIR)/*.html
	rm -f *~
	rm -f org/*~

html/%.html : org/%.org util/settings.org util/common.org
	mkdir -p $(HTML-DIR)
	emacs --batch -l src/config.el $< -f org-html-export-to-html --kill
	mv org/$(@F) $@

md/%.md : org/%.org util/settings.org util/common.org
	mkdir -p $(MD-DIR)
	emacs --batch -l src/config.el $< -f org-md-export-to-markdown --kill
	mv org/$(@F) $@


website: $(HTML-OBJ)
markdown: $(MD-OBJ)

publish:
	git commit -m "$(shell date)" -a || true
	git push
