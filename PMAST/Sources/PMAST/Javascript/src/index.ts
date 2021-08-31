import { fromMarkdown } from "mdast-util-from-markdown";
import { gfmFromMarkdown } from 'mdast-util-gfm';
import { gfm } from 'micromark-extension-gfm';
import { pandocMark } from 'micromark-extension-mark/dev/index.js';
import { pandocMarkFromMarkdown } from 'mdast-util-mark';

function parse(markdown: string): any {
    return fromMarkdown(markdown, {
        extensions: [gfm(), pandocMark()],
        mdastExtensions: [gfmFromMarkdown, pandocMarkFromMarkdown]
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