# -*- mode: makefile ; coding: utf-8;
_SRC_  = .zshenv .zshrc
_SRC_ += $(shell find functions -type f | grep -v zwc)
ifeq ($(shell test -f tmp/userinfo && echo -n yes),yes)
	_SRC_ += tmp/userinfo
endif
# module: zsh-syntax-highlighting
_SRC_ += $(shell find modules/zsh-syntax-highlighting -name *.zsh | grep -v test )
# module: anyframe
_SRC_ += $(shell find modules/anyframe -name *.zsh )
_SRC_ += modules/anyframe/anyframe-init
# module: zsh-completion
_SRC_ += $(shell find modules/zsh-completions/src -type f | grep -v .zwc)
# update target
TARGET=$(_SRC_:%=%.zwc)

all: check $(TARGET)

check:
	@chmod a-x $(_SRC_)

%.zwc: %
	zsh -fc "zcompile $*"

clean:
	rm -f $(TARGET)
