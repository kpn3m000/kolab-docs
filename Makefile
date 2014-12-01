# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build
SPHINXINTL    = sphinx-intl
INTL_LOCALES  = -l de -l fr -l zh_CN
# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
HELPDOCS_LOCALES = de_DE:de fr_FR:fr zh_CN:zh_CN

.PHONY: help clean html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck doctest gettext

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   to make LaTeX files and run them through pdflatex"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  texinfo    to make Texinfo files"
	@echo "  info       to make Texinfo files and run them through makeinfo"
	@echo "  gettext    to make PO message catalogs"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"

submodules:
	@if [ ! -d "source/webmail-user-guide/roundcubemail/.git" -o ! -f "ext/kolab/fancyfigure/__init__.py" ]; then \
		if [ -x "$$(which git 2>/dev/null)" ]; then \
			git submodule init ; \
			git submodule update ; \
		fi ; \
	fi

helplocales:
	@for langmap in $(HELPDOCS_LOCALES); do \
		lang=$${langmap:0:5} ; \
		destlang=$${langmap#*:} ; \
		echo $$lang "=>" $$destlang ; \
		if [ -d "locale/$$destlang" ]; then \
			mkdir -p locale/$$destlang/LC_MESSAGES/webmail-user-guide/roundcubemail ; \
			ln -sf ../../../../../source/webmail-user-guide/roundcubemail/locale/$$lang/LC_MESSAGES locale/$$destlang/LC_MESSAGES/webmail-user-guide/roundcubemail/en_US ; \
		fi ; \
		for docs in $$(find source/webmail-user-guide/roundcubemail-plugins-kolab -type d -name "helpdocs"); do \
			if [ -d "locale/$$destlang/LC_MESSAGES/webmail-user-guide/roundcubemail/en_US" ]; then \
				plugin=$$(basename $$(dirname $$docs)) ; \
				mkdir -p locale/$$destlang/LC_MESSAGES/webmail-user-guide/roundcubemail/en_US/_plugins ; \
				ln -sf $$(pwd)/$$docs/locale/$$lang/LC_MESSAGES locale/$$destlang/LC_MESSAGES/webmail-user-guide/roundcubemail/en_US/_plugins/$$plugin ; \
			fi ; \
		done ; \
	done

helpdocs: submodules
	@cd source/webmail-user-guide/roundcubemail/en_US/_plugins/ ; \
	for docs in $$(find ../../../roundcubemail-plugins-kolab/ -type d -name "helpdocs"); do \
		plugin=$$(basename $$(dirname $$docs)) ; \
		ln -sf $$docs/en_US/ $$plugin ; \
	done

locales: gettext helplocales

clean:
	@rm -rf $(BUILDDIR)/*
	@rm -rf source/webmail-user-guide/roundcubemail/
	@rm -rf source/webmail-user-guide/roundcubemail-plugins-kolab/
	@rm -rf source/*/_fancyfigures/
	@rm -rf locale/*/LC_MESSAGES/webmail-user-guide/roundcubemail

html: submodules
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

dirhtml: clean
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

singlehtml: clean
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

pickle: clean
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

json: clean
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp: clean
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp: clean
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/KolabGroupware.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/KolabGroupware.qhc"

devhelp: clean
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo
	@echo "Build finished."
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/KolabGroupware"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/KolabGroupware"
	@echo "# devhelp"

epub: clean
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

latex: clean
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

latexpdf: clean
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

text: clean
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

man: clean
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo
	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

texinfo: clean
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo
	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
	@echo "Run \`make' in that directory to run these through makeinfo" \
	      "(use \`make info' here to do that automatically)."

info: clean
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo "Running Texinfo files through makeinfo..."
	make -C $(BUILDDIR)/texinfo info
	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

gettext: clean submodules
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
	$(SPHINXINTL) update -p $(BUILDDIR)/locale -d locale $(INTL_LOCALES)
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."
	rm -rf locale/*/LC_MESSAGES/webmail-user-guide/roundcubemail

update-txconfig-resources: gettext
	rm -rf $(BUILDDIR)/locale/webmail-user-guide
	$(SPHINXINTL) update-txconfig-resources --transifex-project-name kolab-documentation -p $(BUILDDIR)/locale -d locale
	@echo
	@echo "Transifex resources have been updated."

changes: clean
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck: clean
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest: clean
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."
