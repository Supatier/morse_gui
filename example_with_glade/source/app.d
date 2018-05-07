import gtk.Builder;
import gtk.Main;
import gtk.Window;
import gtk.Entry;
import gtk.Button;
// import gtk.Label;
import gtk.EditableIF;
import libmorse;

import std.algorithm : map;
import std.array : array, join;
import std.conv : text;
import std.getopt : getopt;
import std.stdio : writeln;
import std.string : toUpper;
import std.functional : toDelegate;

Window w;
Entry e, t;
int main(string[] args) {
        Main.init(args);
        Builder b = new Builder();
        b.addFromString(import("asd.glade"));

        w = cast(Window) b.getObject("window");
        e = cast(Entry) b.getObject("text_entry");
        t = cast(Entry) b.getObject("text_display");

        Button exitButton = cast(Button) b.getObject("exit_button");
        exitButton.addOnPressed(toDelegate(&onExitButtonClicked));
        e.addOnChanged(toDelegate(&onTextEntryChanged));
        b.connectSignals(null);

        w.showAll();
        Main.run();
        return 0;
}

void onExitButtonClicked(Button input) {
        Main.quit();
}

void onTextEntryChanged(EditableIF input) {
        string ret;
        string[] next = toUpper(e.getText()).map!text.array;
        foreach (i, e; next) {
                if (e in morseCode) {
                        ret ~= morseCode[e];
                } else {
                        writeln("Symbol :", e, " has no morsecode.");
                }
                ret ~= " ";
        }

        if (ret == null) {
                ret = " ";
        }
        t.setText(ret);
}
