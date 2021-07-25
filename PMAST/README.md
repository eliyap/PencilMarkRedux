# PMAST
### PencilMark Abstract Syntax Tree

### Dependencies
The core of the package is a Swift Wrapper around the UnifiedJS MarkDown Abstract Syntax Tree (MDAST)
The rest of the package is PencilMark specific methods for manipulating the AST, 
then manipulating the source Markdown to effect those changes.

### Public Methods / Classes
- StyledMarkdown – the core
    - `apply` and `erase` to request specific changes to the markdown
- Styling Classes
