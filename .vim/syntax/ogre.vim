syn match Number "\<[0-9.]\+\>"

syn keyword StorageClass abstract

syn match Type "\(^\(abstract\)\?\s*\)\@<=\(\w\+\)\([^{]*\(\n\|\s\)*{\)\@="
syn match Keyword "\(^\(abstract\)\?\s*\)\@<=\(\w\+\)\([^{]*\(\n\|\s\)*{\)\@!"

syn match Identifier "$\w\+"

syn match Comment "//.*"

