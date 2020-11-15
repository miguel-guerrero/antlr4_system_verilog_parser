import java.io.IOException;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class Testjson {

    public static void main(String[] args) throws IOException {
        
        String fileName = "";
        if (args.length != 1) {
            System.out.println("ERROR: no input file specified");
            System.exit(1);
        }

        fileName = args[0];

        CharStream input = CharStreams.fromFileName(fileName);

        SvLexer lexer = new SvLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        
        SvParser parser = new SvParser(tokens);
        ParseTree tree = parser.source_text();

        String dump = TreeUtils.toJsonStringTree(tree, parser);

        System.out.println(dump);
    }
}
