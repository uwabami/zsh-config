# -*- mode: makefile ; coding: utf-8;
_SRC_= .zshenv .zshrc
# module: zsh-syntax-highlighting
_SRC_ += $(shell find modules/zsh-syntax-highlighing -name *.zsh | grep -v test )
# module: anyframe
_SRC_ += $(shell find modules/anyframe -name *.zsh )
_SRC_ += modules/anyframe/anyframe-init
# update target
TARGET=$(_SRC_:%=%.zwc)

all: check $(TARGET)

check:
	@chmod a-x $(_SRC_)

%.zwc: %
	zsh -fc "zcompile $*"

clean:
	rm -f $(TARGET)
