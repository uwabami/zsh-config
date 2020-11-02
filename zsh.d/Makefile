# -*- mode: makefile ; coding: utf-8;
_SRC_  = .zshenv .zshrc
_SRC_ += $(shell find functions -type f | grep -v zwc)
ifeq ($(shell test -f tmp/userinfo && echo -n yes),yes)
	_SRC_ += tmp/userinfo
endif
_SRC_ += tmp/$(USER)-zcompdump
# module: zsh-syntax-highlighting
_SRC_ += $(shell find modules/zsh-syntax-highlighting -name *.zsh | grep -v test )
# module: zsh-completion
_SRC_ += $(shell find modules/zsh-completions/src -type f | grep -v .zwc)
# module: zsh-async
_SRC_ += $(shell find modules/zsh-async -type f -name async.zsh | grep -v .zwc)
# update target
TARGET=$(_SRC_:%=%.zwc)

all: check $(TARGET)

check:
	@zsh -ic exit
	@chmod a-x $(_SRC_)

%.zwc: %
	zsh -fc "zcompile $*"

clean:
	rm -f $(TARGET)

update:
	git submodule foreach git fetch --all
	git submodule foreach git rebase origin/master
	git add modules
	git commit -s -m "Update submodule"
