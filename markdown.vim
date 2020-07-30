" fix the front-matter highlight error in markdown for Hugo
" See, https://github.com/tpope/vim-markdown/issues/112#issuecomment-285945848
unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml
