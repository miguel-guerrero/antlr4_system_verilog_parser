
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class TreeUtils {

    public static String escapeInnerSingleQuotes(String s) {
        String inner = s.substring(1, s.length()-1);
        inner = inner.replaceAll("'", "\\\\'");
        return "'"+inner+"'";
    }

    public static String escapeInnerDoubleQuotes(String s) {
        String inner = s.substring(1, s.length()-1);
        inner = inner.replaceAll("\"", "\\\\\"");
        return "\""+inner+"\"";
    }

	public static String getNodeText(Tree t, List<String> ruleNames) {
		if ( ruleNames!=null ) {
			if ( t instanceof RuleContext ) {
				int ruleIndex = ((RuleContext)t).getRuleContext().getRuleIndex();
				String ruleName = ruleNames.get(ruleIndex);
				int altNumber = ((RuleContext) t).getAltNumber();
				if ( altNumber!=ATN.INVALID_ALT_NUMBER ) {
					return ruleName+":"+altNumber;
				}
				return ruleName;
			}
			else if ( t instanceof ErrorNode) {
				return t.toString();
			}
			else if ( t instanceof TerminalNode) {
				Token symbol = ((TerminalNode)t).getSymbol();
				if (symbol != null) {
					String s = symbol.getText();
					return "'"+s+"'";
				}
			}
		}
		// no recog for rule names
		Object payload = t.getPayload();
		if ( payload instanceof Token ) {
			return ((Token)payload).getText();
		}
		return t.getPayload().toString();
	}

	public static String toLispStringTree(Tree t, Parser recog) {
	    return toLispStringTree(t, recog, "\t");
	}

	public static String toLispStringTree(Tree t, Parser recog, String indent) {
		String[] ruleNames = recog != null ? recog.getRuleNames() : null;
		List<String> ruleNamesList = ruleNames != null ? Arrays.asList(ruleNames) : null;
		return toLispStringTree(t, ruleNamesList, indent, 0);
	}

	public static String toLispStringTree(final Tree t, final List<String> ruleNames, String indent, int level) {
		String s = Utils.escapeWhitespace(getNodeText(t, ruleNames), false);
        String tab = "";
        if (level > 0)
            tab = new String(new char[level]).replace("\0", indent);
		if (t.getChildCount() == 0)
            if (s.charAt(0)=='\'')
                return "\n"+tab+escapeInnerSingleQuotes(s);
		StringBuilder buf = new StringBuilder();
        if (level > 0)
            buf.append("\n"+tab);
		buf.append("("+s);
		for (int i = 0; i<t.getChildCount(); i++)
			buf.append(toLispStringTree(t.getChild(i), ruleNames, indent, level+1));
		buf.append(")");
		return buf.toString();
	}

	public static String toJsonStringTree(Tree t, Parser recog) {
	    return toJsonStringTree(t, recog, "\t");
    }

	public static String toJsonStringTree(Tree t, Parser recog, String indent) {
		String[] ruleNames = recog != null ? recog.getRuleNames() : null;
		List<String> ruleNamesList = ruleNames != null ? Arrays.asList(ruleNames) : null;
		return toJsonStringTree(t, ruleNamesList, indent, 0, false);
	}

	public static String toJsonStringTree(final Tree t, final List<String> ruleNames, 
            String indent, int level, boolean inArray) {

		String s = Utils.escapeWhitespace(getNodeText(t, ruleNames), false);
        boolean terminal = s.charAt(0) == '\'';

        int numChilds = t.getChildCount();
		StringBuilder buf = new StringBuilder();
        String tab = "";
        if (level > 0)
            tab = new String(new char[level]).replace("\0", indent);

        if (inArray)
            buf.append("\n"+tab);

        if (numChilds==0 && terminal) {
            s = escapeInnerDoubleQuotes(s);
            s = s.substring(1, s.length()-1); // un-single-quote
            buf.append("\""+s+"\"");
        } else {
            String tab2 = tab + indent;
            if (numChilds==1) {
                buf.append("{\n"+tab2+"\""+s+"\": ");
                buf.append(toJsonStringTree(t.getChild(0), ruleNames, indent, level+1, false));
                buf.append("\n"+tab+"}");
            } else {
                buf.append("{\n"+tab2+"\""+s+"\": [");
                if (numChilds==0)
                    buf.append("]");
                else {
                    for (int i=0; i<numChilds; i++) {
                        String sep="";
                        if (i < numChilds-1)
                            sep = ",";
                        buf.append(toJsonStringTree(t.getChild(i), ruleNames, indent, level+2, true)+sep);
                    }
                    buf.append('\n'+tab2+"]");
                }
                buf.append('\n'+tab+"}");
            }
        }
        return buf.toString();
    }
}
