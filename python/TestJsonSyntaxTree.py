#!/usr/bin/env python3
import json

def transverseTree(tree, visitNode, visitTerm, level=0):
    #print(' '*level+'level', level)
    if isinstance(tree, dict):
        #print(' '*level+'dict')
        rootName = list(tree.keys())[0]
        if visitNode:
            visitNode(rootName, tree, level, True)
        childs = tree[rootName]
        if isinstance(childs, list):
            for item in childs:
                transverseTree(item, visitNode, visitTerm, level+1)
        else:
            transverseTree(childs, visitNode, visitTerm, level+1)
        if visitNode:
            visitNode(rootName, tree, level, False)
    else:
        #print(' '*level+'term', tree)
        if visitTerm:
            visitTerm(tree, level)


def showNode(nodeName, treeDict, level, entering):
    if entering:
        print('//'+'\t'*level + nodeName)


def showTerm(term, level):
    if term != "<EOF>":
        print('\t'*level + term)

if __name__=='__main__':
    import sys
    fileName = 'adder.json'
    if len(sys.argv) > 1:
        fileName = sys.argv[1]
    with open(fileName) as f:
        d = json.load(f)
    transverseTree(d, showNode, showTerm)
    #transverseTree(d, None, showTerm)

