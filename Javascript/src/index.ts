import { fromMarkdown } from "mdast-util-from-markdown";
import { Root } from "mdast-util-from-markdown/lib";

function parse(markdown: string): Root {
    return fromMarkdown(markdown);
}

export {
    parse,
}