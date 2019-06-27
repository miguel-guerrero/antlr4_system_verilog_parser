#!/usr/bin/env python3
import json

#Example of visitor of a JSON tree

def transverseTree(tree, visitNodeFn, visitTermFn, level=0):
    if isinstance(tree, dict):
        rootName = list(tree.keys())[0]
        if visitNodeFn:
            visitNodeFn(rootName, tree, level, True)
        childs = tree[rootName]
        if isinstance(childs, list):
            for item in childs:
                transverseTree(item, visitNodeFn, visitTermFn, level+1)
        else:
            transverseTree(childs, visitNodeFn, visitTermFn, level+1)
        if visitNodeFn:
            visitNodeFn(rootName, tree, level, False)
    else:
        if visitTermFn:
            visitTermFn(tree, level)


if __name__=='__main__':
    import sys
    if len(sys.argv) == 2:
        fileName = sys.argv[1]
    else:
        print(f'Usage: {sys.argv[0]} filename.json', file=sys.stderr)
        sys.exit(1)

    with open(fileName) as f:
        d = json.load(f)

    #the function called every time we enter or exit a non terminal
    #user defined
    def showNode(nodeName, treeDict, level, entering):
        if entering:
            print('//'+' '*level + nodeName)

    #the function called on every terminal - user defined
    def showTerm(term, level):
        if term != "<EOF>":
            print(' '*level + term)

    transverseTree(d, showNode, showTerm)

