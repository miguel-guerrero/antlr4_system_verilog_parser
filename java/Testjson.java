import java.io.IOException;

import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

public class Testjson {

    public static void main(String[] args) throws IOException {
        
        String fileName = "adder.v";
        if (args.length > 0)
            fileName = args[0];

        ANTLRInputStream input = new ANTLRFileStream(fileName);

        SvLexer lexer = new SvLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        
        SvParser parser = new SvParser(tokens);
        ParseTree tree = parser.source_text();

        String dump = TreeUtils.toJsonStringTree(tree, parser);

        System.out.println(dump);
    }
}
