#!/usr/bin/env python3

import sys
# from lxml import etree as ET
from xml.etree import ElementTree as ET


def process(fname):
    # an example of how to extract some info from a sv parse tree in XML format

    tree = ET.parse(open(fname, 'r'))

    interface_declarations = tree.findall('.//interface_declaration')
    for interface_declaration in interface_declarations:

        interface_ansi_headers = [i for i in interface_declaration.findall('.//interface_ansi_header')]
        for iah in interface_ansi_headers:
            nameNodes = iah.findall('./interface_identifier')
            for nameNode in nameNodes:
                print('interface name:', nameNode.text)
            paramNodes = iah.findall('.//parameter_port_declaration')
            for paramNode in paramNodes:
                paramIds = paramNode.findall('.//parameter_identifier')
                for paramId in paramIds:
                    print('paramId:', paramId.text)

        non_port_interface_items = interface_declaration.findall('.//non_port_interface_item')
        for non_port_interface_item in non_port_interface_items:
            variable_identifiers = non_port_interface_item.findall('.//variable_identifier')
            for variable_identifier in variable_identifiers:
                print('variable_identifier:', variable_identifier.text)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} filename.sv.xml\n")
        print("dumps informaion on interfaces  present in the input file\n")
        sys.exit(1)
    process(sys.argv[1])
