# Custom lexer for regex snippets
# This file is based on a blog entry by Lukas Matt.
# https://blog.matt.wf/regex-lexer-for-pygments/
# It has been modified to be more versatile
from pygments.lexer import RegexLexer, bygroups
from pygments.token import *

__all__ = ['regexLexer']

class regexLexer(RegexLexer):
    name = 'regex'
    aliases = ['regex']
    filenames = []

    tokens = {
        'root': [
            (r'=', Text),
            (r'\w+', Name),
            (r'\d+', Number),
            (r'[\s\,\:\-\"\']+', Text),
            (r'[\$\^]', Token),
            (r'[\+\*\.\?]', Operator),
            (r'(\()([\?\<\>\!\=\:]{2,3}.+?)(\))', bygroups(Keyword.Namespace, Name.Function, Keyword.Namespace)),
            (r'(\()(\?\#.+?)(\))', bygroups(Comment, Comment, Comment)),
            (r'[\(\)]', Keyword.Namespace),
            (r'[\[\]]', Name.Class),
            (r'\\\w', Keyword),
            (r'[\{\}]', Operator),
            (r'\\\.', Text),
            (r'\|', Operator),
        ],
    }
