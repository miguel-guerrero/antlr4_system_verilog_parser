#!/usr/bin/env python3

from io import StringIO
from antlr4.Utils import escapeWhitespace
from antlr4.tree.Tree import Tree
from antlr4.tree.Tree import RuleNode, ErrorNode, TerminalNode, Tree, ParseTree
import re

# need forward declaration
Parser = None

def escapeInnerSingleQuotes(s):
    assert s[0]=="'" and s[-1]=="'"
    inner = re.sub("'", "\\'", s[1:-1])
    return "'"+inner+"'"

def escapeInnerDoubleQuotes(s):
    assert s[0]=="'" and s[-1]=="'"
    inner = re.sub('"', '\\"', s[1:-1])
    return "'"+inner+"'"

def getNodeText(t:Tree, ruleNames:list=None, recog:Parser=None):
    if recog is not None:
        ruleNames = recog.ruleNames
    if ruleNames is not None:
        if isinstance(t, RuleNode):
            if t.getAltNumber()!=0: # should use ATN.INVALID_ALT_NUMBER but won't compile
                return ruleNames[t.getRuleIndex()]+":"+str(t.getAltNumber()), False
            return ruleNames[t.getRuleIndex()], False
        elif isinstance(t, ErrorNode):
            return str(t), False
        elif isinstance(t, TerminalNode):
            if t.symbol is not None:
                return "'"+t.symbol.text+"'", True
    # no recog for rule names
    payload = t.getPayload()
    if isinstance(payload, Token):
        return '<'+payload.text+'>', False
    return str(t.getPayload()), False


def toLispStringTree(t:Tree, ruleNames:list=None, recog:Parser=None, indent="\t", separateEnding=False, level=0):
    if recog is not None:
        ruleNames = recog.ruleNames
    nodeText, terminal = getNodeText(t, ruleNames)
    s = escapeWhitespace(nodeText, False)
    if t.getChildCount()==0:
        if s[0]=="'":
            return "\n" + indent*level + escapeInnerSingleQuotes(s)
    with StringIO() as buf:
        if level > 0:
            buf.write("\n" + indent*level)
        buf.write("("+s)
        for i in range(0, t.getChildCount()):
            buf.write(toLispStringTree(t.getChild(i), ruleNames, recog, indent, separateEnding, level+1))
        if level > 0 and separateEnding:
            buf.write("\n" + indent*level)
        buf.write(")")
        return buf.getvalue()

def toListStringTree(t:Tree, ruleNames:list=None, recog:Parser=None, indent="\t", separateEnding=False, level=0):
    if recog is not None:
        ruleNames = recog.ruleNames
    nodeText, terminal = getNodeText(t, ruleNames)
    s = escapeWhitespace(nodeText, False)
    if t.getChildCount()==0:
        if s[0]=="'":
            return "\n" + indent*level + escapeInnerSingleQuotes(s)
    with StringIO() as buf:
        if level > 0:
            buf.write("\n" + indent*level)
        buf.write("["+s)
        numChilds = t.getChildCount()
        for i in range(numChilds):
            sep = ',' if i < numChilds-1 else ''
            buf.write(toLispStringTree(t.getChild(i), ruleNames, recog, indent, separateEnding, level+1)+sep)
        if level > 0 and separateEnding:
            buf.write("\n" + indent*level)
        buf.write("]")
        return buf.getvalue()


def toJsonStringTree(t:Tree, recog:Parser=None, indent="\t"):

    def subJsonStringTree(t:Tree, ruleNames:list, indent, level=0, inArray=True):
        nodeText, terminal = getNodeText(t, ruleNames)
        s = escapeWhitespace(nodeText, False)
        numChilds = t.getChildCount()
        with StringIO() as buf:
            tab = indent*level
            if inArray:
                buf.write('\n'+tab)
            if numChilds==0 and terminal:
                s = escapeInnerDoubleQuotes(s)
                s = s[1:-1] #un-single-quote
                buf.write('"'+s+'"')
            else:
                tab2 = indent*(level+1)
                if numChilds==1:
                    buf.write('{\n'+tab2+'"'+s+'": ')
                    buf.write(subJsonStringTree(t.getChild(0), ruleNames, indent, level+1, False))
                    buf.write('\n'+tab+"}")
                else:
                    buf.write('{\n'+tab2+'"'+s+'": [')
                    if numChilds==0:
                        buf.write("]")
                    else:
                        for i in range(numChilds):
                            sep = ',' if i < numChilds-1 else ''
                            buf.write(subJsonStringTree(t.getChild(i), ruleNames, indent, level+2, True)+sep)
                        buf.write('\n'+tab2+"]")
                    buf.write('\n'+tab+"}")
            return buf.getvalue()

    if recog is not None:
        ruleNames = recog.ruleNames
    with StringIO() as buf:
        buf.write(subJsonStringTree(t, ruleNames, indent, 0, False))
        return buf.getvalue()

