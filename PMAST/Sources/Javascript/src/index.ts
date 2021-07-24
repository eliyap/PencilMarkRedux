import { fromMarkdown } from "mdast-util-from-markdown";
import { gfmFromMarkdown, gfmToMarkdown } from 'mdast-util-gfm';
import { gfm } from 'micromark-extension-gfm';
import { Root } from "mdast-util-from-markdown/lib";

function parse(markdown: string): any {
    return fromMarkdown(markdown, {
        extensions: [gfm()],
        mdastExtensions: [gfmFromMarkdown]
    });
}

// safety check function to make sure Swift-JS bridge is working
function echo(markdown: string): string {
    return markdown
}

export {
    parse,
    echo,
}