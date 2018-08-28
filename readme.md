# FoxDot.vim

A plugin for executing [FoxDot](http://foxdot.org) code from within vim.

## Setup

You need to configure two variables:

```{.vim}
let g:sclang_executable_path = /absolute/path/to/sclang
let g:python_executable_path = /absolute/path/to/python
```

## Usage

You can FoxDot by running `:FoxDotStart`, and then you can eval a block of code by hitting
Ctrl-Enter.

You can reboot FoxDot by running `:FoxDotReboot`.

That's all it does.

## Dependencies

This plugin depends on Vim 8.x

To use this, you also need to have SuperCollider and FoxDot installed as per the instructions
[here](http://foxdot.org/installation).

## Warning

This plugin is pretty rough and ready. I've only tested it on my own setup, which is a little
unusual. YMMV.

